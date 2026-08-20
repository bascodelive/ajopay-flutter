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
/// `exportHistoryCsv` added alongside the backend's own history/export
/// addition; `scheduleBatch` added alongside the backend's own
/// POST .../contributions/batch addition.
class ContributionRepository {
  ContributionRepository(this._dio);

  final Dio _dio;

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
  /// member's cycle — manual. Independent of any Circle entirely; see
  /// `scheduleBatch` below for the multi-member fan-out of this same
  /// operation.
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

  /// ADMIN-only server-side. Same operation as scheduleContribution
  /// above, fanned out to several (or all) members for one cycleDate in
  /// one call. Never partially fails — a member who already has a
  /// contribution for that date, or is no longer an active member, ends
  /// up in the response's `skipped` list with a reason instead of
  /// failing the whole call.
  Future<BatchScheduleContributionResponse> scheduleBatch(
    String ledgerId,
    List<String> memberUserIds,
    String cycleDate,
  ) async {
    try {
      final response = await _dio.post(
        '/api/ledgers/$ledgerId/contributions/batch',
        data: BatchScheduleContributionRequest(
          memberUserIds: memberUserIds,
          cycleDate: cycleDate,
        ).toJson(),
      );
      return BatchScheduleContributionResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

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