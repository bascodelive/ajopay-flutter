import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_models.freezed.dart';
part 'message_models.g.dart';

@freezed
class MessageResponse with _$MessageResponse {
  const factory MessageResponse({
    required String id,
    required String senderId,
    required String senderFullName,
    String? recipientId,
    String? recipientFullName,
    required String body,
    /// true = a post to the shared group thread (recipientId is null).
    /// false = a private message between exactly two participants.
    required bool broadcast,
    required String sentAt, // ISO-8601 timestamp
  }) = _MessageResponse;

  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseFromJson(json);
}

/// recipientUserId null = post to the shared group thread; a value =
/// private message to that specific member. Sending is Premium-gated
/// server-side (and behind a global feature flag) — reading never is.
@freezed
class SendMessageRequest with _$SendMessageRequest {
  const factory SendMessageRequest({
    String? recipientUserId,
    required String body,
  }) = _SendMessageRequest;

  factory SendMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$SendMessageRequestFromJson(json);
}
