import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/application/auth_controller.dart';
import '../network/api_exception.dart';

/// Guards a protected-resource fetch against a real race: a provider can
/// be invalidated and immediately rebuilt WHILE a screen watching it is
/// still technically mounted — e.g. the instant `logout()` clears tokens
/// and invalidates session providers, before the router has actually
/// navigated the current screen away. Without this guard, that rebuild
/// fires a real network call with no valid token, 401s, triggers the
/// interceptor's refresh-then-forceLogout path, which invalidates the
/// SAME providers again — a self-sustaining loop (see BUILD_PHASES.md
/// Bug 2 for the full trace).
///
/// `ref.watch`, not `ref.read` — the calling provider also needs to
/// naturally rebuild (and retry for real) once status flips back to
/// authenticated on a future login, not just check once on the way out.
Future<T> requireAuthenticated<T>(Ref ref, Future<T> Function() fetch) {
  final status = ref.watch(authControllerProvider.select((s) => s.status));
  if (status != AuthStatus.authenticated) {
    return Future.error(
      ApiException(statusCode: 401, message: 'Not authenticated'),
    );
  }
  return fetch();
}
