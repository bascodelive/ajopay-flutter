import 'package:flutter/material.dart';

import 'app_theme.dart';

/// Centralized feedback styling — every screen should call one of these
/// instead of building a raw SnackBar directly, so error/success/info
/// states are visually distinct and consistent app-wide instead of every
/// message defaulting to the same flat black bar regardless of meaning.
abstract final class AppFeedback {
  static void showError(BuildContext context, String message,
      {SnackBarAction? action}) {
    _showVia(
      ScaffoldMessenger.of(context),
      message: message,
      background: AjopayColors.error,
      icon: Icons.error_outline,
      action: action,
    );
  }

  static void showSuccess(BuildContext context, String message,
      {Duration? duration}) {
    _showVia(
      ScaffoldMessenger.of(context),
      message: message,
      background: AjopayColors.primary,
      icon: Icons.check_circle_outline,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  static void showInfo(BuildContext context, String message,
      {Duration? duration}) {
    _showVia(
      ScaffoldMessenger.of(context),
      message: message,
      background: AjopayColors.textPrimary,
      icon: Icons.info_outline,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  /// Same styling, but for the specific case where a `ScaffoldMessengerState`
  /// was already captured BEFORE an async gap — e.g. before popping a sheet
  /// or dialog whose own context won't be mounted anymore by the time a
  /// network call resolves. Capturing the messenger ahead of time (rather
  /// than calling `ScaffoldMessenger.of(context)` after the pop) is the
  /// correct fix for that race — see BUILD_PHASES.md Bug 3b.
  static void showErrorVia(ScaffoldMessengerState messenger, String message) {
    _showVia(messenger,
        message: message,
        background: AjopayColors.error,
        icon: Icons.error_outline);
  }

  static void _showVia(
    ScaffoldMessengerState messenger, {
    required String message,
    required Color background,
    required IconData icon,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: duration,
          behavior: SnackBarBehavior.floating,
          backgroundColor: background,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          action: action,
          content: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child:
                    Text(message, style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
  }
}
