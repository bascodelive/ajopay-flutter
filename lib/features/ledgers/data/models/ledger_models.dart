import 'package:freezed_annotation/freezed_annotation.dart';

part 'ledger_models.freezed.dart';
part 'ledger_models.g.dart';

@freezed
class LedgerResponse with _$LedgerResponse {
  const factory LedgerResponse({
    required String id,
    required String name,
    required String inviteCode,
    required String contributionFrequency, // DAILY | WEEKLY | MONTHLY
    required double contributionAmount,
    required String status, // ACTIVE | SUSPENDED
    required String callerRole, // ADMIN | PRESIDENT | ASSISTANT | MEMBER
  }) = _LedgerResponse;

  factory LedgerResponse.fromJson(Map<String, dynamic> json) =>
      _$LedgerResponseFromJson(json);
}

@freezed
class CreateLedgerRequest with _$CreateLedgerRequest {
  const factory CreateLedgerRequest({
    required String name,
    required String contributionFrequency,
    required double contributionAmount,
  }) = _CreateLedgerRequest;

  factory CreateLedgerRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateLedgerRequestFromJson(json);
}

/// Same field shape as CreateLedgerRequest, kept as a separate type —
/// consistent with this codebase's existing convention of one request type
/// per endpoint even where shapes overlap (see LogoutRequest/RefreshRequest
/// in the Auth domain), and API.md documents PATCH as full-replacement, not
/// partial — semantically a distinct operation from create.
@freezed
class UpdateLedgerRequest with _$UpdateLedgerRequest {
  const factory UpdateLedgerRequest({
    required String name,
    required String contributionFrequency,
    required double contributionAmount,
  }) = _UpdateLedgerRequest;

  factory UpdateLedgerRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateLedgerRequestFromJson(json);
}

@freezed
class JoinLedgerRequest with _$JoinLedgerRequest {
  const factory JoinLedgerRequest({required String inviteCode}) =
      _JoinLedgerRequest;

  factory JoinLedgerRequest.fromJson(Map<String, dynamic> json) =>
      _$JoinLedgerRequestFromJson(json);
}

@freezed
class LedgerMemberResponse with _$LedgerMemberResponse {
  const factory LedgerMemberResponse({
    required String userId,
    required String fullName,
    required String role, // ADMIN | PRESIDENT | ASSISTANT | MEMBER
    required String status, // ACTIVE | REMOVED
    required String joinedAt,
  }) = _LedgerMemberResponse;

  factory LedgerMemberResponse.fromJson(Map<String, dynamic> json) =>
      _$LedgerMemberResponseFromJson(json);
}
