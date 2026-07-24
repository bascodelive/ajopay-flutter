// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$circleControllerHash() => r'75ba33c7d595c11ebf570ca8b5c265bbf91634af';

/// Holds the circle currently being set up/managed by an Admin — the
/// multi-step PENDING flow (create → add participants → assign rotation
/// → start) plus payout confirmation once ACTIVE. Mirrors LedgerController's
/// shape: one mutable "current" circle, separate read-only FutureProviders
/// below for lists that don't need mutation tracking.
///
/// Copied from [CircleController].
@ProviderFor(CircleController)
final circleControllerProvider =
    NotifierProvider<CircleController, CircleResponse?>.internal(
  CircleController.new,
  name: r'circleControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$circleControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CircleController = Notifier<CircleResponse?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
