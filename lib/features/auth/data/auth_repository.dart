import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import 'models/auth_models.dart';

/// Wraps exactly the endpoints API.md's Auth section documents — nothing
/// more, nothing from Account leaking in (blueprint Section 9's per-domain
/// repository rule).
class AuthRepository {
  AuthRepository(this._dio);

  final Dio _dio;

  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response =
          await _dio.post('/api/auth/register', data: request.toJson());
      return RegisterResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<AuthSession> login(LoginRequest request) async {
    try {
      final response =
          await _dio.post('/api/auth/login', data: request.toJson());
      return AuthSession.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Not used by screens directly — AuthInterceptor calls its own refresh
  /// via a bare Dio instance (blueprint Section 5.2). Kept here anyway so
  /// AuthRepository stays the complete, honest wrapper of API.md's Auth
  /// section rather than one endpoint short of it.
  Future<AuthSession> refresh(String refreshToken) async {
    try {
      final response = await _dio.post(
        '/api/auth/refresh',
        data: RefreshRequest(refreshToken: refreshToken).toJson(),
      );
      return AuthSession.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> logout(String refreshToken) async {
    try {
      await _dio.post(
        '/api/auth/logout',
        data: LogoutRequest(refreshToken: refreshToken).toJson(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> logoutAll() async {
    try {
      await _dio.post('/api/auth/logout-all');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> verifyEmail(EmailVerifyRequest request) async {
    try {
      await _dio.post('/api/auth/email-verify', data: request.toJson());
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> resendVerification(String email) async {
    try {
      await _dio.post(
        '/api/auth/resend-verification',
        data: ResendVerificationRequest(email: email).toJson(),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(dioProvider));
});
