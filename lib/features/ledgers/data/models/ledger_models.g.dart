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

_$LedgerDirectoryEntryResponseImpl _$$LedgerDirectoryEntryResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$LedgerDirectoryEntryResponseImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      contributionFrequency: json['contributionFrequency'] as String,
      contributionAmount: (json['contributionAmount'] as num).toDouble(),
      averageRating: (json['averageRating'] as num).toDouble(),
      ratingCount: (json['ratingCount'] as num).toInt(),
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$$LedgerDirectoryEntryResponseImplToJson(
        _$LedgerDirectoryEntryResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'contributionFrequency': instance.contributionFrequency,
      'contributionAmount': instance.contributionAmount,
      'averageRating': instance.averageRating,
      'ratingCount': instance.ratingCount,
      'createdAt': instance.createdAt,
    };

_$RateLedgerRequestImpl _$$RateLedgerRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$RateLedgerRequestImpl(
      stars: (json['stars'] as num).toInt(),
      reviewText: json['reviewText'] as String?,
    );

Map<String, dynamic> _$$RateLedgerRequestImplToJson(
        _$RateLedgerRequestImpl instance) =>
    <String, dynamic>{
      'stars': instance.stars,
      'reviewText': instance.reviewText,
    };

_$LedgerRatingResponseImpl _$$LedgerRatingResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$LedgerRatingResponseImpl(
      ledgerId: json['ledgerId'] as String,
      stars: (json['stars'] as num).toInt(),
      reviewText: json['reviewText'] as String?,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$$LedgerRatingResponseImplToJson(
        _$LedgerRatingResponseImpl instance) =>
    <String, dynamic>{
      'ledgerId': instance.ledgerId,
      'stars': instance.stars,
      'reviewText': instance.reviewText,
      'updatedAt': instance.updatedAt,
    };

_$LedgerReviewResponseImpl _$$LedgerReviewResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$LedgerReviewResponseImpl(
      userId: json['userId'] as String,
      reviewerFullName: json['reviewerFullName'] as String,
      stars: (json['stars'] as num).toInt(),
      reviewText: json['reviewText'] as String?,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$$LedgerReviewResponseImplToJson(
        _$LedgerReviewResponseImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'reviewerFullName': instance.reviewerFullName,
      'stars': instance.stars,
      'reviewText': instance.reviewText,
      'createdAt': instance.createdAt,
    };

_$LedgerLimitResponseImpl _$$LedgerLimitResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$LedgerLimitResponseImpl(
      maxActiveGroups: (json['maxActiveGroups'] as num).toInt(),
      activeGroupCount: (json['activeGroupCount'] as num).toInt(),
    );

Map<String, dynamic> _$$LedgerLimitResponseImplToJson(
        _$LedgerLimitResponseImpl instance) =>
    <String, dynamic>{
      'maxActiveGroups': instance.maxActiveGroups,
      'activeGroupCount': instance.activeGroupCount,
    };
