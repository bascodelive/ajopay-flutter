import 'package:freezed_annotation/freezed_annotation.dart';

part 'contribution_models.freezed.dart';
part 'contribution_models.g.dart';

@freezed
class ContributionResponse with _$ContributionResponse {
  const factory ContributionResponse({
    required String id,
    required String userId,
    required String memberFullName,
    required double amount,
    required String cycleDate, // ISO-8601 date (YYYY-MM-DD)
    required String status, // PENDING | REPORTED | PAID | MISSED
    String? recordedByFullName,
    String? reportedAt, // ISO-8601 timestamp, null until member self-reports
    String? memberNote,
    /// 1-indexed. Always 1 for the original manual per-member scheduling
    /// path (`POST .../contributions`, and its batch counterpart below).
    /// A contribution generated via a Circle's rotation
    /// (`POST .../circles/{id}/generate-cycle-contributions`) reflects
    /// which of a multi-hand participant's turns this row is for — a
    /// 2-hand member has TWO rows for the same cycleDate, one with
    /// handNumber 1 and one with handNumber 2. Note there is no
    /// `circleId` on this response even for circle-generated rows — the
    /// backend's ContributionResponse DTO doesn't carry one; a client
    /// that needs to know which circle a row belongs to has to correlate
    /// by cycleDate/userId against the rotation queue separately.
    @Default(1) int handNumber,
  }) = _ContributionResponse;

  factory ContributionResponse.fromJson(Map<String, dynamic> json) =>
      _$ContributionResponseFromJson(json);
}

@freezed
class ScheduleContributionRequest with _$ScheduleContributionRequest {
  const factory ScheduleContributionRequest({
    required String memberUserId,
    required String cycleDate,
  }) = _ScheduleContributionRequest;

  factory ScheduleContributionRequest.fromJson(Map<String, dynamic> json) =>
      _$ScheduleContributionRequestFromJson(json);
}

/// Batch counterpart to ScheduleContributionRequest above — same
/// underlying operation (open one PENDING contribution for one member's
/// cycle), fanned out to several members for the SAME cycleDate in one
/// call. Independent of Circles entirely, same as the single-member
/// path — hand_number is always 1 server-side, nothing here reads or is
/// gated by circle status.
@freezed
class BatchScheduleContributionRequest
    with _$BatchScheduleContributionRequest {
  const factory BatchScheduleContributionRequest({
    required List<String> memberUserIds,
    required String cycleDate,
  }) = _BatchScheduleContributionRequest;

  factory BatchScheduleContributionRequest.fromJson(
          Map<String, dynamic> json) =>
      _$BatchScheduleContributionRequestFromJson(json);
}

/// `created` — every contribution actually opened.
/// `skipped` — every requested member who was NOT given one, and why
/// (already had a contribution for this cycle date, or is no longer an
/// active member). Every requested member ends up in exactly one of
/// these two lists — never silently dropped, never a whole-batch
/// failure because of one bad entry.
@freezed
class BatchScheduleContributionResponse
    with _$BatchScheduleContributionResponse {
  const factory BatchScheduleContributionResponse({
    required List<ContributionResponse> created,
    required List<SkippedMember> skipped,
  }) = _BatchScheduleContributionResponse;

  factory BatchScheduleContributionResponse.fromJson(
          Map<String, dynamic> json) =>
      _$BatchScheduleContributionResponseFromJson(json);
}

@freezed
class SkippedMember with _$SkippedMember {
  const factory SkippedMember({
    required String memberUserId,
    required String reason,
  }) = _SkippedMember;

  factory SkippedMember.fromJson(Map<String, dynamic> json) =>
      _$SkippedMemberFromJson(json);
}

/// Shared across report-payment/miss/confirm/reject/reopen — API.md
/// documents all five of these request bodies as the exact same shape
/// (`{ "note": "string, optional" }`), so one type is used for all five
/// rather than five near-identical classes that would only add
/// duplication to keep in sync, not real type safety (verified against
/// ContributionService's real method signatures — every one of the five
/// just takes a plain `String note` parameter, no per-action distinction
/// at the type level server-side either).
@freezed
class ContributionActionRequest with _$ContributionActionRequest {
  const factory ContributionActionRequest({String? note}) =
      _ContributionActionRequest;

  factory ContributionActionRequest.fromJson(Map<String, dynamic> json) =>
      _$ContributionActionRequestFromJson(json);
}

@freezed
class ContributionActivityLogEntry with _$ContributionActivityLogEntry {
  const factory ContributionActivityLogEntry({
    required String id,
    required String actorUserId,
    required String actorFullName,
    required String actorRole, // MEMBER | ADMIN
    required String action,
    String? previousStatus, // null only for SCHEDULED
    required String newStatus,
    String? note,
    required String createdAt,
  }) = _ContributionActivityLogEntry;

  factory ContributionActivityLogEntry.fromJson(Map<String, dynamic> json) =>
      _$ContributionActivityLogEntryFromJson(json);
}