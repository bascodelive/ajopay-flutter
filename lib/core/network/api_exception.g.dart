// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_exception.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ErrorResponseImpl _$$ErrorResponseImplFromJson(Map<String, dynamic> json) =>
    _$ErrorResponseImpl(
      timestamp: json['timestamp'] as String,
      status: (json['status'] as num).toInt(),
      error: json['error'] as String,
      message: json['message'] as String,
      path: json['path'] as String,
      traceId: json['traceId'] as String,
      errorCode: json['errorCode'] as String?,
    );

Map<String, dynamic> _$$ErrorResponseImplToJson(_$ErrorResponseImpl instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'status': instance.status,
      'error': instance.error,
      'message': instance.message,
      'path': instance.path,
      'traceId': instance.traceId,
      'errorCode': instance.errorCode,
    };
