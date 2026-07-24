import 'package:connectivity_plus/connectivity_plus.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_provider.g.dart';

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
@Riverpod(keepAlive: true)
class ConnectivityStatus extends _$ConnectivityStatus {
  @override
  Stream<bool> build() async* {
    final connectivity = Connectivity();
    // Seed with the CURRENT state immediately — without this, the UI
    // sits in an indeterminate/loading state until the next actual
    // connectivity CHANGE fires, which might not happen for a while
    // after app start even if the device is already offline.
    yield _isConnected(await connectivity.checkConnectivity());
    yield* connectivity.onConnectivityChanged.map(_isConnected);
  }

  static bool _isConnected(List<ConnectivityResult> results) {
    return results.any((r) => r != ConnectivityResult.none);
  }
}
