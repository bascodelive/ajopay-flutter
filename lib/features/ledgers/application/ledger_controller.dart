import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/session/require_authenticated.dart';
import '../data/ledger_repository.dart';
import '../data/models/ledger_models.dart';

part 'ledger_controller.g.dart';

/// Holds the ledger currently being created/joined/viewed/edited.
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
/// create/join so the list picks up the new membership immediately.
final myLedgersProvider =
    FutureProvider.autoDispose<List<LedgerResponse>>((ref) {
  return requireAuthenticated(
      ref, () => ref.read(ledgerRepositoryProvider).getMyLedgers());
});

/// The Ledger Detail screen's data source — pure fetch by ID, deliberately
/// separate from LedgerController above so viewing a ledger never
/// interferes with an in-progress create/join/update mutation elsewhere.
/// `.autoDispose` + `requireAuthenticated` for the same reasons as
/// myLedgersProvider above.
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
/// API.md update: this endpoint is no longer ADMIN-only — any active
/// member of the ledger can view the full member list now. Nothing to
/// change here client-side beyond this comment; the repository/provider
/// never gated by role in the first place, only the server did.
final ledgerMembersProvider = FutureProvider.autoDispose
    .family<List<LedgerMemberResponse>, String>((ref, ledgerId) {
  return requireAuthenticated(
      ref, () => ref.read(ledgerRepositoryProvider).getMembers(ledgerId));
});

final myMembershipProvider = FutureProvider.autoDispose
    .family<LedgerMemberResponse, String>((ref, ledgerId) {
  return requireAuthenticated(
      ref, () => ref.read(ledgerRepositoryProvider).getMyMembership(ledgerId));
});
