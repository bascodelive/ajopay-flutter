import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/session/session_reset.dart';
import '../../../core/storage/secure_token_storage.dart';
import '../data/auth_repository.dart';
import '../data/models/auth_models.dart';

part 'auth_controller.freezed.dart';
part 'auth_controller.g.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

/// Freezed, like every other model in this codebase — was previously
/// hand-written with no `==`/`hashCode` override, meaning every
/// reassignment (even to identical values) was treated as "changed" by
/// Riverpod, causing redundant notifications to anything listening (the
/// router's redirect logic, chiefly). Fixed for consistency and
/// correctness, not just style.
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    required AuthStatus status,
    String? errorMessage,
    String? infoMessage,
  }) = _AuthState;

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
    // Bug fix: token clearing alone left every OTHER feature's cached
    // fetch results (ledgers, profile, roles) sitting in memory — the
    // next user to log in on the same app session would see the
    // previous user's data until explicitly invalidated. See
    // core/session/session_reset.dart.
    resetAllSessionProviders(ref);
  }

  /// API.md: revokes EVERY active refresh token for the caller — every
  /// device/session signed out at once, not just this one. Requires a
  /// valid access token server-side (unlike single-device logout, which
  /// is public since the refresh token itself proves identity there).
  ///
  /// Was fully built at the repository layer from Phase 1a but never
  /// wrapped up here or exposed in any screen — a real gap, not a design
  /// choice. Fixed alongside the observation that flagged it.
  Future<bool> logoutAll() async {
    final repository = ref.read(authRepositoryProvider);
    final storage = ref.read(secureTokenStorageProvider);
    try {
      await repository.logoutAll();
    } on ApiException catch (e) {
      state = AuthState(status: state.status, errorMessage: e.message);
      return false;
    }
    await storage.clear();
    state = const AuthState(status: AuthStatus.unauthenticated);
    resetAllSessionProviders(ref);
    return true;
  }

  void forceLogout() {
    state = const AuthState(status: AuthStatus.unauthenticated);
    resetAllSessionProviders(ref);
  }
}
