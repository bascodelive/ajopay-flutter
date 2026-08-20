import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import 'contributions_pager.dart';
import '../data/contribution_repository.dart';
import '../data/models/contribution_models.dart';

part 'contribution_action_controller.g.dart';

/// Every Contribution mutation — schedule/report/miss/confirm/reject/reopen.
///
/// `keepAlive: true` from the start — Bug 5 (BUILD_PHASES.md) happened
/// specifically because a mutation controller wasn't kept alive, so its
/// `_lastError` field could vanish between the write and a later separate
/// read. Applying that lesson here immediately rather than discovering
/// the same bug a second time in a new domain.
@Riverpod(keepAlive: true)
class ContributionActionController extends _$ContributionActionController {
  String? _lastError;
  String? get lastError => _lastError;

  @override
  void build() {}

  /// After ANY successful mutation, both the 'all' and 'own' pagers for
  /// this ledger need fresh data (a status change affects what both
  /// views show) — invalidating the whole family (no key) clears every
  /// (ledgerId, scope) combination fetched so far, which is simple and
  /// safe even though it's slightly broader than the one ledger that
  /// actually changed. The contribution's own history also needs a
  /// fresh fetch, since every mutation adds a new log entry.
  void _invalidateAfterMutation(String ledgerId, String contributionId) {
    ref.invalidate(contributionsPagerProvider);
    ref.invalidate(contributionHistoryProvider(
      (ledgerId: ledgerId, contributionId: contributionId),
    ));
  }

  Future<ContributionResponse?> schedule(
    String ledgerId,
    String memberUserId,
    String cycleDate,
  ) async {
    final repository = ref.read(contributionRepositoryProvider);
    try {
      final result = await repository.scheduleContribution(
          ledgerId, memberUserId, cycleDate);
      ref.invalidate(contributionsPagerProvider);
      return result;
    } on ApiException catch (e) {
      _lastError = e.message;
      return null;
    }
  }

  /// Batch counterpart to `schedule` above — one or more members, one
  /// cycleDate, one call. Never throws for a partial outcome (a member
  /// already scheduled, or no longer active) — that's reported inside
  /// the returned response's `skipped` list instead; only a genuine
  /// request failure (non-Admin, empty member list, network error)
  /// surfaces via `null` + `lastError`, same as every other method here.
  Future<BatchScheduleContributionResponse?> scheduleBatch(
    String ledgerId,
    List<String> memberUserIds,
    String cycleDate,
  ) async {
    final repository = ref.read(contributionRepositoryProvider);
    try {
      final result =
          await repository.scheduleBatch(ledgerId, memberUserIds, cycleDate);
      ref.invalidate(contributionsPagerProvider);
      return result;
    } on ApiException catch (e) {
      _lastError = e.message;
      return null;
    }
  }

  Future<ContributionResponse?> reportPayment(
    String ledgerId,
    String contributionId, {
    String? note,
  }) async {
    final repository = ref.read(contributionRepositoryProvider);
    try {
      final result =
          await repository.reportPayment(ledgerId, contributionId, note: note);
      _invalidateAfterMutation(ledgerId, contributionId);
      return result;
    } on ApiException catch (e) {
      _lastError = e.message;
      return null;
    }
  }

  Future<ContributionResponse?> markMissed(
    String ledgerId,
    String contributionId, {
    String? note,
  }) async {
    final repository = ref.read(contributionRepositoryProvider);
    try {
      final result =
          await repository.markMissed(ledgerId, contributionId, note: note);
      _invalidateAfterMutation(ledgerId, contributionId);
      return result;
    } on ApiException catch (e) {
      _lastError = e.message;
      return null;
    }
  }

  Future<ContributionResponse?> confirmPayment(
    String ledgerId,
    String contributionId, {
    String? note,
  }) async {
    final repository = ref.read(contributionRepositoryProvider);
    try {
      final result =
          await repository.confirmPayment(ledgerId, contributionId, note: note);
      _invalidateAfterMutation(ledgerId, contributionId);
      return result;
    } on ApiException catch (e) {
      _lastError = e.message;
      return null;
    }
  }

  Future<ContributionResponse?> rejectReport(
    String ledgerId,
    String contributionId, {
    String? note,
  }) async {
    final repository = ref.read(contributionRepositoryProvider);
    try {
      final result =
          await repository.rejectReport(ledgerId, contributionId, note: note);
      _invalidateAfterMutation(ledgerId, contributionId);
      return result;
    } on ApiException catch (e) {
      _lastError = e.message;
      return null;
    }
  }

  Future<ContributionResponse?> reopenForLatePayment(
    String ledgerId,
    String contributionId, {
    String? note,
  }) async {
    final repository = ref.read(contributionRepositoryProvider);
    try {
      final result = await repository
          .reopenForLatePayment(ledgerId, contributionId, note: note);
      _invalidateAfterMutation(ledgerId, contributionId);
      return result;
    } on ApiException catch (e) {
      _lastError = e.message;
      return null;
    }
  }
}