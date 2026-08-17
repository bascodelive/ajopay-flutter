import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/session/require_authenticated.dart';
import '../../contributions/application/contributions_pager.dart';
import '../../contributions/data/models/contribution_models.dart';
import '../data/circle_repository.dart';
import '../data/models/circle_models.dart';

part 'circle_controller.g.dart';

/// Every Circle read endpoint needs BOTH a ledgerId and a circleId (Circles
/// are nested resources — API.md's paths are all
/// /api/ledgers/{ledgerId}/circles/{circleId}/...). Dart records have
/// correct structural equality out of the box, which makes them a clean
/// composite key for a Riverpod family — no need for a hand-written class
/// with its own ==/hashCode just for this.
typedef CircleKey = ({String ledgerId, String circleId});

/// Holds the circle currently being set up/managed by an Admin — the
/// multi-step PENDING flow (create → add participants → assign rotation
/// → start) plus payout confirmation once ACTIVE. Mirrors LedgerController's
/// shape: one mutable "current" circle, separate read-only FutureProviders
/// below for lists that don't need mutation tracking.
@Riverpod(keepAlive: true) // bug fix — see BUILD_PHASES.md Bug 5
class CircleController extends _$CircleController {
  String? _lastError;
  String? get lastError => _lastError;

  @override
  CircleResponse? build() => null;

  Future<CircleResponse?> create(
    String ledgerId,
    String startDate, {
    double? contributionAmount,
  }) async {
    final repository = ref.read(circleRepositoryProvider);
    try {
      final circle = await repository.createCircle(
        ledgerId,
        startDate,
        contributionAmount: contributionAmount,
      );
      state = circle;
      return circle;
    } on ApiException catch (e) {
      _lastError = e.message;
      return null;
    }
  }

  /// ADMIN action, PENDING-only. Revises the circle's OWN agreed amount
  /// — see CircleResponse.contributionAmount's doc. Invalidates history
  /// (an AMOUNT_UPDATED entry is logged) alongside updating `state` so
  /// the PENDING setup screen reflects the new figure immediately.
  Future<bool> updateAmount(
    String ledgerId,
    String circleId,
    double contributionAmount,
  ) async {
    final repository = ref.read(circleRepositoryProvider);
    try {
      final circle = await repository.updateCircleAmount(
        ledgerId,
        circleId,
        contributionAmount,
      );
      state = circle;
      ref.invalidate(
          circleHistoryProvider((ledgerId: ledgerId, circleId: circleId)));
      return true;
    } on ApiException catch (e) {
      _lastError = e.message;
      return false;
    }
  }

  Future<bool> addParticipant(
    String ledgerId,
    String circleId,
    String userId,
    int handCount,
  ) async {
    final repository = ref.read(circleRepositoryProvider);
    try {
      await repository.addParticipant(ledgerId, circleId, userId, handCount);
      ref.invalidate(
          circleParticipantsProvider((ledgerId: ledgerId, circleId: circleId)));
      return true;
    } on ApiException catch (e) {
      _lastError = e.message;
      return false;
    }
  }

  Future<bool> removeParticipant(
    String ledgerId,
    String circleId,
    String userId,
  ) async {
    final repository = ref.read(circleRepositoryProvider);
    try {
      await repository.removeParticipant(ledgerId, circleId, userId);
      ref.invalidate(
          circleParticipantsProvider((ledgerId: ledgerId, circleId: circleId)));
      return true;
    } on ApiException catch (e) {
      _lastError = e.message;
      return false;
    }
  }

  Future<bool> assignRotation(
    String ledgerId,
    String circleId,
    List<String> orderedUserIds,
  ) async {
    final repository = ref.read(circleRepositoryProvider);
    try {
      await repository.assignRotation(ledgerId, circleId, orderedUserIds);
      ref.invalidate(
          circleRotationProvider((ledgerId: ledgerId, circleId: circleId)));
      return true;
    } on ApiException catch (e) {
      _lastError = e.message;
      return false;
    }
  }

  Future<bool> start(String ledgerId, String circleId) async {
    final repository = ref.read(circleRepositoryProvider);
    try {
      final circle = await repository.startCircle(ledgerId, circleId);
      state = circle;
      ref.invalidate(
          circleRotationProvider((ledgerId: ledgerId, circleId: circleId)));
      return true;
    } on ApiException catch (e) {
      _lastError = e.message;
      return false;
    }
  }

