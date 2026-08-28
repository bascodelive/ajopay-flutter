// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationResponseImpl _$$NotificationResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationResponseImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      referenceId: json['referenceId'] as String?,
      ledgerId: json['ledgerId'] as String?,
      read: json['read'] as bool,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$$NotificationResponseImplToJson(
        _$NotificationResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'body': instance.body,
      'referenceId': instance.referenceId,
      'ledgerId': instance.ledgerId,
      'read': instance.read,
      'createdAt': instance.createdAt,
    };

_$UnreadCountResponseImpl _$$UnreadCountResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$UnreadCountResponseImpl(
      unreadCount: (json['unreadCount'] as num).toInt(),
    );

Map<String, dynamic> _$$UnreadCountResponseImplToJson(
        _$UnreadCountResponseImpl instance) =>
    <String, dynamic>{
      'unreadCount': instance.unreadCount,
    };
