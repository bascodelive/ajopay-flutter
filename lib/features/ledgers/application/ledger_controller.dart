import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
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
@riverpod
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
/// to. A plain FutureProvider, not a Notifier: pure fetch, no mutation.
/// Screens should `ref.invalidate(myLedgersProvider)` after a successful
/// create/join so the list picks up the new membership immediately.
final myLedgersProvider = FutureProvider<List<LedgerResponse>>((ref) {
  return ref.watch(ledgerRepositoryProvider).getMyLedgers();
});

/// The Ledger Detail screen's data source — pure fetch by ID, deliberately
/// separate from LedgerController above so viewing a ledger never
/// interferes with an in-progress create/join/update mutation elsewhere.
final ledgerDetailProvider =
    FutureProvider.family<LedgerResponse, String>((ref, ledgerId) {
  return ref.watch(ledgerRepositoryProvider).getLedger(ledgerId);
});

/// Read-only, keyed by ledgerId — a simple FutureProvider.family fits this
/// better than a full Notifier since it's pure fetch, no mutation
/// (proportional complexity, same instinct as the rest of this codebase).
final ledgerMembersProvider =
    FutureProvider.family<List<LedgerMemberResponse>, String>((ref, ledgerId) {
  return ref.watch(ledgerRepositoryProvider).getMembers(ledgerId);
});

final myMembershipProvider =
    FutureProvider.family<LedgerMemberResponse, String>((ref, ledgerId) {
  return ref.watch(ledgerRepositoryProvider).getMyMembership(ledgerId);
});
