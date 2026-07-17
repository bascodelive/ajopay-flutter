// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegisterRequestImpl _$$RegisterRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$RegisterRequestImpl(
      email: json['email'] as String,
      phone: json['phone'] as String,
      password: json['password'] as String,
      fullName: json['fullName'] as String,
    );

Map<String, dynamic> _$$RegisterRequestImplToJson(
        _$RegisterRequestImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'phone': instance.phone,
      'password': instance.password,
      'fullName': instance.fullName,
    };

_$RegisterResponseImpl _$$RegisterResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$RegisterResponseImpl(
      userId: json['userId'] as String,
      email: json['email'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$$RegisterResponseImplToJson(
        _$RegisterResponseImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'message': instance.message,
    };

_$LoginRequestImpl _$$LoginRequestImplFromJson(Map<String, dynamic> json) =>
    _$LoginRequestImpl(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$LoginRequestImplToJson(_$LoginRequestImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };

_$AuthSessionImpl _$$AuthSessionImplFromJson(Map<String, dynamic> json) =>
    _$AuthSessionImpl(
      userId: json['userId'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$$AuthSessionImplToJson(_$AuthSessionImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'fullName': instance.fullName,
      'email': instance.email,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };

_$RefreshRequestImpl _$$RefreshRequestImplFromJson(Map<String, dynamic> json) =>
    _$RefreshRequestImpl(
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$$RefreshRequestImplToJson(
        _$RefreshRequestImpl instance) =>
    <String, dynamic>{
      'refreshToken': instance.refreshToken,
    };

_$LogoutRequestImpl _$$LogoutRequestImplFromJson(Map<String, dynamic> json) =>
    _$LogoutRequestImpl(
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$$LogoutRequestImplToJson(_$LogoutRequestImpl instance) =>
    <String, dynamic>{
      'refreshToken': instance.refreshToken,
    };

_$EmailVerifyRequestImpl _$$EmailVerifyRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$EmailVerifyRequestImpl(
      email: json['email'] as String,
      code: json['code'] as String,
    );

Map<String, dynamic> _$$EmailVerifyRequestImplToJson(
        _$EmailVerifyRequestImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'code': instance.code,
    };

_$ResendVerificationRequestImpl _$$ResendVerificationRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ResendVerificationRequestImpl(
      email: json['email'] as String,
    );

Map<String, dynamic> _$$ResendVerificationRequestImplToJson(
        _$ResendVerificationRequestImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
    };
