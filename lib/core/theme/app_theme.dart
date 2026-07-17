import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Single source of truth for Ajopay's brand palette.
///
/// Values copied verbatim from BRAND.md — **do not** introduce a new color
/// anywhere in the app without updating BRAND.md first, per that file's own
/// "Changing this palette" rule. If these two ever disagree, BRAND.md wins
/// and this file is stale.
abstract final class AjopayColors {
  static const Color primary = Color(0xFF0F8A5F);
  static const Color primaryDark = Color(0xFF0B6B48);
  static const Color primaryTint = Color(0xFFDCF2E7);
  static const Color gold = Color(0xFFD99A2B);
  static const Color error = Color(0xFFD64545);

  // Supporting neutrals (BRAND.md — not brand colors, used alongside them)
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color surface = Color(0xFFF4F5F7);
}

/// Ajopay's ThemeData, built once and reused everywhere — no screen should
/// ever reach for a raw Color(0x...) for anything brand-related.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    // BRAND.md is explicit that Gold is a custom accent, NOT Flutter's
    // default Material `secondary` — it would fight with this palette if
    // left to Material 3's tonal defaults. So we build the ColorScheme from
    // a seed for structural correctness, then override the specific slots
    // BRAND.md actually names.
    final base = ColorScheme.fromSeed(
      seedColor: AjopayColors.primary,
      brightness: Brightness.light,
    );

    final colorScheme = base.copyWith(
      primary: AjopayColors.primary,
      onPrimary: Colors.white,
      // Primary Dark -> pressed/active states, dark headers (BRAND.md)
      primaryContainer: AjopayColors.primaryDark,
      onPrimaryContainer: Colors.white,
      // Secondary (Gold) -> payout-day moments, Premium badge, highlights
      secondary: AjopayColors.gold,
      onSecondary: AjopayColors.textPrimary,
      error: AjopayColors.error,
      onError: Colors.white,
      surface: AjopayColors.surface,
      onSurface: AjopayColors.textPrimary,
    );

    // Deliberate two-font pairing, not one face doing every job (which is
    // exactly what reads as "generic default"): Sora carries headlines and
    // titles — geometric, more character, used with restraint — Inter
    // stays for body copy and labels, where dense legibility matters more
    // than personality. Sizes are also bumped ~1-2sp above Material 3's
    // stock scale throughout, with tighter letter-spacing on headlines —
    // the stock scale reads as noticeably small/timid for a financial app
    // that wants to feel confident, not just correct.
    final displayFace = GoogleFonts.sora(fontWeight: FontWeight.w700);
    final bodyFace = GoogleFonts.inter();

    final textTheme = TextTheme(
      displayLarge:
          displayFace.copyWith(fontSize: 40, letterSpacing: -0.6, height: 1.15),
      displayMedium:
          displayFace.copyWith(fontSize: 34, letterSpacing: -0.5, height: 1.18),
      displaySmall:
          displayFace.copyWith(fontSize: 30, letterSpacing: -0.4, height: 1.2),
      headlineLarge:
          displayFace.copyWith(fontSize: 30, letterSpacing: -0.4, height: 1.2),
      headlineMedium:
          displayFace.copyWith(fontSize: 27, letterSpacing: -0.3, height: 1.22),
      headlineSmall:
          displayFace.copyWith(fontSize: 24, letterSpacing: -0.2, height: 1.25),
      titleLarge: displayFace.copyWith(
          fontSize: 21, fontWeight: FontWeight.w600, height: 1.3),
      titleMedium: displayFace.copyWith(
          fontSize: 17, fontWeight: FontWeight.w600, height: 1.35),
      titleSmall: displayFace.copyWith(
          fontSize: 15, fontWeight: FontWeight.w600, height: 1.4),
      bodyLarge: bodyFace.copyWith(fontSize: 17, height: 1.5),
      bodyMedium: bodyFace.copyWith(fontSize: 15.5, height: 1.5),
      bodySmall: bodyFace.copyWith(fontSize: 13, height: 1.45),
      labelLarge: bodyFace.copyWith(fontSize: 15, fontWeight: FontWeight.w600),
      labelMedium: bodyFace.copyWith(fontSize: 13, fontWeight: FontWeight.w600),
      labelSmall:
          bodyFace.copyWith(fontSize: 12.5, fontWeight: FontWeight.w600),
    ).apply(
      bodyColor: AjopayColors.textPrimary,
      displayColor: AjopayColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AjopayColors.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AjopayColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AjopayColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AjopayColors.primary.withValues(alpha: 0.4),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle:
              textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ).copyWith(
          // Primary Dark -> pressed/active state (BRAND.md)
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return AjopayColors.primaryDark;
            }
            if (states.contains(WidgetState.disabled)) {
              return AjopayColors.primary.withValues(alpha: 0.4);
            }
            return AjopayColors.primary;
          }),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
        ),
      ),
      chipTheme: ChipThemeData(
        // Primary Tint -> badges, chips, subtle highlights (BRAND.md)
        backgroundColor: AjopayColors.primaryTint,
        labelStyle:
            textTheme.labelMedium?.copyWith(color: AjopayColors.primaryDark),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AjopayColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AjopayColors.error),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AjopayColors.textPrimary,
        contentTextStyle: TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Ajopay is a single-palette brand today (BRAND.md defines no dark-mode
  // variant) — a `dark` getter is deliberately not built ahead of that need,
  // same "don't build for a need you don't have yet" instinct the backend
  // blueprint applies to itself.
}
