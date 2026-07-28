import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../../shared/models/page_response.dart';
import 'models/contribution_models.dart';

/// Wraps exactly the endpoints API.md's Contributions section documents —
/// cross-checked directly against ContributionController/ContributionService
/// source, not just the doc (per the pattern that already caught two real
/// gaps in Ledgers/Circles). All 8 original endpoints matched exactly;
/// `exportHistoryCsv` added alongside the backend's own
/// history/export addition.
class ContributionRepository {
  ContributionRepository(this._dio);

  final Dio _dio;

  /// ADMIN-only server-side. Default sort: cycleDate descending, page
  /// size 20 (API.md) — page/size passed through as query params, sort
  /// deliberately left to the backend's own default rather than
  /// reimplementing it client-side.
  Future<PageResponse<ContributionResponse>> listAllForLedger(
    String ledgerId, {
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/api/ledgers/$ledgerId/contributions',
        queryParameters: {'page': page, 'size': size},
      );
      return PageResponse<ContributionResponse>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => ContributionResponse.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Any active member — their own contributions only, same pagination
  /// defaults as listAllForLedger.
  Future<PageResponse<ContributionResponse>> listOwnForLedger(
    String ledgerId, {
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/api/ledgers/$ledgerId/contributions/me',
        queryParameters: {'page': page, 'size': size},
      );
      return PageResponse<ContributionResponse>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => ContributionResponse.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// ADMIN-only server-side. Opens a PENDING contribution for one
  /// member's cycle — manual, per-cycle, per-member (no auto-scheduler
  /// exists yet, per API.md's own "Not yet implemented" list).
  Future<ContributionResponse> scheduleContribution(
    String ledgerId,
    String memberUserId,
    String cycleDate,
  ) async {
    try {
      final response = await _dio.post(
        '/api/ledgers/$ledgerId/contributions',
        data: ScheduleContributionRequest(
          memberUserId: memberUserId,
          cycleDate: cycleDate,
        ).toJson(),
      );
      return ContributionResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// MEMBER action — only the contribution's own owner, only from
  /// PENDING. Backend rejects (403) if caller isn't the owner.
  Future<ContributionResponse> reportPayment(
    String ledgerId,
    String contributionId, {
    String? note,
  }) async {
    try {
      final response = await _dio.post(
        '/api/ledgers/$ledgerId/contributions/$contributionId/report-payment',
        data: ContributionActionRequest(note: note).toJson(),
      );
      return ContributionResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// ADMIN-only, only from PENDING.
  Future<ContributionResponse> markMissed(
    String ledgerId,
    String contributionId, {
    String? note,
  }) async {
    try {
      final response = await _dio.post(
        '/api/ledgers/$ledgerId/contributions/$contributionId/miss',
        data: ContributionActionRequest(note: note).toJson(),
      );
      return ContributionResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// ADMIN-only, valid from REPORTED (normal) or MISSED (late cash,
  /// confirmed directly — the one shortcut for cash already collected
  /// out-of-band). NOT valid directly from PENDING — an on-time payment
  /// must be reported by the member first.
  Future<ContributionResponse> confirmPayment(
    String ledgerId,
    String contributionId, {
    String? note,
  }) async {
    try {
      final response = await _dio.post(
        '/api/ledgers/$ledgerId/contributions/$contributionId/confirm',
        data: ContributionActionRequest(note: note).toJson(),
      );
      return ContributionResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// ADMIN-only, only from REPORTED — the member's report was wrong or
  /// unconfirmed, back to PENDING to try again. Clears reportedAt/memberNote
  /// server-side.
  Future<ContributionResponse> rejectReport(
    String ledgerId,
    String contributionId, {
    String? note,
  }) async {
    try {
      final response = await _dio.post(
        '/api/ledgers/$ledgerId/contributions/$contributionId/reject',
        data: ContributionActionRequest(note: note).toJson(),
      );
      return ContributionResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// ADMIN-only, only from MISSED — gives a late payment a chance before
  /// the cycle closes. Member can then report-payment on it as normal.
  Future<ContributionResponse> reopenForLatePayment(
    String ledgerId,
    String contributionId, {
    String? note,
  }) async {
    try {
      final response = await _dio.post(
        '/api/ledgers/$ledgerId/contributions/$contributionId/reopen',
        data: ContributionActionRequest(note: note).toJson(),
      );
      return ContributionResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Any active member — not admin-only, transparency is the point.
  /// Realistically a handful of entries, not paginated (API.md).
  Future<List<ContributionActivityLogEntry>> getHistory(
    String ledgerId,
    String contributionId,
  ) async {
    try {
      final response = await _dio
          .get('/api/ledgers/$ledgerId/contributions/$contributionId/history');
      return (response.data as List)
          .map((e) =>
              ContributionActivityLogEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Same visibility as getHistory — any active member — but only once
  /// the contribution is PAID (API.md: 400 otherwise). Returns the raw
  /// CSV text; `responseType: plain` is required since this endpoint's
  /// Content-Type is text/csv, not application/json.
  Future<String> exportHistoryCsv(
    String ledgerId,
    String contributionId,
  ) async {
    try {
      final response = await _dio.get<String>(
        '/api/ledgers/$ledgerId/contributions/$contributionId/history/export',
        options: Options(responseType: ResponseType.plain),
      );
      return response.data ?? '';
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

final contributionRepositoryProvider = Provider<ContributionRepository>((ref) {
  return ContributionRepository(ref.watch(dioProvider));
});
