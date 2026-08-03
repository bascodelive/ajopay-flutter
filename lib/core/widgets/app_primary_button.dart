import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The primary call-to-action button for non-auth screens (Create ledger,
/// Save changes, Join, Approve, etc.) — a pill-shaped gradient button with
/// a soft brand-colored shadow, replacing the flat default `ElevatedButton`
/// look those screens were using.
///
/// Visually identical to `AuthPrimaryButton` (core/widgets already has
/// that one for the Auth flow) — kept as a separate widget rather than
/// reused directly so the already-shipped Login/Register/Verify screens
/// aren't touched by changes made here, and so this one's default height
/// can flex for tighter contexts (e.g. inline in a bottom sheet) without
/// affecting Auth.
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.height = 52,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: isDisabled ? 0.55 : 1,
      child: SizedBox(
        height: height,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(height / 2),
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AjopayColors.primary, AjopayColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(height / 2),
                boxShadow: isDisabled
                    ? const []
                    : [
                        BoxShadow(
                          color: AjopayColors.primary.withValues(alpha: 0.30),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
              ),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        label,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontSize: 15.5,
                              letterSpacing: 0.2,
                            ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
