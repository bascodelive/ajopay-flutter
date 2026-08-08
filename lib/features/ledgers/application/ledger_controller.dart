import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/session/require_authenticated.dart';
import '../data/ledger_repository.dart';
import '../data/models/ledger_models.dart';
import 'ledger_reviews_pager.dart';

part 'ledger_controller.g.dart';

/// Holds the ledger currently being created/joined/viewed/edited, plus
/// every ledger-membership mutation (create/join/update/approve/reject/
/// rate).
///
/// This is NOT "the user's list of ledgers" — that's `myLedgersProvider`
/// below, a separate simple FutureProvider, since listing is pure fetch
/// with no mutation. This notifier tracks one ledger at a time, identified
/// by whatever `ledgerId` the caller already has (from create/join, from
/// picking one in the list, or from navigation state).
@Riverpod(keepAlive: true) // bug fix — see BUILD_PHASES.md Bug 5
class LedgerController extends _$LedgerController {
  String? _lastError;
  String? get lastError => _lastError;

  @override
  LedgerResponse? build() => null;

  /// Returns the ledger regardless of membershipStatus — callers MUST
  /// check `result.membershipStatus` themselves before assuming the
  /// caller has active access (join is no longer instant; see
  /// JoinLedgerScreen for the screen that actually branches on this).
  Future<LedgerResponse?> create({
    required String name,
    required String contributionFrequency,
    required double contributionAmount,
  }) async {
    final repository = ref.read(ledgerRepositoryProvider);
    try {
      final ledger = await repository.createLedger(
        CreateLedgerRequest(
          name: name,
          contributionFrequency: contributionFrequency,
          contributionAmount: contributionAmount,
        ),
      );
      state = ledger;
      return ledger;
    } on ApiException catch (e) {
      _lastError = e.message;
      return null;
    }
  }

  /// A successful call here almost always means membershipStatus is now
  /// PENDING, not ACTIVE — the caller must branch on that field, not on
  /// whether this returned non-null. See JoinLedgerScreen.
  Future<LedgerResponse?> join(String inviteCode) async {
    final repository = ref.read(ledgerRepositoryProvider);
    try {
      final ledger = await repository.joinLedger(inviteCode);
      state = ledger;
      return ledger;
    } on ApiException catch (e) {
      _lastError = e.message;
      return null;
    }
  }

  Future<void> load(String ledgerId) async {
    final repository = ref.read(ledgerRepositoryProvider);
    try {
      state = await repository.getLedger(ledgerId);
    } on ApiException catch (e) {
      _lastError = e.message;
    }
  }

  Future<bool> update({
    required String ledgerId,
    required String name,
    required String contributionFrequency,
    required double contributionAmount,
  }) async {
    final repository = ref.read(ledgerRepositoryProvider);
    try {
      final updated = await repository.updateLedger(
        ledgerId,
        UpdateLedgerRequest(
          name: name,
          contributionFrequency: contributionFrequency,
          contributionAmount: contributionAmount,
        ),
      );
      state = updated;
      return true;
    } on ApiException catch (e) {
      _lastError = e.message;
      return false;
    }
  }

  /// ADMIN action — approves a PENDING join request. Refreshes both the
  /// pending list (this row disappears from it) and the active member
  /// list (this row appears in it) so the Members screen's two tabs stay
  /// in sync without a manual pull-to-refresh.
  Future<bool> approveMember(String ledgerId, String userId) async {
    final repository = ref.read(ledgerRepositoryProvider);
    try {
      await repository.approveMember(ledgerId, userId);
      ref.invalidate(ledgerPendingMembersProvider(ledgerId));
      ref.invalidate(ledgerMembersProvider(ledgerId));
      return true;
    } on ApiException catch (e) {
      _lastError = e.message;
      return false;
    }
  }

  /// ADMIN action — declines a PENDING join request (INVALIDATED).
  Future<bool> rejectMember(String ledgerId, String userId) async {
    final repository = ref.read(ledgerRepositoryProvider);
    try {
      await repository.rejectMember(ledgerId, userId);
      ref.invalidate(ledgerPendingMembersProvider(ledgerId));
      return true;
    } on ApiException catch (e) {
      _lastError = e.message;
      return false;
    }
  }

  /// Any registered user with at least one active ledger membership
  /// somewhere — upserts the caller's own 1-5 star rating on ANY
  /// ledger, membership in that specific ledger not required. Rejected
  /// if the caller is that ledger's own Admin. Invalidates the caller's
  /// own-rating cache for this ledger so a re-opened rating sheet shows
  /// the freshly-saved value; does NOT invalidate the directory pager
  /// (the new average only becomes visible on that ledger's next
  /// natural refetch — acceptable staleness for a browsable list, same
  /// tradeoff the Contributions pager already accepts elsewhere).
  Future<bool> rateLedger(
    String ledgerId,
    int stars, {
    String? reviewText,
  }) async {
    final repository = ref.read(ledgerRepositoryProvider);
    try {
      await repository.rateLedger(ledgerId, stars, reviewText: reviewText);
      ref.invalidate(myLedgerRatingProvider(ledgerId));
      // Only meaningfully changes what the reviews list shows when
      // reviewText is non-empty, but invalidating unconditionally is
      // cheap and correct either way (a re-rate that REMOVES review
      // text should also make that review disappear from the list).
      ref.invalidate(ledgerReviewsPagerProvider(ledgerId));
      return true;
    } on ApiException catch (e) {
      _lastError = e.message;
      return false;
    }
  }
}

