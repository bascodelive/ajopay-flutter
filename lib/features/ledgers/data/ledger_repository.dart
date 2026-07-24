import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import 'models/ledger_models.dart';

/// Wraps exactly the endpoints API.md's Ledgers section documents.
///
/// Notably absent, because it doesn't exist in API.md: a "list all my
/// ledgers" endpoint. Every method here requires an already-known
/// ledgerId except create/join, which return one. See BUILD_PHASES.md
/// Phase 3 for the open question this creates for the home screen.
class LedgerRepository {
  LedgerRepository(this._dio);

  final Dio _dio;

  /// Every ledger the caller is currently an ACTIVE member of — not a
  /// public directory. Ajopay has no ledger-browsing/discovery feature by
  /// design; joining a NEW ledger still only ever happens via invite code
  /// (joinLedger below). This just answers "what do I already belong to."
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
  /// ADMIN-only). Every active member of the ledger, not paginated
  /// (API.md: bounded list, realistically dozens of rows).
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
}

final ledgerRepositoryProvider = Provider<LedgerRepository>((ref) {
  return LedgerRepository(ref.watch(dioProvider));
});
