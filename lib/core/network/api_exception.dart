import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_exception.freezed.dart';
part 'api_exception.g.dart';

/// API.md Conventions: every non-2xx response has this exact shape.
/// `errorCode` is the newest field (added alongside the backend's
/// EmailNotVerifiedException → ErrorCode.EMAIL_NOT_VERIFIED work) —
/// nullable and optional in the JSON, since most errors still won't set
/// it. A client branches on THIS, never on `message` text — message is
/// free to reword at any time; errorCode is the stable contract.
@freezed
class ErrorResponse with _$ErrorResponse {
  const factory ErrorResponse({
    required String timestamp,
    required int status,
    required String error,
    required String message,
    required String path,
    required String traceId,
    String? errorCode,
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
    this.code,
  });

  final int statusCode;
  final String message;
  final String? traceId;
  final String? path;

  /// Stable, machine-readable error identifier — e.g.
  /// `ApiErrorCode.emailNotVerified`. Null for the vast majority of
  /// errors (nothing to branch on beyond showing `message`), for a
  /// backend response that predates this field, or for a connection-
  /// level failure (`_networkMessage` below never sets this — there's
  /// no ErrorResponse body to have carried a code in the first place).
  /// Compare against `ApiErrorCode`'s constants, never a hardcoded
  /// string literal at the call site.
  final String? code;

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
          code: body.errorCode,
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
      case DioExceptionType.transformTimeout:
        return 'The request timed out. Check your connection and try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      case DioExceptionType.badResponse:
        // A response DID come back — this isn't a connectivity problem —
        // but its body didn't match ErrorResponse's documented shape, so
        // fromDioException's JSON-parse branch above already gave up on
        // it. Common causes: a dead ngrok tunnel returning its own HTML
        // error page, a proxy's block page, a load balancer's error page
        // — none of them your backend's actual JSON. Whatever it is,
        // show the status code plainly rather than falling through to
        // `e.message`, which for this exception type is Dio's own
        // internal multi-paragraph developer explanation ("This
        // exception was thrown because... RequestOptions.validateStatus
        // was configured to throw...") — never meant for an end user.
        final code = e.response?.statusCode;
        return code != null
            ? 'Something went wrong (error $code). Please try again.'
            : 'Something went wrong. Please try again.';
      case DioExceptionType.cancel:
        return 'Request cancelled.';
      case DioExceptionType.badCertificate:
        return 'Could not establish a secure connection. Please try again.';
      case DioExceptionType.unknown:
        return 'Something went wrong. Please try again.';
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

/// Mirrors the backend's `ErrorCode` enum (values serialize as their
/// exact enum name — e.g. `EMAIL_NOT_VERIFIED`). Compare `ApiException.code`
/// against these constants, never against a raw string literal at the
/// call site — same reasoning as not hardcoding a magic number for an
/// HTTP status. Kept as plain string constants rather than a Dart enum:
/// no `fromJson`/serialization machinery needed since `ApiException.code`
/// is already a plain `String?` coming straight off the wire, and a new
/// backend code needs zero regeneration step here — just add the constant.
///
/// Seeded with only what the backend actually sends today. Add a new
/// constant here the same day (same PR, ideally) a new backend
/// `ErrorCode` value ships — keeping these two catalogs in lockstep is
/// what makes this whole mechanism trustworthy. A constant listed here
/// that the backend doesn't actually send yet is worse than not having
/// it: it'll compile, look correct, and silently never match.
abstract final class ApiErrorCode {
  static const emailNotVerified = 'EMAIL_NOT_VERIFIED';
}
