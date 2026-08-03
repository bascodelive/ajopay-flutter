import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Wraps a screen's body content in the same soft brand-tinted gradient
/// used on the Auth screens (Surface alt → Surface), instead of the flat
/// `scaffoldBackgroundColor` every non-auth screen was rendering directly
/// against. Purely decorative — wrap whatever the screen's `body:` was
/// already building, nothing else changes.
///
/// Usage:
/// ```dart
/// return Scaffold(
///   appBar: AppBar(title: const Text('...')),
///   body: AppBackdrop(child: yourExistingBodyWidget),
/// );
/// ```
///
/// For screens using `extendBodyBehindAppBar: true` with their own colored
/// header widget (e.g. ProfileScreen), wrap only the portion of the body
/// *below* that header, not the header itself — the header already
/// supplies its own background.
class AppBackdrop extends StatelessWidget {
  const AppBackdrop({
    super.key,
    required this.child,
    this.stops = const [0.0, 0.3],
  });

  final Widget child;

  /// Gradient stops — the default fades out by 30% of the way down the
  /// screen. Screens with a tall scroll (e.g. long lists) may want a
  /// shorter fade so the gradient doesn't just look like a solid color;
  /// screens with little content may want it longer.
  final List<double> stops;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [AjopayColors.surfaceAlt, AjopayColors.surface],
          stops: stops,
        ),
      ),
      child: child,
    );
  }
}
