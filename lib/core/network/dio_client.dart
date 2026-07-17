import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/application/auth_controller.dart';
import '../storage/secure_token_storage.dart';
import 'api_key_interceptor.dart';
import 'auth_interceptor.dart';
import 'env.dart';

/// The single shared Dio instance for the whole app.
///
/// Per blueprint Section 1: Dio over the bare `http` package specifically
/// for interceptor support — X-API-Key attachment (Section 4) and the
/// refresh/retry auth flow (Section 5.2) both live here as interceptors,
/// not hand-rolled per API call.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  dio.interceptors.add(ApiKeyInterceptor(Env.apiKey));

  dio.interceptors.add(
    AuthInterceptor(
      dio: dio,
      tokenStorage: ref.watch(secureTokenStorageProvider),
      // Deferred read, not called at provider-construction time — no
      // circular init issue even though AuthController's own repository
      // ultimately depends on this same dioProvider.
      onSessionExpired: () =>
          ref.read(authControllerProvider.notifier).forceLogout(),
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  return dio;
});
