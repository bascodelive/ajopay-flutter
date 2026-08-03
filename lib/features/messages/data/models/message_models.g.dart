// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageResponseImpl _$$MessageResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageResponseImpl(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      senderFullName: json['senderFullName'] as String,
      recipientId: json['recipientId'] as String?,
      recipientFullName: json['recipientFullName'] as String?,
      body: json['body'] as String,
      broadcast: json['broadcast'] as bool,
      sentAt: json['sentAt'] as String,
    );

Map<String, dynamic> _$$MessageResponseImplToJson(
        _$MessageResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'senderFullName': instance.senderFullName,
      'recipientId': instance.recipientId,
      'recipientFullName': instance.recipientFullName,
      'body': instance.body,
      'broadcast': instance.broadcast,
      'sentAt': instance.sentAt,
    };

_$SendMessageRequestImpl _$$SendMessageRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$SendMessageRequestImpl(
      recipientUserId: json['recipientUserId'] as String?,
      body: json['body'] as String,
    );

Map<String, dynamic> _$$SendMessageRequestImplToJson(
        _$SendMessageRequestImpl instance) =>
    <String, dynamic>{
      'recipientUserId': instance.recipientUserId,
      'body': instance.body,
    };
