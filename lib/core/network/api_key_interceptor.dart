import 'package:dio/dio.dart';

/// Stamps every outgoing request with X-API-Key.
///
/// Per blueprint Section 4: this is client attribution (which known app is
/// calling), NOT a per-user credential — that's the JWT's job (see
/// auth_interceptor.dart, added in Phase 1). Applied once, globally, on the
/// shared Dio instance — no screen or repository method ever attaches this
/// header manually, mirroring the backend's own single-cross-cutting-concern
/// ApiKeyFilter.
class ApiKeyInterceptor extends Interceptor {
  ApiKeyInterceptor(this.apiKey);

  final String apiKey;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['X-API-Key'] = apiKey;
    handler.next(options);
  }
}
