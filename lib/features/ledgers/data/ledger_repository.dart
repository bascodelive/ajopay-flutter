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

  /// Every ledger the caller is currently an ACTIVE member of — not a
  /// public directory (see getDirectory below for that). Joining a NEW
  /// ledger still only ever happens via invite code (joinLedger below);
  /// this just answers "what do I already belong to." A PENDING request
  /// never appears here — only an approved membership does (server-side:
  /// this is ACTIVE-only).
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

  Future<LedgerResponse> createLedger(CreateLedgerRequest request) async {
    try {
      final response = await _dio.post('/api/ledgers', data: request.toJson());
      return LedgerResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Creates a PENDING membership request, NOT an active one — the
  /// ledger's Admin must approve it before the caller can do anything
  /// else on this ledger. Check `LedgerResponse.membershipStatus` on the
  /// result rather than assuming success means "you're in now."
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

  /// Any active member can call this now (API.md updated — used to be
  /// ADMIN-only). Every ACTIVE member of the ledger, not paginated
  /// (API.md: bounded list, realistically dozens of rows). PENDING and
  /// INVALIDATED members never appear here — see getPendingMembers below
  /// for the Admin's separate "who's waiting" view.
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

  /// The caller's own membership row on this ledger, whatever its status
  /// — deliberately NOT ACTIVE-gated server-side, so a still-PENDING
  /// caller can check "am I approved yet?" instead of just getting a 403.
  Future<LedgerMemberResponse> getMyMembership(String ledgerId) async {
    try {
      final response = await _dio.get('/api/ledgers/$ledgerId/members/me');
      return LedgerMemberResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// ADMIN-only — everyone currently waiting to be let into this ledger.
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

  /// ADMIN-only — approves a PENDING join request, activating it.
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

  /// ADMIN-only — declines a PENDING join request (INVALIDATED).
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

  /// The public directory — every ACTIVE ledger in the system, browsable
  /// by any registered user with at least one active membership
  /// somewhere (server-side gate; see API.md). Deliberately returns the
  /// narrower LedgerDirectoryEntryResponse, never the real LedgerResponse
  /// (no inviteCode leak to non-members).
  Future<PageResponse<LedgerDirectoryEntryResponse>> getDirectory({
    String? search,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/api/ledgers/directory',
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
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

  /// Upserts the caller's own 1-5 star rating on this ledger. Same
  /// membership gate as getDirectory; additionally rejected (403) if the
  /// caller is this ledger's own Admin.
  Future<LedgerRatingResponse> rateLedger(String ledgerId, int stars) async {
    try {
      final response = await _dio.put(
        '/api/ledgers/$ledgerId/rating',
        data: RateLedgerRequest(stars: stars).toJson(),
      );
      return LedgerRatingResponse.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// The caller's own existing rating on this ledger — null if they
  /// haven't rated it yet (a 404 here is a normal, expected outcome, not
  /// an error state; see getMyRating's caller).
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
}

final ledgerRepositoryProvider = Provider<LedgerRepository>((ref) {
  return LedgerRepository(ref.watch(dioProvider));
});
