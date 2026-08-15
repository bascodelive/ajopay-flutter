import 'package:flutter/material.dart';

/// Wraps [child], absorbing ALL touches — not just disabling the one
/// button that triggered a mutation — while [busy] is true. Stronger
/// than this codebase's older per-button disable-only pattern (see e.g.
/// CircleHomeScreen's `_isStarting`/`_isGenerating`, which only disable
/// a single button and leave the rest of the screen tappable). Used
/// wherever nothing on screen should be tappable while a request is in
/// flight, so nobody can accidentally double-tap or trigger a second
/// action mid-request.
class BusyOverlay extends StatelessWidget {
  const BusyOverlay({super.key, required this.busy, required this.child});

  final bool busy;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AbsorbPointer(absorbing: busy, child: child),
        if (busy)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.15),
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}