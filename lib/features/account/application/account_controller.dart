import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/session/require_authenticated.dart';
import '../../auth/application/auth_controller.dart';
import '../data/account_repository.dart';
import '../data/models/account_models.dart';

part 'account_controller.g.dart';

@Riverpod(keepAlive: true) // bug fix — see BUILD_PHASES.md Bug 5
class AccountController extends _$AccountController {
  String? _lastError;
  String? get lastError => _lastError;

  @override
  Future<ProfileResponse> build() {
    // Bug fix (BUILD_PHASES.md Bug 2): without this guard, invalidating
    // this provider while ProfileScreen is still mid-teardown (the exact
    // moment logout() runs) caused an immediate rebuild that fired a real
    // getProfile() call with already-cleared tokens — 401, which
    // triggered a refresh-then-forceLogout loop that invalidated this
    // same provider again. The guard means a rebuild while unauthenticated
    // never makes the network call at all.
    return requireAuthenticated(
        ref, () => ref.read(accountRepositoryProvider).getProfile());
  }

  Future<bool> updateProfile({required String fullName, String? phone}) async {
    final repository = ref.read(accountRepositoryProvider);
    try {
      final updated = await repository.updateProfile(
        UpdateProfileRequest(fullName: fullName, phone: phone),
      );
      state = AsyncData(updated);
      return true;
    } on ApiException catch (e) {
      // Deliberately don't touch `state` on failure — the last good profile
      // stays on screen instead of blanking out on a validation error.
      _lastError = e.message;
      return false;
    }
  }

  /// API.md: success revokes EVERY refresh token for this user — including
  /// the one this very session is using. There is no valid session left
  /// afterward, so this forces a local logout regardless of how clean the
  /// 200 response looked; the backend has already ended the session for us.
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final repository = ref.read(accountRepositoryProvider);
    try {
      await repository.changePassword(
        ChangePasswordRequest(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      );
      ref.read(authControllerProvider.notifier).forceLogout();
      return true;
    } on ApiException catch (e) {
      _lastError = e.message;
      return false;
    }
  }

  /// API.md: always returns 200 regardless of whether the email exists —
  /// deliberate, prevents email enumeration. Nothing meaningful to surface
  /// as an error either way; callers should show a neutral confirmation.
  Future<void> forgotPassword(String email) async {
    final repository = ref.read(accountRepositoryProvider);
    try {
      await repository.forgotPassword(email);
    } on ApiException catch (_) {
      // Same reasoning — no distinguishable failure to show the caller.
    }
  }

  Future<bool> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    final repository = ref.read(accountRepositoryProvider);
    try {
      await repository.resetPassword(
        ResetPasswordRequest(
            email: email, code: code, newPassword: newPassword),
      );
      return true;
    } on ApiException catch (e) {
      _lastError = e.message;
      return false;
    }
  }
}
