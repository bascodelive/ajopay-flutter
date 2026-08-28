import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_models.freezed.dart';
part 'notification_models.g.dart';

@freezed
class NotificationResponse with _$NotificationResponse {
  const factory NotificationResponse({
    required String id,
    required String type, // COMPLAINT_REPLY | CONTRIBUTION_DUE
    required String title,
    required String body,

    /// e.g. the complaint id or contribution id, for deep-linking.
    String? referenceId,

    /// Null for a notification type with no ledger (e.g.
    /// COMPLAINT_REPLY — its detail lookup, GET /api/complaints/{id},
    /// is global/non-nested). Set for CONTRIBUTION_DUE, needed to route
    /// into GET /ledgers/{ledgerId}/contributions/{referenceId}.
    String? ledgerId,
    required bool read,
    required String createdAt,
  }) = _NotificationResponse;

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseFromJson(json);
}

@freezed
class UnreadCountResponse with _$UnreadCountResponse {
  const factory UnreadCountResponse({required int unreadCount}) =
      _UnreadCountResponse;

  factory UnreadCountResponse.fromJson(Map<String, dynamic> json) =>
      _$UnreadCountResponseFromJson(json);
}