import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/session/require_authenticated.dart';
import '../data/models/subscription_models.dart';
import '../data/subscription_repository.dart';

part 'subscription_controller.g.dart';

/// Current Premium status, watched app-wide wherever a screen needs to
/// gate something on it (Messages' composer today; anything else later
/// — the ledger create/join limit is a known near-term one, not wired
/// yet). `keepAlive: true` since this genuinely is app-wide shared
/// state, not a single screen's concern — same reasoning CircleController
/// documents for its own `keepAlive`.
///
/// Async `build()` (matching ContributionsPager/MessageThreadPager's
/// shape), not CircleController's "null until an action sets it"
/// pattern — status needs a real fetch on first read, there's no
/// equivalent of "nothing to show until the user does something."
@Riverpod(keepAlive: true)
class SubscriptionController extends _$SubscriptionController {
  String? _lastError;
  String? get lastError => _lastError;

  @override
  Future<SubscriptionStatusResponse> build() {
    return requireAuthenticated(
      ref,
      () => ref.read(subscriptionRepositoryProvider).getStatus(),
    );
  }

  /// Starts a Premium upgrade attempt — returns the checkout URL/
  /// reference to open, or null on failure (check `lastError`).
  /// Deliberately does NOT touch `state`: this app's Premium status can
  /// only ever change via the backend webhook confirming real payment
  /// (API.md), never as a direct result of calling this endpoint. Call
  /// `refresh()` (ideally on a poll/on-resume, see SubscriptionScreen)
  /// to find out once it actually has.
  Future<UpgradeResponse?> upgrade() async {
    final repository = ref.read(subscriptionRepositoryProvider);
    try {
      return await repository.upgrade();
    } on ApiException catch (e) {
      _lastError = e.message;
      return null;
    }
  }

  /// Re-fetches current status — pull-to-refresh, and the
  /// polling/on-resume checks after a checkout attempt. Same
  /// AsyncLoading-with-previous-value pattern as the pagers' own
  /// `refresh()`, so a re-check never blanks the screen while it runs.
  Future<void> refresh() async {
    state = const AsyncLoading<SubscriptionStatusResponse>()
        .copyWithPrevious(state);
    state = await AsyncValue.guard(
      () => requireAuthenticated(
        ref,
        () => ref.read(subscriptionRepositoryProvider).getStatus(),
      ),
    );
  }
}
