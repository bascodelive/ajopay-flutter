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
    required String status, // PENDING | ACTIVE | COMPLETED
    required String createdAt,
  }) = _CircleResponse;

  factory CircleResponse.fromJson(Map<String, dynamic> json) =>
      _$CircleResponseFromJson(json);
}

@freezed
class CreateCircleRequest with _$CreateCircleRequest {
  const factory CreateCircleRequest({required String startDate}) =
      _CreateCircleRequest;

  factory CreateCircleRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCircleRequestFromJson(json);
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
