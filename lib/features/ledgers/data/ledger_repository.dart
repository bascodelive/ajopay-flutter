import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../../shared/models/page_response.dart';
import 'models/ledger_models.dart';

/// Wraps exactly the endpoints API.md's Ledgers section documents.
class LedgerRepository {
  LedgerRepository(this._dio);

  final Dio _dio;

  Future<List<LedgerResponse>> getMyLedgers() async {
    try {
      final response = await _dio.get('/api/ledgers');
      return (response.data as List)
          .map((e) => LedgerResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<LedgerLimitResponse> getLedgerLimit() async {
    try {
      final response = await _dio.get('/api/ledgers/limit');
      return LedgerLimitResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<LedgerResponse> createLedger(CreateLedgerRequest request) async {
    try {
      final response = await _dio.post('/api/ledgers', data: request.toJson());
      return LedgerResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<LedgerResponse> joinLedger(String inviteCode) async {
    try {
      final response = await _dio.post(
        '/api/ledgers/join',
        data: JoinLedgerRequest(inviteCode: inviteCode).toJson(),
      );
      return LedgerResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<LedgerResponse> getLedger(String ledgerId) async {
    try {
      final response = await _dio.get('/api/ledgers/$ledgerId');
      return LedgerResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// ADMIN-only server-side — API.md documents 403 for a non-Admin caller.
  Future<LedgerResponse> updateLedger(
    String ledgerId,
    UpdateLedgerRequest request,
  ) async {
    try {
      final response = await _dio.patch(
        '/api/ledgers/$ledgerId',
        data: request.toJson(),
      );
      return LedgerResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// ADMIN-only, deliberately its OWN endpoint — see
  /// SetAutoGenerateContributionsRequest's doc for why this isn't folded
  /// into updateLedger above. Rejected (403) if this ledger is currently
  /// locked, same guard as updateLedger.
  Future<LedgerResponse> setAutoGenerateContributions(
    String ledgerId,
    bool enabled,
  ) async {
    try {
      final response = await _dio.post(
        '/api/ledgers/$ledgerId/auto-generate-contributions',
        data: SetAutoGenerateContributionsRequest(enabled: enabled).toJson(),
      );
      return LedgerResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> chooseKeptLedger(String ledgerId) async {
    try {
      await _dio.post('/api/ledgers/$ledgerId/keep-free');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<LedgerMemberResponse>> getMembers(String ledgerId) async {
    try {
      final response = await _dio.get('/api/ledgers/$ledgerId/members');
      return (response.data as List)
          .map((e) => LedgerMemberResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<LedgerMemberResponse> getMyMembership(String ledgerId) async {
    try {
      final response = await _dio.get('/api/ledgers/$ledgerId/members/me');
      return LedgerMemberResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<LedgerMemberResponse>> getPendingMembers(String ledgerId) async {
    try {
      final response = await _dio.get('/api/ledgers/$ledgerId/members/pending');
      return (response.data as List)
          .map((e) => LedgerMemberResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<LedgerMemberResponse> approveMember(
    String ledgerId,
    String userId,
  ) async {
    try {
      final response =
          await _dio.post('/api/ledgers/$ledgerId/members/$userId/approve');
      return LedgerMemberResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<LedgerMemberResponse> rejectMember(
    String ledgerId,
    String userId,
  ) async {
    try {
      final response =
          await _dio.post('/api/ledgers/$ledgerId/members/$userId/reject');
      return LedgerMemberResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<PageResponse<LedgerDirectoryEntryResponse>> getDirectory({
    String? search,
    DirectorySort orderBy = DirectorySort.newest,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/api/ledgers/directory',
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
          'orderBy': orderBy.wireValue,
          'page': page,
          'size': size,
        },
      );
      return PageResponse<LedgerDirectoryEntryResponse>.fromJson(
        response.data as Map<String, dynamic>,
        (json) =>
            LedgerDirectoryEntryResponse.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<LedgerRatingResponse> rateLedger(
    String ledgerId,
    int stars, {
    String? reviewText,
  }) async {
    try {
      final response = await _dio.put(
        '/api/ledgers/$ledgerId/rating',
        data: RateLedgerRequest(stars: stars, reviewText: reviewText).toJson(),
      );
      return LedgerRatingResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<LedgerRatingResponse?> getMyRating(String ledgerId) async {
    try {
      final response = await _dio.get('/api/ledgers/$ledgerId/rating/me');
      return LedgerRatingResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final apiException = ApiException.fromDioException(e);
      if (apiException.isNotFound) return null;
      throw apiException;
    }
  }

  Future<PageResponse<LedgerReviewResponse>> getReviews(
    String ledgerId, {
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/api/ledgers/$ledgerId/ratings',
        queryParameters: {'page': page, 'size': size},
      );
      return PageResponse<LedgerReviewResponse>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => LedgerReviewResponse.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

final ledgerRepositoryProvider = Provider<LedgerRepository>((ref) {
  return LedgerRepository(ref.watch(dioProvider));
});