// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$subscriptionControllerHash() =>
    r'8ba0fc8deeeb6e6b6ac571b29bc0a7791d77306e';

/// Current Premium status, watched app-wide wherever a screen needs to
/// gate something on it (Messages' composer today; anything else later
/// — the ledger create/join limit is a known near-term one, not wired
/// yet). `keepAlive: true` since this genuinely is app-wide shared
/// state, not a single screen's concern — same reasoning CircleController
/// documents for its own `keepAlive`.
///
/// Async `build()` (matching ContributionsPager/MessageThreadPager's
/// shape), not CircleController's "null until an action sets it"
/// pattern — status needs a real fetch on first read, there's no
/// equivalent of "nothing to show until the user does something."
///
/// Copied from [SubscriptionController].
@ProviderFor(SubscriptionController)
final subscriptionControllerProvider = AsyncNotifierProvider<
    SubscriptionController, SubscriptionStatusResponse>.internal(
  SubscriptionController.new,
  name: r'subscriptionControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$subscriptionControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SubscriptionController = AsyncNotifier<SubscriptionStatusResponse>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
