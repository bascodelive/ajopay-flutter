// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_stream_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$messageStreamControllerHash() =>
    r'5b26e368b9e7e4d7dd098b1a6fcb7a2df50d2957';

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
