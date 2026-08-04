// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpgradeResponseImpl _$$UpgradeResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$UpgradeResponseImpl(
      checkoutUrl: json['checkoutUrl'] as String,
      reference: json['reference'] as String,
    );

Map<String, dynamic> _$$UpgradeResponseImplToJson(
        _$UpgradeResponseImpl instance) =>
    <String, dynamic>{
      'checkoutUrl': instance.checkoutUrl,
      'reference': instance.reference,
    };

_$SubscriptionStatusResponseImpl _$$SubscriptionStatusResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$SubscriptionStatusResponseImpl(
      isPremium: json['isPremium'] as bool,
      status: json['status'] as String?,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$$SubscriptionStatusResponseImplToJson(
        _$SubscriptionStatusResponseImpl instance) =>
    <String, dynamic>{
      'isPremium': instance.isPremium,
      'status': instance.status,
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };
