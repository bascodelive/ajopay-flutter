// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contribution_action_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$contributionActionControllerHash() =>
    r'fb926b735c28486cf6400fc852d91c4951c4fbf6';

/// Every Contribution mutation — schedule/report/miss/confirm/reject/reopen.
///
/// `keepAlive: true` from the start — Bug 5 (BUILD_PHASES.md) happened
/// specifically because a mutation controller wasn't kept alive, so its
/// `_lastError` field could vanish between the write and a later separate
/// read. Applying that lesson here immediately rather than discovering
/// the same bug a second time in a new domain.
///
/// Copied from [ContributionActionController].
@ProviderFor(ContributionActionController)
final contributionActionControllerProvider =
    NotifierProvider<ContributionActionController, void>.internal(
  ContributionActionController.new,
  name: r'contributionActionControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$contributionActionControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ContributionActionController = Notifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
