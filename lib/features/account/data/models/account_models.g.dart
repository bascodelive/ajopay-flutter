// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileResponseImpl _$$ProfileResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfileResponseImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      fullName: json['fullName'] as String,
      emailVerified: json['emailVerified'] as bool,
      phoneVerified: json['phoneVerified'] as bool,
      subscriptionTier: json['subscriptionTier'] as String,
    );

Map<String, dynamic> _$$ProfileResponseImplToJson(
        _$ProfileResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'phone': instance.phone,
      'fullName': instance.fullName,
      'emailVerified': instance.emailVerified,
      'phoneVerified': instance.phoneVerified,
      'subscriptionTier': instance.subscriptionTier,
    };

_$UpdateProfileRequestImpl _$$UpdateProfileRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateProfileRequestImpl(
      fullName: json['fullName'] as String,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$$UpdateProfileRequestImplToJson(
        _$UpdateProfileRequestImpl instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'phone': instance.phone,
    };

_$ChangePasswordRequestImpl _$$ChangePasswordRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ChangePasswordRequestImpl(
      currentPassword: json['currentPassword'] as String,
      newPassword: json['newPassword'] as String,
    );

Map<String, dynamic> _$$ChangePasswordRequestImplToJson(
        _$ChangePasswordRequestImpl instance) =>
    <String, dynamic>{
      'currentPassword': instance.currentPassword,
      'newPassword': instance.newPassword,
    };

_$ForgotPasswordRequestImpl _$$ForgotPasswordRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ForgotPasswordRequestImpl(
      email: json['email'] as String,
    );

Map<String, dynamic> _$$ForgotPasswordRequestImplToJson(
        _$ForgotPasswordRequestImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
    };

_$ResetPasswordRequestImpl _$$ResetPasswordRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ResetPasswordRequestImpl(
      email: json['email'] as String,
      code: json['code'] as String,
      newPassword: json['newPassword'] as String,
    );

Map<String, dynamic> _$$ResetPasswordRequestImplToJson(
        _$ResetPasswordRequestImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'code': instance.code,
      'newPassword': instance.newPassword,
    };
