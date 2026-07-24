import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/offline_banner.dart';

class AjopayApp extends ConsumerWidget {
  const AjopayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Ajopay',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
      // App-wide, not per-screen — closes the offline-visibility gap
      // flagged in blueprint Section 8. `child!` is safe here per
      // MaterialApp.router's own contract: builder is always called
      // with a non-null child once routing is set up.
      builder: (context, child) => OfflineBanner(child: child!),
    );
  }
}
