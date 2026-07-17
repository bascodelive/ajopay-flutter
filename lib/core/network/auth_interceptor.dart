import 'package:dio/dio.dart';

import 'api_key_interceptor.dart';
import 'env.dart';
import '../storage/secure_token_storage.dart';

/// The 401 refresh-and-retry interceptor — blueprint Section 5.2, flagged
/// there as "the actual hard part."
///
/// Flow per request:
///   1. onRequest attaches the current access token.
///   2. If the backend returns 401, onError catches it before it reaches
///      the calling screen.
///   3. Calls POST /api/auth/refresh with the stored refresh token.
///   4a. Success: store the NEW pair (rotation — the old refresh token is
///       now dead server-side), retry the ORIGINAL failed request with the
///       new access token, resolve that result as if nothing happened.
///   4b. Failure: clear stored tokens, call onSessionExpired() so the
///       caller (the auth controller) can flip state and let the router's
///       redirect (Section 5.3) send the user to /login.
///
/// The subtlety this exists to solve: the backend rotates refresh tokens
/// on every use — a refresh token is effectively single-use. If two
/// requests both 401 near-simultaneously (e.g. a screen firing several
/// parallel requests on load), a naive implementation fires two refresh
/// calls; the second arrives with an already-rotated, now-dead refresh
/// token and fails, incorrectly logging the user out. Fixed with a single
/// in-flight refresh guard: a second 401 arriving while a refresh is
/// already running awaits that SAME Future instead of starting its own.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required Dio dio,
    required SecureTokenStorage tokenStorage,
    required void Function() onSessionExpired,
  })  : _dio = dio,
        _tokenStorage = tokenStorage,
        _onSessionExpired = onSessionExpired,
        // A bare Dio instance for the refresh call itself — deliberately
        // NOT the same intercepted instance. Calling refresh through `_dio`
        // would re-trigger this very interceptor on its own 401 responses.
        _refreshDio = Dio(BaseOptions(baseUrl: Env.apiBaseUrl))
          ..interceptors.add(ApiKeyInterceptor(Env.apiKey));

  final Dio _dio;
  final Dio _refreshDio;
  final SecureTokenStorage _tokenStorage;
  final void Function() _onSessionExpired;

  // The single-in-flight guard: null when no refresh is running, otherwise
  // every concurrent 401 awaits this exact Future.
  Future<_TokenPair?>? _inFlightRefresh;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await _tokenStorage.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final isAuthEndpoint = err.requestOptions.path.contains('/api/auth/');

    // Never treat a 401 FROM the auth endpoints themselves as "access token
    // expired, go refresh" — that 401 means invalid credentials or an
    // already-dead refresh token, a genuinely different case.
    if (!isUnauthorized || isAuthEndpoint) {
      handler.next(err);
      return;
    }

    try {
      final tokens = await _refreshOnce();
      if (tokens == null) {
        _onSessionExpired();
        handler.next(err);
        return;
      }

      final retryOptions = err.requestOptions;
      retryOptions.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
      final response = await _dio.fetch(retryOptions);
      handler.resolve(response);
    } catch (_) {
      _onSessionExpired();
      handler.next(err);
    }
  }

  Future<_TokenPair?> _refreshOnce() {
    return _inFlightRefresh ??= _performRefresh().whenComplete(() {
      _inFlightRefresh = null;
    });
  }

  Future<_TokenPair?> _performRefresh() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return null;

    try {
      final response = await _refreshDio.post(
        '/api/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      final data = response.data as Map<String, dynamic>;
      final newAccess = data['accessToken'] as String;
      final newRefresh = data['refreshToken'] as String;

      await _tokenStorage.saveTokens(
        accessToken: newAccess,
        refreshToken: newRefresh,
      );
      return _TokenPair(accessToken: newAccess, refreshToken: newRefresh);
    } on DioException {
      // Refresh token itself expired/revoked (blueprint Section 5.2, 5b).
      await _tokenStorage.clear();
      return null;
    }
  }
}

class _TokenPair {
  _TokenPair({required this.accessToken, required this.refreshToken});
  final String accessToken;
  final String refreshToken;
}