/// The home/list screen's data source — every ledger the caller belongs
/// to. `.autoDispose` — bug fix: a plain FutureProvider with no modifier
/// caches its result for the entire app process by default, not just
/// while something's watching it. That meant a previous user's ledger
/// list stayed in memory across a logout, and the next user to log in on
/// the same app session could see it until the app was fully restarted.
/// See core/session/session_reset.dart for the explicit
/// invalidate-on-logout half of this fix, and requireAuthenticated for
/// the guard that stops a mid-teardown rebuild from firing a real
/// network call with no valid token (BUILD_PHASES.md Bug 2).
/// Screens should `ref.invalidate(myLedgersProvider)` after a successful
/// create/join so the list picks up the new membership immediately —
/// note a PENDING join won't actually appear here until approved (see
/// LedgerRepository.getMyLedgers's Javadoc-equivalent comment).
final myLedgersProvider =
    FutureProvider.autoDispose<List<LedgerResponse>>((ref) {
  return requireAuthenticated(
      ref, () => ref.read(ledgerRepositoryProvider).getMyLedgers());
});

/// The caller's own current standing against their tier's active-ledger
/// limit — drives `LedgerHomeScreen`'s Create/Join gate. Same
/// `.autoDispose` + `requireAuthenticated` reasoning as `myLedgersProvider`
/// above, and the same "screen owns invalidation" pattern: screens should
/// `ref.invalidate(ledgerLimitProvider)` alongside
/// `ref.invalidate(myLedgersProvider)` after a successful create/join —
/// not handled inside `LedgerController` itself, consistent with how
/// `myLedgersProvider` is already invalidated from the screens, not here.
final ledgerLimitProvider =
    FutureProvider.autoDispose<LedgerLimitResponse>((ref) {
  return requireAuthenticated(
      ref, () => ref.read(ledgerRepositoryProvider).getLedgerLimit());
});

/// The Ledger Detail screen's data source — pure fetch by ID, deliberately
/// separate from LedgerController above so viewing a ledger never
/// interferes with an in-progress create/join/update mutation elsewhere.
/// `.autoDispose` + `requireAuthenticated` for the same reasons as
/// myLedgersProvider above.
///
/// Server-side this is ACTIVE-membership-gated — a still-PENDING caller
/// gets a 403 here, by design. Nothing in this app should route a
/// still-PENDING user into this screen; see JoinLedgerScreen.
final ledgerDetailProvider =
    FutureProvider.autoDispose.family<LedgerResponse, String>((ref, ledgerId) {
  return requireAuthenticated(
      ref, () => ref.read(ledgerRepositoryProvider).getLedger(ledgerId));
});

/// Read-only, keyed by ledgerId — a simple FutureProvider.family fits this
/// better than a full Notifier since it's pure fetch, no mutation
/// (proportional complexity, same instinct as the rest of this codebase).
/// `.autoDispose` + `requireAuthenticated` — this one specifically caches
/// `role`, exactly the kind of per-user data that must never survive a
/// logout or fire while unauthenticated.
///
/// Any active member of the ledger can view the full ACTIVE member list.
/// PENDING/INVALIDATED/REMOVED rows never appear here — see
/// ledgerPendingMembersProvider below for the Admin-only "who's waiting"
/// view.
final ledgerMembersProvider = FutureProvider.autoDispose
    .family<List<LedgerMemberResponse>, String>((ref, ledgerId) {
  return requireAuthenticated(
      ref, () => ref.read(ledgerRepositoryProvider).getMembers(ledgerId));
});

/// ADMIN-only server-side (403 for anyone else) — everyone currently
/// waiting to be approved into this ledger. Drives the "Pending" tab on
/// LedgerMembersScreen; that screen only shows the tab at all once it
/// already knows the caller is Admin (from ledgerDetailProvider), so in
/// practice this is never even called for a non-Admin.
final ledgerPendingMembersProvider = FutureProvider.autoDispose
    .family<List<LedgerMemberResponse>, String>((ref, ledgerId) {
  return requireAuthenticated(ref,
      () => ref.read(ledgerRepositoryProvider).getPendingMembers(ledgerId));
});

/// The caller's own membership row — deliberately NOT gated to ACTIVE
/// server-side, so this is the one provider in this file safe to watch
/// even while the caller is still PENDING (e.g. a "check my request
/// status" screen, if one gets built later).
final myMembershipProvider = FutureProvider.autoDispose
    .family<LedgerMemberResponse, String>((ref, ledgerId) {
  return requireAuthenticated(
      ref, () => ref.read(ledgerRepositoryProvider).getMyMembership(ledgerId));
});

/// The caller's own rating on a given ledger, if any — null (not an
/// error) if they haven't rated it yet. Drives whether the rating
/// sheet opens pre-filled ("you rated this 4★") or blank.
final myLedgerRatingProvider = FutureProvider.autoDispose
    .family<LedgerRatingResponse?, String>((ref, ledgerId) {
  return requireAuthenticated(
      ref, () => ref.read(ledgerRepositoryProvider).getMyRating(ledgerId));
});
