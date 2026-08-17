import 'package:freezed_annotation/freezed_annotation.dart';

part 'circle_models.freezed.dart';
part 'circle_models.g.dart';

@freezed
class CircleResponse with _$CircleResponse {
  const factory CircleResponse({
    required String id,
    required String ledgerId,
    required String startDate, // ISO-8601 date (YYYY-MM-DD)
    String? endDate, // null until the circle is started

    /// This circle's OWN agreed per-hand contribution amount —
    /// independent of the ledger's own contributionAmount from the
    /// moment this circle is scheduled (see backend Circle's Javadoc).
    /// Editable while PENDING (see UpdateCircleAmountRequest below),
    /// locked the moment the circle starts.
    required double contributionAmount,
    required String status, // PENDING | ACTIVE | COMPLETED
    required String createdAt,
  }) = _CircleResponse;

  factory CircleResponse.fromJson(Map<String, dynamic> json) =>
      _$CircleResponseFromJson(json);
}

@freezed
class CreateCircleRequest with _$CreateCircleRequest {
  const factory CreateCircleRequest({
    required String startDate,

    /// Optional — if omitted, the backend defaults this circle's amount
    /// to the ledger's current contributionAmount at schedule time.
    double? contributionAmount,
  }) = _CreateCircleRequest;

  factory CreateCircleRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCircleRequestFromJson(json);
}

/// ADMIN action, PENDING-only — revises the circle's own agreed amount.
/// Has no effect on the ledger's own default; rejected with 400 once
/// the circle is ACTIVE or COMPLETED.
@freezed
class UpdateCircleAmountRequest with _$UpdateCircleAmountRequest {
  const factory UpdateCircleAmountRequest({
    required double contributionAmount,
  }) = _UpdateCircleAmountRequest;

  factory UpdateCircleAmountRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateCircleAmountRequestFromJson(json);
}

@freezed
class CircleParticipantResponse with _$CircleParticipantResponse {
  const factory CircleParticipantResponse({
    required String userId,
    required String userFullName,
    required int handCount,
  }) = _CircleParticipantResponse;

  factory CircleParticipantResponse.fromJson(Map<String, dynamic> json) =>
      _$CircleParticipantResponseFromJson(json);
}

@freezed
class AddParticipantRequest with _$AddParticipantRequest {
  const factory AddParticipantRequest({
    required String userId,
    required int handCount,
  }) = _AddParticipantRequest;

  factory AddParticipantRequest.fromJson(Map<String, dynamic> json) =>
      _$AddParticipantRequestFromJson(json);
}

@freezed
class AssignRotationRequest with _$AssignRotationRequest {
  const factory AssignRotationRequest({
    required List<String> orderedUserIds,
  }) = _AssignRotationRequest;

  factory AssignRotationRequest.fromJson(Map<String, dynamic> json) =>
      _$AssignRotationRequestFromJson(json);
}

@freezed
class RotationSlotResponse with _$RotationSlotResponse {
  const factory RotationSlotResponse({
    required String id,
    required String userId,
    required String userFullName,
    required int handNumber, // 1-indexed, display only
    required int position, // 0-indexed, the real ordering key
    String? scheduledDate, // null until the circle starts
    required String status, // PENDING | PAID
    double? amount, // null until PAID
    String? paidAt,

    /// Set once the slot's own recipient self-confirms they actually
    /// received the payout an Admin already confirmed. Null until then.
    /// Purely a transparency layer — does NOT gate the rotation moving
    /// forward (confirmPayout already advanced the queue by the time
    /// this can even be called); only meaningful once `status == 'PAID'`.
    String? recipientConfirmedAt,
  }) = _RotationSlotResponse;

  factory RotationSlotResponse.fromJson(Map<String, dynamic> json) =>
      _$RotationSlotResponseFromJson(json);
}

@freezed
class CurrentPayoutResponse with _$CurrentPayoutResponse {
  const factory CurrentPayoutResponse({
    required String slotId,
    required String userId,
    required String userFullName,
    required int handNumber,
    required String scheduledDate,
    required double confirmedSoFar,
    required double targetAmount,

    /// True once this cycle's Contribution rows already exist —
    /// lets the "Generate this cycle's contributions" button grey
    /// itself out proactively instead of only failing with a 400
    /// after the fact.
    required bool alreadyGeneratedThisCycle,
  }) = _CurrentPayoutResponse;

  factory CurrentPayoutResponse.fromJson(Map<String, dynamic> json) =>
      _$CurrentPayoutResponseFromJson(json);
}

@freezed
class ConfirmPayoutRequest with _$ConfirmPayoutRequest {
  const factory ConfirmPayoutRequest({String? note}) = _ConfirmPayoutRequest;

  factory ConfirmPayoutRequest.fromJson(Map<String, dynamic> json) =>
      _$ConfirmPayoutRequestFromJson(json);
}

@freezed
class CircleActivityLogEntry with _$CircleActivityLogEntry {
  const factory CircleActivityLogEntry({
    required String id,
    required String actorUserId,
    required String actorFullName,
    required String action,
    String? note,
    required String createdAt,
  }) = _CircleActivityLogEntry;

  factory CircleActivityLogEntry.fromJson(Map<String, dynamic> json) =>
      _$CircleActivityLogEntryFromJson(json);
}

/// PREMIUM feature — see PREMIUM-FEATURE-payout-slot-transfer.md.
/// Mirrors the backend's PayoutSlotTransferResponse field-for-field —
/// no existing Dart shape to match against, this is a new construction.
@freezed
class PayoutSlotTransferResponse with _$PayoutSlotTransferResponse {
  const factory PayoutSlotTransferResponse({
    required String id,
    required String circleId,
    required String offeringSlotId,
    required String offeredByUserId,
    required String offeredByFullName,

    /// Null = an open offer, any eligible participant can accept.
    String? targetUserId,
    String? targetUserFullName,

    /// Set only once ACCEPTED — the other slot involved in the swap.
    String? acceptingSlotId,
    String? acceptedByUserId,
    String? acceptedByFullName,
    required String
        status, // OFFERED | ACCEPTED | DECLINED | CANCELLED | EXPIRED
    required String createdAt,
    String? resolvedAt,
  }) = _PayoutSlotTransferResponse;

  factory PayoutSlotTransferResponse.fromJson(Map<String, dynamic> json) =>
      _$PayoutSlotTransferResponseFromJson(json);
}

@freezed
class OfferSlotTransferRequest with _$OfferSlotTransferRequest {
  /// Null userId = an open offer, any eligible participant can accept.
  const factory OfferSlotTransferRequest({String? userId}) =
      _OfferSlotTransferRequest;

  factory OfferSlotTransferRequest.fromJson(Map<String, dynamic> json) =>
      _$OfferSlotTransferRequestFromJson(json);
}

@freezed
class AcceptSlotTransferRequest with _$AcceptSlotTransferRequest {
  const factory AcceptSlotTransferRequest({required String acceptingSlotId}) =
      _AcceptSlotTransferRequest;

  factory AcceptSlotTransferRequest.fromJson(Map<String, dynamic> json) =>
      _$AcceptSlotTransferRequestFromJson(json);
}
