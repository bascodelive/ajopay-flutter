import 'dart:async';
import 'dart:convert';

import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/network/env.dart';
import '../../../core/storage/secure_token_storage.dart';
import '../../account/application/account_controller.dart';
import 'message_thread_pager.dart';
import '../data/models/message_models.dart';

part 'message_stream_controller.g.dart';

/// One live connection per LEDGER, not per thread — matches the backend
/// exactly (MessageStreamRegistry: "One connection per ledger per user
/// (not per-thread)"). Owns that one connection, routes each incoming
/// event to the right group/private pager, and — the part that matters
/// for a long-lived screen — keeps itself alive across both token
/// expiry and ordinary connection drops.
///
/// **Token freshness, without duplicating refresh logic:** this SSE
/// connection bypasses Dio entirely (a raw long-lived HTTP connection,
/// not a request/response call), so `AuthInterceptor`'s 401-refresh-
/// and-retry never applies to it automatically. Rather than writing a
/// SECOND, independent refresh call here — which would race against
/// `AuthInterceptor`'s own single-in-flight refresh and risk using an
/// already-rotated, dead refresh token (yours are single-use) — this
/// periodically fires one ordinary, cheap request through the SAME
/// shared, already-intercepted `dioProvider` Dio instance
/// (`GET /api/account/profile`). If the access token is stale,
/// `AuthInterceptor` transparently refreshes it exactly as it would for
/// any other screen's request; this then reconnects the SSE stream,
/// which reads whatever fresh token secure storage now holds. That's
/// deliberately simpler than trying to introspect a JWT's expiry
/// client-side.
///
/// **Separately, reconnect-on-drop:** an ordinary network blip, the app
/// backgrounding, or the server closing the connection all surface as
/// `onError`/`onDone` on the stream — handled with a capped exponential
/// backoff (2s, 4s, 8s, 16s, capped at 30s), distinct from the proactive
/// keep-alive above.
@Riverpod(keepAlive: true)
class MessageStreamController extends _$MessageStreamController {
  StreamSubscription<SSEModel>? _subscription;
  String? _connectedLedgerId;
  Timer? _keepAliveTimer;
  Timer? _reconnectTimer;
  int _reconnectAttempt = 0;

  // Distinguishes a deliberate disconnect() (user left the screen) from
  // an unexpected drop — only the latter should trigger a reconnect.
  bool _intentionallyDisconnected = false;

  // Tune this against your backend's actual configured access-token
  // TTL — this should stay meaningfully shorter than it (e.g. half),
  // so a proactive refresh always lands before real expiry rather than
  // racing it. 5 minutes is a conservative placeholder; confirm the
  // real TTL and adjust.
  static const _keepAliveInterval = Duration(minutes: 5);
  static const _maxBackoffSeconds = 30;

  @override
  void build() {
    ref.onDispose(_teardown);
  }

  Future<void> connect(String ledgerId) async {
    _intentionallyDisconnected = false;
    if (_connectedLedgerId == ledgerId && _subscription != null) return;
    _teardown();
    await _openConnection(ledgerId);
  }

  Future<void> _openConnection(String ledgerId) async {
    final accessToken =
        await ref.read(secureTokenStorageProvider).getAccessToken();
    final url = '${Env.apiBaseUrl}/api/ledgers/$ledgerId/messages/stream';

    _subscription = SSEClient.subscribeToSSE(
      method: SSERequestType.GET,
      url: url,
      header: {
        if (accessToken != null && accessToken.isNotEmpty)
          'Authorization': 'Bearer $accessToken',
        'X-API-Key': Env.apiKey,
      },
    ).listen(
      (event) => _handleEvent(ledgerId, event),
      onError: (_) => _scheduleReconnect(ledgerId),
      onDone: () => _scheduleReconnect(ledgerId),
    );

    _connectedLedgerId = ledgerId;
    _reconnectAttempt = 0; // a successful (re)connect resets backoff

    _keepAliveTimer?.cancel();
    _keepAliveTimer = Timer.periodic(
      _keepAliveInterval,
      (_) => _refreshTokenThenReconnect(ledgerId),
    );
  }

  Future<void> _refreshTokenThenReconnect(String ledgerId) async {
    if (_connectedLedgerId != ledgerId) return; // screen moved on already

    try {
      // The point isn't the response — it's forcing AuthInterceptor's
      // normal refresh-on-401 path to run if the token has gone stale.
      await ref.read(dioProvider).get('/api/account/profile');
    } catch (_) {
      // A genuine failure beyond the expected transparent 401-refresh-
      // retry doesn't need special handling here — reconnecting anyway
      // is harmless, and if the connection still can't authenticate,
      // the normal onError/backoff path below takes over.
    }

    if (_connectedLedgerId == ledgerId) {
      await _openConnection(
          ledgerId); // picks up whatever token secure storage holds now
    }
  }

  void _scheduleReconnect(String ledgerId) {
    if (_intentionallyDisconnected || _connectedLedgerId != ledgerId) return;

    _reconnectAttempt++;
    final exponent =
        _reconnectAttempt.clamp(1, 5); // caps 2^5=32 before the final clamp
    final delaySeconds = (2 << (exponent - 1)).clamp(2, _maxBackoffSeconds);

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: delaySeconds), () {
      if (_intentionallyDisconnected || _connectedLedgerId != ledgerId) return;
      _openConnection(ledgerId);
    });
  }

  void _handleEvent(String ledgerId, SSEModel event) {
    if (event.event != 'message' || event.data == null) return;

    final json = jsonDecode(event.data!) as Map<String, dynamic>;
    final message = MessageResponse.fromJson(json);

    if (message.broadcast) {
      ref
          .read(messageThreadPagerProvider((
            ledgerId: ledgerId,
            type: MessageThreadType.group,
            otherUserId: null,
          )).notifier)
          .prependIncoming(message);
      return;
    }

    final myUserId = ref.read(accountControllerProvider).valueOrNull?.id;
    if (myUserId == null) return;

    final otherUserId =
        message.senderId == myUserId ? message.recipientId : message.senderId;
    if (otherUserId == null) return;

    ref
        .read(messageThreadPagerProvider((
          ledgerId: ledgerId,
          type: MessageThreadType.private,
          otherUserId: otherUserId,
        )).notifier)
        .prependIncoming(message);
  }

  Future<void> disconnect() async {
    _intentionallyDisconnected = true;
    _teardown();
  }

  void _teardown() {
    _keepAliveTimer?.cancel();
    _keepAliveTimer = null;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _subscription?.cancel();
    _subscription = null;
    _connectedLedgerId = null;
    _reconnectAttempt = 0;
  }
}
