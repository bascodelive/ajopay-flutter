// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authControllerHash() => r'dcd78d57f79da2555cd9617cfa43970603d06401';

/// Drives two things at once:
///  - screens call login/register/verifyEmail/logout on this
///  - app_router's redirect (blueprint Section 5.3) watches `status` to
///    decide whether the caller belongs on an auth screen or past it
///  - AuthInterceptor's onSessionExpired callback calls forceLogout() when
///    a refresh attempt fails (Section 5.2, step 5b), which the router
///    redirect then acts on the same way a manual logout would
///
/// Copied from [AuthController].
@ProviderFor(AuthController)
final authControllerProvider =
    AutoDisposeNotifierProvider<AuthController, AuthState>.internal(
  AuthController.new,
  name: r'authControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthController = AutoDisposeNotifier<AuthState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
