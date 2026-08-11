import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'message_read_tracker.g.dart';

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
@Riverpod(keepAlive: true)
class MessageReadTracker extends _$MessageReadTracker {
  SharedPreferences? _prefs;

  @override
  Future<void> build() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String _key(String threadKey) => 'message_last_read:$threadKey';

  /// Null means "never opened on this device" — callers should treat
  /// that as "everything currently in the thread is unread", not as
  /// an error.
  DateTime? getLastRead(String threadKey) {
    final raw = _prefs?.getString(_key(threadKey));
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  Future<void> setLastRead(String threadKey, DateTime timestamp) async {
    await _prefs?.setString(_key(threadKey), timestamp.toIso8601String());
  }

  /// Convenience — marks a thread read as of right now. What screens
  /// actually call when a thread is opened/viewed.
  Future<void> markReadNow(String threadKey) {
    return setLastRead(threadKey, DateTime.now());
  }
}

/// Stable string key for a thread — group or private — matching how
/// `MessageThreadKey` already distinguishes the two, just flattened to
/// a string since SharedPreferences needs a plain key, not a record.
String messageThreadStorageKey({
  required String ledgerId,
  required bool isGroup,
  String? otherUserId,
}) {
  return isGroup ? 'group:$ledgerId' : 'private:$ledgerId:$otherUserId';
}
