import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The primary call-to-action button for auth screens (Log in, Create
/// account, Verify, Reset password) — a pill-shaped gradient button with a
/// soft brand-colored shadow, replacing the flat `ElevatedButton` look.
///
/// Scoped to auth rather than changing the app-wide `ElevatedButtonTheme`,
/// so Ledgers/Circles/Contributions screens keep their existing button
/// styling untouched.
///
/// Purely presentational — pass the same `onPressed` (or `null` while
/// submitting/invalid) and `isLoading` flag you already compute today.
class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: isDisabled ? 0.55 : 1,
      child: SizedBox(
        height: 56,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(28),
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AjopayColors.primary, AjopayColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: isDisabled
                    ? const []
                    : [
                        BoxShadow(
                          color: AjopayColors.primary.withValues(alpha: 0.32),
                          blurRadius: 22,
                          offset: const Offset(0, 10),
                        ),
                      ],
              ),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        label,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontSize: 16,
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
