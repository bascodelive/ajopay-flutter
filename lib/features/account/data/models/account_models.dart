import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_models.freezed.dart';
part 'account_models.g.dart';

@freezed
class ProfileResponse with _$ProfileResponse {
  const factory ProfileResponse({
    required String id,
    required String email,
    String? phone,
    required String fullName,
    required bool emailVerified,
    required bool phoneVerified,
    required String subscriptionTier, // FREE | PREMIUM
    /// One of AVATAR_1..AVATAR_8 — a fixed preset, never a real photo
    /// (out of scope for this version). Assigned automatically at
    /// registration, changeable anytime via updateAvatar. What each
    /// preset actually looks like (icon/color) is purely a client-side
    /// decision — see core/widgets/avatar_display.dart.
    required String avatarId,
  }) = _ProfileResponse;

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);
}

@freezed
class UpdateProfileRequest with _$UpdateProfileRequest {
  const factory UpdateProfileRequest({
    required String fullName,
    String? phone,
  }) = _UpdateProfileRequest;

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestFromJson(json);
}

/// Its own request type, its own endpoint (`PATCH .../profile/avatar`) —
/// deliberately not folded into UpdateProfileRequest, same "one distinct
/// action per endpoint" convention this app already uses elsewhere
/// (Contribution's five separate action verbs rather than one generic
/// status setter; Circle's confirm-payout vs confirm-received).
@freezed
class UpdateAvatarRequest with _$UpdateAvatarRequest {
  const factory UpdateAvatarRequest({required String avatarId}) =
      _UpdateAvatarRequest;

  factory UpdateAvatarRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateAvatarRequestFromJson(json);
}

@freezed
class ChangePasswordRequest with _$ChangePasswordRequest {
  const factory ChangePasswordRequest({
    required String currentPassword,
    required String newPassword,
  }) = _ChangePasswordRequest;

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestFromJson(json);
}

@freezed
class ForgotPasswordRequest with _$ForgotPasswordRequest {
  const factory ForgotPasswordRequest({required String email}) =
      _ForgotPasswordRequest;

  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordRequestFromJson(json);
}

@freezed
class ResetPasswordRequest with _$ResetPasswordRequest {
  const factory ResetPasswordRequest({
    required String email,
    required String code,
    required String newPassword,
  }) = _ResetPasswordRequest;

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestFromJson(json);
}