  /// ADMIN action, ACTIVE circles only — generates this cycle's
  /// Contribution rows (one per hand, every participant) for whichever
  /// cycle the next pending rotation slot is scheduled for. Returns the
  /// created rows on success so the caller can show them immediately
  /// without a second round-trip; returns null on failure (check
  /// `lastError` — a 400 here most often means this cycle's
  /// contributions were already generated).
  ///
  /// Invalidates BOTH the current-payout view (its confirmedSoFar can
  /// only ever move once real Contribution rows exist to sum) and the
  /// ledger-wide contributions pager (the new rows should show up in
  /// the Contributions tab immediately, not after a manual pull-to-refresh).
  Future<List<ContributionResponse>?> generateCycleContributions(
    String ledgerId,
    String circleId,
  ) async {
    final repository = ref.read(circleRepositoryProvider);
    try {
      final created =
          await repository.generateCycleContributions(ledgerId, circleId);
      final key = (ledgerId: ledgerId, circleId: circleId);
      ref.invalidate(currentPayoutProvider(key));
      ref.invalidate(contributionsPagerProvider);
      return created;
    } on ApiException catch (e) {
      _lastError = e.message;
      return null;
    }
  }

  Future<bool> confirmPayout(
    String ledgerId,
    String circleId,
    String slotId, {
    String? note,
  }) async {
    final repository = ref.read(circleRepositoryProvider);
    try {
      await repository.confirmPayout(ledgerId, circleId, slotId, note: note);
      final key = (ledgerId: ledgerId, circleId: circleId);
      ref.invalidate(circleRotationProvider(key));
      ref.invalidate(currentPayoutProvider(key));
      return true;
    } on ApiException catch (e) {
      _lastError = e.message;
      return false;
    }
  }

  /// The slot's OWN recipient only — self-confirms they actually
  /// received a payout an Admin already confirmed. Purely a
  /// transparency layer; only invalidates the rotation list (so the
  /// "receipt confirmed" indicator refreshes) — doesn't touch
  /// currentPayoutProvider since this never affects which slot is next
  /// due.
  Future<bool> confirmReceived(
    String ledgerId,
    String circleId,
    String slotId,
  ) async {
    final repository = ref.read(circleRepositoryProvider);
    try {
      await repository.confirmReceived(ledgerId, circleId, slotId);
      ref.invalidate(
          circleRotationProvider((ledgerId: ledgerId, circleId: circleId)));
      return true;
    } on ApiException catch (e) {
      _lastError = e.message;
      return false;
    }
  }

  /// PREMIUM feature. Offers the caller's own PENDING slot for transfer
  /// — open (`targetUserId` null) or targeted at one specific
  /// participant. Returns the created transfer on success so a caller
  /// can act on it immediately (e.g. show its id); null on failure,
  /// check `lastError`. Invalidates the transfer-offers list for this
  /// circle so both this screen and the rotation queue's "already has
  /// an open offer" check refresh immediately.
  Future<PayoutSlotTransferResponse?> offerSlotTransfer(
    String ledgerId,
    String circleId,
    String slotId, {
    String? targetUserId,
  }) async {
    final repository = ref.read(circleRepositoryProvider);
    try {
      final transfer = await repository.offerSlotTransfer(
        ledgerId,
        circleId,
        slotId,
        targetUserId: targetUserId,
      );
      ref.invalidate(circleSlotTransfersProvider(
          (ledgerId: ledgerId, circleId: circleId)));
      return transfer;
    } on ApiException catch (e) {
      _lastError = e.message;
      return null;
    }
  }

  /// PREMIUM feature. Accepts an open offer — swaps which user holds the
  /// offering slot and the caller's own `acceptingSlotId`. Invalidates
  /// both the transfer list AND the rotation queue itself, since
  /// ownership of two slots just changed — unlike confirmReceived above,
  /// this genuinely does affect what the rotation queue shows.
  Future<bool> acceptSlotTransfer(
    String ledgerId,
    String circleId,
    String transferId,
    String acceptingSlotId,
  ) async {
    final repository = ref.read(circleRepositoryProvider);
    try {
      await repository.acceptSlotTransfer(
          ledgerId, circleId, transferId, acceptingSlotId);
      final key = (ledgerId: ledgerId, circleId: circleId);
      ref.invalidate(circleSlotTransfersProvider(key));
      ref.invalidate(circleRotationProvider(key));
      return true;
    } on ApiException catch (e) {
      _lastError = e.message;
      return false;
    }
  }

