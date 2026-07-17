import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_exception.freezed.dart';
part 'api_exception.g.dart';

/// API.md Conventions: every non-2xx response has this exact shape.
@freezed
class ErrorResponse with _$ErrorResponse {
  const factory ErrorResponse({
    required String timestamp,
    required int status,
    required String error,
    required String message,
    required String path,
    required String traceId,
  }) = _ErrorResponse;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);
}

/// Every repository throws this instead of letting a raw DioException leak
/// past the data layer (blueprint Section 2 — repositories return typed
/// models/errors, never raw JSON, past their boundary).
class ApiException implements Exception {
  ApiException({
    required this.statusCode,
    required this.message,
    this.traceId,
    this.path,
  });

  final int statusCode;
  final String message;
  final String? traceId;
  final String? path;

  factory ApiException.fromDioException(DioException e) {
    final response = e.response;
    if (response != null && response.data is Map<String, dynamic>) {
      try {
        final body =
            ErrorResponse.fromJson(response.data as Map<String, dynamic>);
        return ApiException(
          statusCode: body.status,
          message: body.message,
          traceId: body.traceId,
          path: body.path,
        );
      } catch (_) {
        // Body didn't actually match ErrorResponse's shape — fall through.
      }
    }

    return ApiException(
      statusCode: response?.statusCode ?? -1,
      message: _networkMessage(e),
    );
  }

  static String _networkMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'The request timed out. Check your connection and try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return e.message ?? 'Something went wrong. Please try again.';
    }
  }

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isConflict => statusCode == 409;
  bool get isValidation => statusCode == 400;

  @override
  String toString() => 'ApiException($statusCode): $message';
}
