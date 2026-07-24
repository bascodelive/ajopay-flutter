import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/connectivity_provider.dart';
import '../theme/app_theme.dart';

/// Wraps the app's routed content, showing a persistent banner whenever
/// the device has no connectivity — app-wide, not per-screen, so it's
/// never something an individual screen has to remember to add. See
/// core/network/connectivity_provider.dart for the scope boundary this
/// closes (visibility only, not offline-first read/write support).
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Default to `true` (connected) while the initial check is still
    // resolving — never show a false-positive "offline" flash on a
    // perfectly normal app start.
    final isConnected =
        ref.watch(connectivityStatusProvider).valueOrNull ?? true;

    return Column(
      children: [
        if (!isConnected)
          Material(
            color: AjopayColors.error,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'No internet connection',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Expanded(child: child),
      ],
    );
  }
}
