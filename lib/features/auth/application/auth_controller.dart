import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/storage/secure_token_storage.dart';
import '../data/auth_repository.dart';
import '../data/models/auth_models.dart';

part 'auth_controller.g.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  const AuthState({required this.status, this.errorMessage, this.infoMessage});

  final AuthStatus status;
  final String? errorMessage;
  final String? infoMessage;

  static const initial = AuthState(status: AuthStatus.unknown);
}

/// Drives two things at once:
///  - screens call login/register/verifyEmail/logout on this
///  - app_router's redirect (blueprint Section 5.3) watches `status` to
///    decide whether the caller belongs on an auth screen or past it
///  - AuthInterceptor's onSessionExpired callback calls forceLogout() when
///    a refresh attempt fails (Section 5.2, step 5b), which the router
///    redirect then acts on the same way a manual logout would
@riverpod
class AuthController extends _$AuthController {
  @override
  AuthState build() {
    _checkExistingSession();
    return AuthState.initial;
  }

  Future<void> _checkExistingSession() async {
    final storage = ref.read(secureTokenStorageProvider);
    final hasTokens = await storage.hasTokens();
    state = AuthState(
      status: hasTokens ? AuthStatus.authenticated : AuthStatus.unauthenticated,
    );
  }

  Future<bool> login({required String email, required String password}) async {
    final repository = ref.read(authRepositoryProvider);
    final storage = ref.read(secureTokenStorageProvider);
    try {
      final session = await repository
          .login(LoginRequest(email: email, password: password));
      await storage.saveTokens(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );
      state = const AuthState(status: AuthStatus.authenticated);
      return true;
    } on ApiException catch (e) {
      state = AuthState(
          status: AuthStatus.unauthenticated, errorMessage: e.message);
      return false;
    }
  }

  /// Registration never returns a usable session (API.md) — success just
  /// means "go verify your email next," so this doesn't touch auth status.
  Future<RegisterResponse?> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    final repository = ref.read(authRepositoryProvider);
    try {
      return await repository.register(
        RegisterRequest(
            email: email, password: password, fullName: fullName, phone: phone),
      );
    } on ApiException catch (e) {
      state = AuthState(status: state.status, errorMessage: e.message);
      return null;
    }
  }

  Future<bool> verifyEmail(
      {required String email, required String code}) async {
    final repository = ref.read(authRepositoryProvider);
    try {
      await repository
          .verifyEmail(EmailVerifyRequest(email: email, code: code));
      return true;
    } on ApiException catch (e) {
      state = AuthState(status: state.status, errorMessage: e.message);
      return false;
    }
  }

  Future<void> resendVerification(String email) async {
    final repository = ref.read(authRepositoryProvider);
    try {
      await repository.resendVerification(email);
      // API.md: always 200 regardless of outcome (prevents email
      // enumeration) — surface a neutral confirmation, not a specific
      // success/failure distinction the backend itself doesn't reveal.
      state = AuthState(
        status: state.status,
        errorMessage: null,
        infoMessage: 'If that email needs a new code, one has been sent.',
      );
    } on ApiException catch (e) {
      state = AuthState(status: state.status, errorMessage: e.message);
    }
  }

  Future<void> logout() async {
    final repository = ref.read(authRepositoryProvider);
    final storage = ref.read(secureTokenStorageProvider);
    final refreshToken = await storage.getRefreshToken();
    if (refreshToken != null) {
      try {
        await repository.logout(refreshToken);
      } catch (_) {
        // /api/auth/logout is idempotent server-side (API.md) — clear
        // local state regardless of whether the network call succeeded.
      }
    }
    await storage.clear();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void forceLogout() {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}