  /// NOT Premium-gated — see CircleRepository.declineSlotTransfer's doc:
  /// saying no shouldn't require the paid tier that saying yes does.
  Future<bool> declineSlotTransfer(
    String ledgerId,
    String circleId,
    String transferId,
  ) async {
    final repository = ref.read(circleRepositoryProvider);
    try {
      await repository.declineSlotTransfer(ledgerId, circleId, transferId);
      ref.invalidate(circleSlotTransfersProvider(
          (ledgerId: ledgerId, circleId: circleId)));
      return true;
    } on ApiException catch (e) {
      _lastError = e.message;
      return false;
    }
  }

  /// The offerer withdraws their own open offer. Not Premium-gated.
  Future<bool> cancelSlotTransfer(
    String ledgerId,
    String circleId,
    String transferId,
  ) async {
    final repository = ref.read(circleRepositoryProvider);
    try {
      await repository.cancelSlotTransfer(ledgerId, circleId, transferId);
      ref.invalidate(circleSlotTransfersProvider(
          (ledgerId: ledgerId, circleId: circleId)));
      return true;
    } on ApiException catch (e) {
      _lastError = e.message;
      return false;
    }
  }
}

/// The entry point for discovering a ledger's circle without already
/// knowing its ID — resolves the gap flagged in BUILD_PHASES.md. Keyed by
/// ledgerId alone (not the CircleKey record below, since there's no
/// circleId yet — that's the whole point of this provider).
///
/// A 404 here is a normal, expected outcome (no PENDING/ACTIVE circle for
/// this ledger right now) — screens should treat it as "no circle yet,"
/// not as an error state.
final currentCircleProvider =
    FutureProvider.autoDispose.family<CircleResponse, String>((ref, ledgerId) {
  return requireAuthenticated(
    ref,
    () => ref.read(circleRepositoryProvider).getCurrentCircle(ledgerId),
  );
});

/// Every circle this ledger has ever had, newest-started first — see
/// CircleRepository.listCircles's Javadoc-equivalent comment for why
/// this exists alongside currentCircleProvider rather than instead of
/// it: that one 404s the moment a circle COMPLETES, so it can never be
/// the source for "let me look at a circle that already finished."
final circlesListProvider = FutureProvider.autoDispose
    .family<List<CircleResponse>, String>((ref, ledgerId) {
  return requireAuthenticated(
    ref,
    () => ref.read(circleRepositoryProvider).listCircles(ledgerId),
  );
});

/// Read-only, keyed by (ledgerId, circleId) — same `.autoDispose` +
/// `requireAuthenticated` guard pattern as the Ledger data providers
/// (BUILD_PHASES.md Bug 1 & 2).
final circleParticipantsProvider = FutureProvider.autoDispose
    .family<List<CircleParticipantResponse>, CircleKey>((ref, key) {
  return requireAuthenticated(
    ref,
    () => ref
        .read(circleRepositoryProvider)
        .getParticipants(key.ledgerId, key.circleId),
  );
});

final circleRotationProvider = FutureProvider.autoDispose
    .family<List<RotationSlotResponse>, CircleKey>((ref, key) {
  return requireAuthenticated(
    ref,
    () => ref
        .read(circleRepositoryProvider)
        .getRotation(key.ledgerId, key.circleId),
  );
});

/// Errors: a 404 means no pending slot remains (circle may already be
/// complete) — a real, expected outcome the screen should handle
/// gracefully, not just a generic failure.
final currentPayoutProvider = FutureProvider.autoDispose
    .family<CurrentPayoutResponse, CircleKey>((ref, key) {
  return requireAuthenticated(
    ref,
    () => ref
        .read(circleRepositoryProvider)
        .getCurrentPayout(key.ledgerId, key.circleId),
  );
});

final circleHistoryProvider = FutureProvider.autoDispose
    .family<List<CircleActivityLogEntry>, CircleKey>((ref, key) {
  return requireAuthenticated(
    ref,
    () => ref
        .read(circleRepositoryProvider)
        .getHistory(key.ledgerId, key.circleId),
  );
});

/// PREMIUM feature. Any active participant — full transparency, open
/// and resolved offers alike (see CircleRepository.listSlotTransfers's
/// doc). Same `.autoDispose` + `requireAuthenticated` pattern as every
/// other read provider here.
final circleSlotTransfersProvider = FutureProvider.autoDispose
    .family<List<PayoutSlotTransferResponse>, CircleKey>((ref, key) {
  return requireAuthenticated(
    ref,
    () => ref
        .read(circleRepositoryProvider)
        .listSlotTransfers(key.ledgerId, key.circleId),
  );
});
