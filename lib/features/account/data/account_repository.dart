import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import 'models/account_models.dart';

/// Wraps exactly the endpoints API.md's Account section documents — nothing
/// from Auth leaking in, mirroring the backend's own controller boundary.
class AccountRepository {
  AccountRepository(this._dio);

  final Dio _dio;

  Future<ProfileResponse> getProfile() async {
    try {
      final response = await _dio.get('/api/account/profile');
      return ProfileResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<ProfileResponse> updateProfile(UpdateProfileRequest request) async {
    try {
      final response =
          await _dio.patch('/api/account/profile', data: request.toJson());
      return ProfileResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Self-service — changes the caller's own avatar to any other preset.
  /// Always succeeds for a valid avatarId; there's no partial-failure
  /// case beyond the usual network/auth ones.
  Future<ProfileResponse> updateAvatar(String avatarId) async {
    try {
      final response = await _dio.patch(
        '/api/account/profile/avatar',
        data: UpdateAvatarRequest(avatarId: avatarId).toJson(),
      );
      return ProfileResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> changePassword(ChangePasswordRequest request) async {
    try {
      await _dio.post('/api/account/change-password', data: request.toJson());
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _dio.post(
        '/api/account/forgot-password',
        data: ForgotPasswordRequest(email: email).toJson(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> resetPassword(ResetPasswordRequest request) async {
    try {
      await _dio.post('/api/account/reset-password', data: request.toJson());
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return AccountRepository(ref.watch(dioProvider));
});
