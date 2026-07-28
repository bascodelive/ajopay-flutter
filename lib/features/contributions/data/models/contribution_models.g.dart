// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contribution_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContributionResponseImpl _$$ContributionResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ContributionResponseImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      memberFullName: json['memberFullName'] as String,
      amount: (json['amount'] as num).toDouble(),
      cycleDate: json['cycleDate'] as String,
      status: json['status'] as String,
      recordedByFullName: json['recordedByFullName'] as String?,
      reportedAt: json['reportedAt'] as String?,
      memberNote: json['memberNote'] as String?,
      handNumber: (json['handNumber'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$ContributionResponseImplToJson(
        _$ContributionResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'memberFullName': instance.memberFullName,
      'amount': instance.amount,
      'cycleDate': instance.cycleDate,
      'status': instance.status,
      'recordedByFullName': instance.recordedByFullName,
      'reportedAt': instance.reportedAt,
      'memberNote': instance.memberNote,
      'handNumber': instance.handNumber,
    };

_$ScheduleContributionRequestImpl _$$ScheduleContributionRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ScheduleContributionRequestImpl(
      memberUserId: json['memberUserId'] as String,
      cycleDate: json['cycleDate'] as String,
    );

Map<String, dynamic> _$$ScheduleContributionRequestImplToJson(
        _$ScheduleContributionRequestImpl instance) =>
    <String, dynamic>{
      'memberUserId': instance.memberUserId,
      'cycleDate': instance.cycleDate,
    };

_$ContributionActionRequestImpl _$$ContributionActionRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ContributionActionRequestImpl(
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$ContributionActionRequestImplToJson(
        _$ContributionActionRequestImpl instance) =>
    <String, dynamic>{
      'note': instance.note,
    };

_$ContributionActivityLogEntryImpl _$$ContributionActivityLogEntryImplFromJson(
        Map<String, dynamic> json) =>
    _$ContributionActivityLogEntryImpl(
      id: json['id'] as String,
      actorUserId: json['actorUserId'] as String,
      actorFullName: json['actorFullName'] as String,
      actorRole: json['actorRole'] as String,
      action: json['action'] as String,
      previousStatus: json['previousStatus'] as String?,
      newStatus: json['newStatus'] as String,
      note: json['note'] as String?,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$$ContributionActivityLogEntryImplToJson(
        _$ContributionActivityLogEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'actorUserId': instance.actorUserId,
      'actorFullName': instance.actorFullName,
      'actorRole': instance.actorRole,
      'action': instance.action,
      'previousStatus': instance.previousStatus,
      'newStatus': instance.newStatus,
      'note': instance.note,
      'createdAt': instance.createdAt,
    };
