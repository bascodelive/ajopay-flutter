// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_stream_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$messageStreamControllerHash() =>
    r'3331ff384321f813a5b84822313af496f4abaa18';

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
/// already-rotated, dead refresh token (yours are single-use) — every
/// path that opens a real connection first fires one ordinary, cheap
/// request through the SAME shared, already-intercepted `dioProvider`
/// Dio instance (`GET /api/account/profile`). If the access token is
/// stale, `AuthInterceptor` transparently refreshes it exactly as it
/// would for any other screen's request; only then does this open the
/// SSE connection, reading whatever fresh token secure storage now
/// holds.
///
/// **This "probe before every open" step is deliberately NOT limited to
/// the periodic keep-alive timer.** The connection dropping on its own
/// (`onError`/`onDone`) is usually not a random blip — it's the backend
/// closing the stream because the access token used at handshake time
/// just expired (SSE has no per-message reauth, so an expired token
/// only surfaces once the connection actually drops). Reconnecting with
/// whatever's still in storage at that moment reuses the SAME dead
/// token that just caused the drop, fails again, and loops on backoff
/// until the next scheduled keep-alive happens to catch up — visible as
/// repeated "access denied" in the console right around a token
/// refresh. Routing the error/done-triggered reconnect through the same
/// guarded probe as the keep-alive timer closes that gap: every attempt
/// to open a connection, for any reason, checks freshness first.
///
/// Copied from [MessageStreamController].
@ProviderFor(MessageStreamController)
final messageStreamControllerProvider =
    NotifierProvider<MessageStreamController, void>.internal(
  MessageStreamController.new,
  name: r'messageStreamControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$messageStreamControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MessageStreamController = Notifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
