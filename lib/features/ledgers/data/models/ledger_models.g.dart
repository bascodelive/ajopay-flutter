// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LedgerResponseImpl _$$LedgerResponseImplFromJson(Map<String, dynamic> json) =>
    _$LedgerResponseImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      inviteCode: json['inviteCode'] as String,
      contributionFrequency: json['contributionFrequency'] as String,
      contributionAmount: (json['contributionAmount'] as num).toDouble(),
      status: json['status'] as String,
      callerRole: json['callerRole'] as String,
      membershipStatus: json['membershipStatus'] as String,
    );

Map<String, dynamic> _$$LedgerResponseImplToJson(
        _$LedgerResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'inviteCode': instance.inviteCode,
      'contributionFrequency': instance.contributionFrequency,
      'contributionAmount': instance.contributionAmount,
      'status': instance.status,
      'callerRole': instance.callerRole,
      'membershipStatus': instance.membershipStatus,
    };

_$CreateLedgerRequestImpl _$$CreateLedgerRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateLedgerRequestImpl(
      name: json['name'] as String,
      contributionFrequency: json['contributionFrequency'] as String,
      contributionAmount: (json['contributionAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$$CreateLedgerRequestImplToJson(
        _$CreateLedgerRequestImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'contributionFrequency': instance.contributionFrequency,
      'contributionAmount': instance.contributionAmount,
    };

_$UpdateLedgerRequestImpl _$$UpdateLedgerRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateLedgerRequestImpl(
      name: json['name'] as String,
      contributionFrequency: json['contributionFrequency'] as String,
      contributionAmount: (json['contributionAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$$UpdateLedgerRequestImplToJson(
        _$UpdateLedgerRequestImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'contributionFrequency': instance.contributionFrequency,
      'contributionAmount': instance.contributionAmount,
    };

_$JoinLedgerRequestImpl _$$JoinLedgerRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$JoinLedgerRequestImpl(
      inviteCode: json['inviteCode'] as String,
    );

Map<String, dynamic> _$$JoinLedgerRequestImplToJson(
        _$JoinLedgerRequestImpl instance) =>
    <String, dynamic>{
      'inviteCode': instance.inviteCode,
    };

_$LedgerMemberResponseImpl _$$LedgerMemberResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$LedgerMemberResponseImpl(
      userId: json['userId'] as String,
      fullName: json['fullName'] as String,
      role: json['role'] as String,
      status: json['status'] as String,
      joinedAt: json['joinedAt'] as String,
    );

Map<String, dynamic> _$$LedgerMemberResponseImplToJson(
        _$LedgerMemberResponseImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'fullName': instance.fullName,
      'role': instance.role,
      'status': instance.status,
      'joinedAt': instance.joinedAt,
    };
