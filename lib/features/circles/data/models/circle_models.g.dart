// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CircleResponseImpl _$$CircleResponseImplFromJson(Map<String, dynamic> json) =>
    _$CircleResponseImpl(
      id: json['id'] as String,
      ledgerId: json['ledgerId'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String?,
      status: json['status'] as String,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$$CircleResponseImplToJson(
        _$CircleResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ledgerId': instance.ledgerId,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'status': instance.status,
      'createdAt': instance.createdAt,
    };

_$CreateCircleRequestImpl _$$CreateCircleRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateCircleRequestImpl(
      startDate: json['startDate'] as String,
    );

Map<String, dynamic> _$$CreateCircleRequestImplToJson(
        _$CreateCircleRequestImpl instance) =>
    <String, dynamic>{
      'startDate': instance.startDate,
    };

_$CircleParticipantResponseImpl _$$CircleParticipantResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$CircleParticipantResponseImpl(
      userId: json['userId'] as String,
      userFullName: json['userFullName'] as String,
      handCount: (json['handCount'] as num).toInt(),
    );

Map<String, dynamic> _$$CircleParticipantResponseImplToJson(
        _$CircleParticipantResponseImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userFullName': instance.userFullName,
      'handCount': instance.handCount,
    };

_$AddParticipantRequestImpl _$$AddParticipantRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$AddParticipantRequestImpl(
      userId: json['userId'] as String,
      handCount: (json['handCount'] as num).toInt(),
    );

Map<String, dynamic> _$$AddParticipantRequestImplToJson(
        _$AddParticipantRequestImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'handCount': instance.handCount,
    };

_$AssignRotationRequestImpl _$$AssignRotationRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$AssignRotationRequestImpl(
      orderedUserIds: (json['orderedUserIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$AssignRotationRequestImplToJson(
        _$AssignRotationRequestImpl instance) =>
    <String, dynamic>{
      'orderedUserIds': instance.orderedUserIds,
    };

_$RotationSlotResponseImpl _$$RotationSlotResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$RotationSlotResponseImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userFullName: json['userFullName'] as String,
      handNumber: (json['handNumber'] as num).toInt(),
      position: (json['position'] as num).toInt(),
      scheduledDate: json['scheduledDate'] as String?,
      status: json['status'] as String,
      amount: (json['amount'] as num?)?.toDouble(),
      paidAt: json['paidAt'] as String?,
      recipientConfirmedAt: json['recipientConfirmedAt'] as String?,
    );

Map<String, dynamic> _$$RotationSlotResponseImplToJson(
        _$RotationSlotResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userFullName': instance.userFullName,
      'handNumber': instance.handNumber,
      'position': instance.position,
      'scheduledDate': instance.scheduledDate,
      'status': instance.status,
      'amount': instance.amount,
      'paidAt': instance.paidAt,
      'recipientConfirmedAt': instance.recipientConfirmedAt,
    };

_$CurrentPayoutResponseImpl _$$CurrentPayoutResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$CurrentPayoutResponseImpl(
      slotId: json['slotId'] as String,
      userId: json['userId'] as String,
      userFullName: json['userFullName'] as String,
      handNumber: (json['handNumber'] as num).toInt(),
      scheduledDate: json['scheduledDate'] as String,
      confirmedSoFar: (json['confirmedSoFar'] as num).toDouble(),
      targetAmount: (json['targetAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$$CurrentPayoutResponseImplToJson(
        _$CurrentPayoutResponseImpl instance) =>
    <String, dynamic>{
      'slotId': instance.slotId,
      'userId': instance.userId,
      'userFullName': instance.userFullName,
      'handNumber': instance.handNumber,
      'scheduledDate': instance.scheduledDate,
      'confirmedSoFar': instance.confirmedSoFar,
      'targetAmount': instance.targetAmount,
    };

_$ConfirmPayoutRequestImpl _$$ConfirmPayoutRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ConfirmPayoutRequestImpl(
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$ConfirmPayoutRequestImplToJson(
        _$ConfirmPayoutRequestImpl instance) =>
    <String, dynamic>{
      'note': instance.note,
    };

_$CircleActivityLogEntryImpl _$$CircleActivityLogEntryImplFromJson(
        Map<String, dynamic> json) =>
    _$CircleActivityLogEntryImpl(
      id: json['id'] as String,
      actorUserId: json['actorUserId'] as String,
      actorFullName: json['actorFullName'] as String,
      action: json['action'] as String,
      note: json['note'] as String?,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$$CircleActivityLogEntryImplToJson(
        _$CircleActivityLogEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'actorUserId': instance.actorUserId,
      'actorFullName': instance.actorFullName,
      'action': instance.action,
      'note': instance.note,
      'createdAt': instance.createdAt,
    };
