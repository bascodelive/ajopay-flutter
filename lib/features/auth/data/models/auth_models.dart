import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

@freezed
class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    required String email,
    required String phone,
    required String password,
    required String fullName,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}

@freezed
class RegisterResponse with _$RegisterResponse {
  const factory RegisterResponse({
    required String userId,
    required String email,
    required String message,
  }) = _RegisterResponse;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);
}

@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

/// Shared by /login and /refresh — API.md documents /refresh as returning
/// "same shape as login".
@freezed
class AuthSession with _$AuthSession {
  const factory AuthSession({
    required String userId,
    required String fullName,
    required String email,
    required String accessToken,
    required String refreshToken,
  }) = _AuthSession;

  factory AuthSession.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionFromJson(json);
}

@freezed
class RefreshRequest with _$RefreshRequest {
  const factory RefreshRequest({required String refreshToken}) =
      _RefreshRequest;

  factory RefreshRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshRequestFromJson(json);
}

@freezed
class LogoutRequest with _$LogoutRequest {
  const factory LogoutRequest({required String refreshToken}) = _LogoutRequest;

  factory LogoutRequest.fromJson(Map<String, dynamic> json) =>
      _$LogoutRequestFromJson(json);
}

@freezed
class EmailVerifyRequest with _$EmailVerifyRequest {
  const factory EmailVerifyRequest({
    required String email,
    required String code,
  }) = _EmailVerifyRequest;

  factory EmailVerifyRequest.fromJson(Map<String, dynamic> json) =>
      _$EmailVerifyRequestFromJson(json);
}

@freezed
class ResendVerificationRequest with _$ResendVerificationRequest {
  const factory ResendVerificationRequest({required String email}) =
      _ResendVerificationRequest;

  factory ResendVerificationRequest.fromJson(Map<String, dynamic> json) =>
      _$ResendVerificationRequestFromJson(json);
}
