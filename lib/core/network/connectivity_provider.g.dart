// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$connectivityStatusHash() =>
    r'096d990be6d76a5388b3b2a7c037880e7f4301eb';

/// Closes the gap blueprint Section 8 explicitly left open: "Nothing in
/// this document yet addresses what happens when a request fails due to
/// no connectivity vs. a real backend error — worth its own design pass
/// once real screens exist to reason about concretely." That design pass,
/// scoped deliberately:
///
/// This provides APP-WIDE VISIBILITY that the device is offline (a
/// persistent banner — see core/widgets/offline_banner.dart), so a
/// person isn't left wondering why things are failing. It does NOT
/// attempt a full offline-first architecture — no local caching of
/// server data, no write-queueing/sync-on-reconnect for actions taken
/// while offline. Nothing in this app currently needs that, and building
/// it speculatively would be exactly the kind of premature complexity
/// this codebase deliberately avoids elsewhere (blueprint's own repeated
/// "don't build for a need you don't have yet" instinct). If offline
/// writes become a real product requirement later, that's a genuine
/// follow-up design pass, not something to guess at now.
///
/// ApiException already distinguishes "no connection" from a real
/// backend error at the point of failure (core/network/api_exception.dart)
/// — this provider is the complementary PROACTIVE half: knowing before
/// an action is even attempted, not just explaining after it fails.
///
/// Copied from [ConnectivityStatus].
@ProviderFor(ConnectivityStatus)
final connectivityStatusProvider =
    StreamNotifierProvider<ConnectivityStatus, bool>.internal(
  ConnectivityStatus.new,
  name: r'connectivityStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$connectivityStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ConnectivityStatus = StreamNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
