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
    /// The CALLER's own membership status on this ledger — NOT the
    /// ledger's own status (see `status` above for that). Added when
    /// joining stopped being instant: a join now returns PENDING until
    /// the ledger's Admin approves it. Every other endpoint that returns
    /// a LedgerResponse (create/get/update/getMyLedgers) only ever does
    /// so for an ACTIVE caller server-side, so this is always 'ACTIVE'
    /// there — only the join response can meaningfully be 'PENDING'.
    required String
        membershipStatus, // ACTIVE | PENDING | INVALIDATED | REMOVED
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
    /// ACTIVE — approved, full access.
    /// PENDING — requested to join, awaiting Admin approval/rejection.
    /// INVALIDATED — declined by the Admin, OR auto-invalidated because
    ///   this user (on a free-tier account) requested to join a
    ///   different ledger while this request was still pending.
    /// REMOVED — was ACTIVE, then removed by the Admin.
    required String status,
    required String joinedAt,
  }) = _LedgerMemberResponse;

  factory LedgerMemberResponse.fromJson(Map<String, dynamic> json) =>
      _$LedgerMemberResponseFromJson(json);
}
