import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../contributions/data/models/contribution_models.dart';
import 'models/circle_models.dart';

/// Wraps exactly the endpoints API.md's Circles section documents.
class CircleRepository {
  CircleRepository(this._dio);

  final Dio _dio;

  /// Resolved gap (was previously undocumented): the entry point for
  /// discovering a ledger's circle without already knowing its ID —
  /// everything else below still requires one already in hand.
  Future<CircleResponse> getCurrentCircle(String ledgerId) async {
    try {
      final response = await _dio.get('/api/ledgers/$ledgerId/circles/current');
      return CircleResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Every circle this ledger has ever had — PENDING, ACTIVE, and
  /// COMPLETED — newest-started first. `getCurrentCircle` above only
  /// ever returns a PENDING/ACTIVE circle (404 otherwise); this is how
  /// a completed circle stays reachable afterward. Not paginated — see
  /// the backend's own reasoning in CircleService.listCircles's Javadoc.
  Future<List<CircleResponse>> listCircles(String ledgerId) async {
    try {
      final response = await _dio.get('/api/ledgers/$ledgerId/circles');
      return (response.data as List)
          .map((e) => CircleResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<CircleResponse> createCircle(String ledgerId, String startDate) async {
    try {
      final response = await _dio.post(
        '/api/ledgers/$ledgerId/circles',
        data: CreateCircleRequest(startDate: startDate).toJson(),
      );
      return CircleResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<CircleParticipantResponse> addParticipant(
    String ledgerId,
    String circleId,
    String userId,
    int handCount,
  ) async {
    try {
      final response = await _dio.post(
        '/api/ledgers/$ledgerId/circles/$circleId/participants',
        data: AddParticipantRequest(userId: userId, handCount: handCount)
            .toJson(),
      );
      return CircleParticipantResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> removeParticipant(
    String ledgerId,
    String circleId,
    String userId,
  ) async {
    try {
      await _dio.post(
        '/api/ledgers/$ledgerId/circles/$circleId/participants/$userId/remove',
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<CircleParticipantResponse>> getParticipants(
    String ledgerId,
    String circleId,
  ) async {
    try {
      final response = await _dio
          .get('/api/ledgers/$ledgerId/circles/$circleId/participants');
      return (response.data as List)
          .map((e) =>
              CircleParticipantResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<RotationSlotResponse>> assignRotation(
    String ledgerId,
    String circleId,
    List<String> orderedUserIds,
  ) async {
    try {
      final response = await _dio.post(
        '/api/ledgers/$ledgerId/circles/$circleId/rotation',
        data: AssignRotationRequest(orderedUserIds: orderedUserIds).toJson(),
      );
      return (response.data as List)
          .map((e) => RotationSlotResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<RotationSlotResponse>> getRotation(
    String ledgerId,
    String circleId,
  ) async {
    try {
      final response =
          await _dio.get('/api/ledgers/$ledgerId/circles/$circleId/rotation');
      return (response.data as List)
          .map((e) => RotationSlotResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Errors: 404 means no pending slot remains (circle may already be
  /// complete) — a real, expected outcome, not just a generic failure.
  Future<CurrentPayoutResponse> getCurrentPayout(
    String ledgerId,
    String circleId,
  ) async {
    try {
      final response = await _dio
          .get('/api/ledgers/$ledgerId/circles/$circleId/rotation/current');
      return CurrentPayoutResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<CircleResponse> startCircle(String ledgerId, String circleId) async {
    try {
      final response =
          await _dio.post('/api/ledgers/$ledgerId/circles/$circleId/start');
      return CircleResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// ADMIN-only, ACTIVE circles only. Generates this cycle's Contribution
  /// rows — one per hand, for every participant — for whichever cycle
  /// the next pending rotation slot is scheduled for. This is the piece
  /// that actually connects the Circle/rotation feature to the existing
  /// Contribution report/confirm flow: without calling this, no member
  /// has anything to pay against, and the current payout's
  /// `confirmedSoFar` stays 0 forever.
  ///
  /// Manual, admin-triggered — there is no automatic scheduler. Calling
  /// it again for a cycle that's already been generated returns 400
  /// (surfaced as ApiException; callers should treat that as "already
  /// generated for this cycle" rather than a generic failure).
  Future<List<ContributionResponse>> generateCycleContributions(
    String ledgerId,
    String circleId,
  ) async {
    try {
      final response = await _dio.post(
        '/api/ledgers/$ledgerId/circles/$circleId/generate-cycle-contributions',
      );
      return (response.data as List)
          .map((e) => ContributionResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<RotationSlotResponse> confirmPayout(
    String ledgerId,
    String circleId,
    String slotId, {
    String? note,
  }) async {
    try {
      final response = await _dio.post(
        '/api/ledgers/$ledgerId/circles/$circleId/slots/$slotId/confirm-payout',
        data: ConfirmPayoutRequest(note: note).toJson(),
      );
      return RotationSlotResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// The slot's own recipient only — self-confirms they actually
  /// received a payout an Admin already confirmed. Does not affect
  /// rotation progression; the queue already advanced when the Admin
  /// confirmed. Valid only once, only once `status == 'PAID'`.
  Future<RotationSlotResponse> confirmReceived(
    String ledgerId,
    String circleId,
    String slotId,
  ) async {
    try {
      final response = await _dio.post(
        '/api/ledgers/$ledgerId/circles/$circleId/slots/$slotId/confirm-received',
      );
      return RotationSlotResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<CircleActivityLogEntry>> getHistory(
    String ledgerId,
    String circleId,
  ) async {
    try {
      final response =
          await _dio.get('/api/ledgers/$ledgerId/circles/$circleId/history');
      return (response.data as List)
          .map(
              (e) => CircleActivityLogEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Same visibility as getHistory — any active member — but only once
  /// the circle is COMPLETED (API.md: 400 otherwise). Returns the raw
  /// CSV text; `responseType: plain` is required here since this
  /// endpoint's Content-Type is text/csv, not application/json — Dio's
  /// default JSON transformer would otherwise choke trying to decode it.
  Future<String> exportHistoryCsv(String ledgerId, String circleId) async {
    try {
      final response = await _dio.get<String>(
        '/api/ledgers/$ledgerId/circles/$circleId/history/export',
        options: Options(responseType: ResponseType.plain),
      );
      return response.data ?? '';
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// PREMIUM feature. Offers the caller's own PENDING slot for transfer
  /// — open (`targetUserId` null) or targeted at one specific
  /// participant. See PREMIUM-FEATURE-payout-slot-transfer.md.
  Future<PayoutSlotTransferResponse> offerSlotTransfer(
    String ledgerId,
    String circleId,
    String slotId, {
    String? targetUserId,
  }) async {
    try {
      final response = await _dio.post(
        '/api/ledgers/$ledgerId/circles/$circleId/rotation/$slotId/transfer-offers',
        data: OfferSlotTransferRequest(userId: targetUserId).toJson(),
      );
      return PayoutSlotTransferResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Any active participant — full transparency, open and resolved
  /// offers alike.
  Future<List<PayoutSlotTransferResponse>> listSlotTransfers(
    String ledgerId,
    String circleId,
  ) async {
    try {
      final response = await _dio
          .get('/api/ledgers/$ledgerId/circles/$circleId/transfer-offers');
      return (response.data as List)
          .map((e) =>
              PayoutSlotTransferResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// PREMIUM feature. Accepts an open offer, swapping which user holds
  /// the offering slot and the caller's own `acceptingSlotId`.
  Future<PayoutSlotTransferResponse> acceptSlotTransfer(
    String ledgerId,
    String circleId,
    String transferId,
    String acceptingSlotId,
  ) async {
    try {
      final response = await _dio.post(
        '/api/ledgers/$ledgerId/circles/$circleId/transfer-offers/$transferId/accept',
        data: AcceptSlotTransferRequest(acceptingSlotId: acceptingSlotId)
            .toJson(),
      );
      return PayoutSlotTransferResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// NOT Premium-gated — same reasoning as the backend: saying no
  /// shouldn't require the paid tier that saying yes does.
  Future<PayoutSlotTransferResponse> declineSlotTransfer(
    String ledgerId,
    String circleId,
    String transferId,
  ) async {
    try {
      final response = await _dio.post(
        '/api/ledgers/$ledgerId/circles/$circleId/transfer-offers/$transferId/decline',
      );
      return PayoutSlotTransferResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// The offerer withdraws their own still-open offer. Not Premium-gated.
  Future<PayoutSlotTransferResponse> cancelSlotTransfer(
    String ledgerId,
    String circleId,
    String transferId,
  ) async {
    try {
      final response = await _dio.post(
        '/api/ledgers/$ledgerId/circles/$circleId/transfer-offers/$transferId/cancel',
      );
      return PayoutSlotTransferResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

final circleRepositoryProvider = Provider<CircleRepository>((ref) {
  return CircleRepository(ref.watch(dioProvider));
});
