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

/// The public directory listing shape — deliberately NARROWER than
/// LedgerResponse. Never carries inviteCode (that's the entire join
/// gate) or callerRole/membershipStatus (the caller browsing the
/// directory may have no relationship to a given result at all).
@freezed
class LedgerDirectoryEntryResponse with _$LedgerDirectoryEntryResponse {
  const factory LedgerDirectoryEntryResponse({
    required String id,
    required String name,
    required String contributionFrequency, // DAILY | WEEKLY | MONTHLY
    required double contributionAmount,

    /// 0.0 if never rated — always treat that as "no rating yet," never
    /// as a genuine zero-star average.
    required double averageRating,
    required int ratingCount,
    required String createdAt,
  }) = _LedgerDirectoryEntryResponse;

  factory LedgerDirectoryEntryResponse.fromJson(Map<String, dynamic> json) =>
      _$LedgerDirectoryEntryResponseFromJson(json);
}

@freezed
class RateLedgerRequest with _$RateLedgerRequest {
  const factory RateLedgerRequest({required int stars}) = _RateLedgerRequest;

  factory RateLedgerRequest.fromJson(Map<String, dynamic> json) =>
      _$RateLedgerRequestFromJson(json);
}

/// Mirrors the backend's `DirectorySort` enum exactly — sent as the
/// `orderBy` query parameter on `GET /api/ledgers/directory` (NOT
/// `sort`; that name collides with Spring's own Pageable sort binding
/// on the backend, see the backend's own DirectorySort Javadoc).
///
/// Lives here rather than in `ledger_directory_pager.dart` (unlike
/// `ContributionScope`/`MessageThreadType`, which live in their own
/// pager files) — those two represent genuinely separate backend
/// endpoints the repository exposes as separate methods, so their
/// repository never needs to know the enum exists. This one is a
/// single query parameter on a single endpoint that BOTH the
/// repository and the pager need to reference directly.
enum DirectorySort {
  newest,
  topRated;

  /// The exact string the backend expects — matches its Java enum's
  /// `.name()` exactly, since Spring's default query-param-to-enum
  /// binding is case-sensitive to the literal constant name.
  String get wireValue => switch (this) {
        DirectorySort.newest => 'NEWEST',
        DirectorySort.topRated => 'TOP_RATED',
      };
}

@freezed
class LedgerRatingResponse with _$LedgerRatingResponse {
  const factory LedgerRatingResponse({
    required String ledgerId,
    required int stars,
    required String updatedAt,
  }) = _LedgerRatingResponse;

  factory LedgerRatingResponse.fromJson(Map<String, dynamic> json) =>
      _$LedgerRatingResponseFromJson(json);
}

/// The caller's own current standing against their tier's active-ledger
/// limit — `GET /api/ledgers/limit`. Deliberately caller-scoped, not a
/// static "here are both tiers' numbers" shape — matches the backend's
/// own `LedgerLimitResponse` exactly, same reasoning documented there.
@freezed
class LedgerLimitResponse with _$LedgerLimitResponse {
  const LedgerLimitResponse._();

  const factory LedgerLimitResponse({
    required int maxActiveGroups,
    required int activeGroupCount,
  }) = _LedgerLimitResponse;

  factory LedgerLimitResponse.fromJson(Map<String, dynamic> json) =>
      _$LedgerLimitResponseFromJson(json);

  bool get isAtLimit => activeGroupCount >= maxActiveGroups;
}
