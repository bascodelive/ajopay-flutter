// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_read_tracker.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$messageReadTrackerHash() =>
    r'027f0f68dbd8d058670a76c339297d163dd9c7fb';

/// Tracks, per device, when the caller last actually looked at a
/// message thread — purely local (SharedPreferences), not synced to
/// the backend. There's no server-side read-state endpoint for
/// messages, so this is the WhatsApp-style unread-badge feature's own
/// storage, not a general-purpose sync mechanism.
///
/// Deliberately NOT `flutter_secure_storage` (already used elsewhere in
/// this app for tokens) — that's encryption overhead for something
/// that isn't sensitive and changes on every thread open;
/// SharedPreferences is the right tool for small, frequent, non-secret
/// local state.
///
/// Async `build()` self-initializes the SharedPreferences instance on
/// first watch — no `main.dart`/`ProviderScope(overrides: [...])`
/// wiring needed, unlike the usual Riverpod+SharedPreferences pattern
/// which requires resolving the instance before `runApp`. Trade-off:
/// a call to `getLastRead`/`setLastRead` made before `build()` resolves
/// silently no-ops (returns null / does nothing) rather than throwing —
/// acceptable since the only consequence is "briefly treated as
/// unread," which self-corrects the moment the notifier finishes
/// initializing and the watching UI rebuilds.
///
/// Known, accepted limitation: this is per-device. A fresh install or
/// a second device starts with no read history — everything looks
/// unread until opened once there. Real cross-device sync would need a
/// backend read-state endpoint, deliberately not built for a need that
/// doesn't exist yet.
///
/// Copied from [MessageReadTracker].
@ProviderFor(MessageReadTracker)
final messageReadTrackerProvider =
    AsyncNotifierProvider<MessageReadTracker, void>.internal(
  MessageReadTracker.new,
  name: r'messageReadTrackerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$messageReadTrackerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MessageReadTracker = AsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
