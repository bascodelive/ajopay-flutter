import 'package:flutter/material.dart';

/// Single source of truth for Ajopay's brand palette.
///
/// Values copied verbatim from BRAND.md — **do not** introduce a new color
/// anywhere in the app without updating BRAND.md first, per that file's own
/// "Changing this palette" rule. If these two ever disagree, BRAND.md wins
/// and this file is stale.
///
/// --- 2026 Auth UI refresh: palette expansion ---
/// The original palette only defined brand colors + two neutrals
/// (`textPrimary`, `surface`) — enough for cards and app bars, but not
/// enough to express hierarchy inside a form-heavy screen (labels vs.
/// hints vs. helper text, resting vs. focused input borders, a semantic
/// "success" distinct from the brand green, or a soft backdrop that reads
/// as more than a flat gray). The five tokens below are additive only —
/// nothing existing was renamed or removed — and each is documented with
/// the UX reason it exists. Add these to BRAND.md when confirmed.
abstract final class AjopayColors {
  static const Color primary = Color(0xFF0F8A5F);
  static const Color primaryDark = Color(0xFF0B6B48);
  static const Color primaryTint = Color(0xFFDCF2E7);
  static const Color gold = Color(0xFFD99A2B);

  /// Same relationship to [gold] that [primaryTint] has to [primary] —
  /// added 2026-07-27 for rating/star content, so it reads as its own
  /// visual category instead of borrowing the green tint. See BRAND.md.
  static const Color goldTint = Color(0xFFF8ECD7);
  static const Color error = Color(0xFFD64545);

  // Supporting neutrals (BRAND.md — not brand colors, used alongside them)
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color surface = Color(0xFFF4F5F7);

  // --- New: text hierarchy ---
  // `textPrimary` alone forces every line of copy to compete at full
  // contrast. Forms need a visible ranking: label > helper/subtitle >
  // placeholder. Two new steps down from `textPrimary` give that ranking
  // without ever touching pure gray-on-white, which reads as "unstyled."
  /// Secondary body copy: subtitles under a headline, helper text under a
  /// field, "Don't have an account?" prompts. One step down from
  /// [textPrimary] so it's clearly supporting copy, not competing with it.
  static const Color textSecondary = Color(0xFF6B7280);

  /// Hints, placeholder text, resting (unfocused) icon tint, disabled
  /// labels. The lowest-contrast text token — deliberately quiet so a
  /// hint never gets mistaken for entered content.
  static const Color textMuted = Color(0xFF9CA3AF);

  // --- New: input & divider structure ---
  /// Resting border for inputs, dividers, and outlined chips/cards that
  /// aren't in an active/error state. The old theme only defined a
  /// focused border color — every field looked identical until tapped.
  /// This gives unfocused fields a visible (but quiet) edge, so a form
  /// reads as a set of distinct fields before the user ever interacts.
  static const Color border = Color(0xFFE4E7EC);

  // --- New: semantic feedback ---
  /// A positive/success state that is NOT [primary]. Auth screens need to
  /// confirm things ("password meets requirements", "email verified")
  /// separately from *brand* actions (buttons, links) — reusing `primary`
  /// for both would make every success checkmark look like a call to
  /// action. Kept in the same green family as the brand so it still reads
  /// as "good news," just as its own semantic token.
  static const Color success = Color(0xFF1AA262);

  // --- New: backdrop ---
  /// The soft endpoint of a brand-tinted background wash (paired with
  /// white) behind auth screens. Flat `surface` gray works for app
  /// content, but a full-bleed auth background needs a slightly warmer,
  /// on-brand backdrop for a gradient hero to sit on top of — this is
  /// that endpoint, one step softer than [primaryTint].
  static const Color surfaceAlt = Color(0xFFEFF7F2);
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
    // Was GoogleFonts.sora()/GoogleFonts.inter() — fetched over the
    // network at runtime by default, which this app's own users can't
    // be assumed to have a reliable connection for on first launch.
    // Both are now bundled locally as their real Google Fonts variable
    // TTF files (assets/fonts/, declared in pubspec.yaml) — same two
    // weights each still in use below (Sora: 700/600, Inter: 400/600),
    // resolved from the single variable file via ordinary
    // TextStyle(fontWeight:), no FontVariation/fontVariations needed.
    // Confirm on-device that both weights render distinctly once built
    // — variable font weight resolution is the one part of this that's
    // worth a visual spot-check, not just a compile check.
    const displayFace = TextStyle(
      fontFamily: 'Sora',
      fontWeight: FontWeight.w700,
    );
    const bodyFace = TextStyle(fontFamily: 'Inter');

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
      // 2026-07-30 app-wide polish pass: was flat Surface gray on every
      // screen with no exceptions — nothing to differentiate "screen
      // background" from "card background" except a hairline border, which
      // read as unfinished/boring rather than intentional. Surface alt is
      // one step warmer, on-brand, and still light enough that white cards
      // sitting on it read as clearly raised.
      scaffoldBackgroundColor: AjopayColors.surfaceAlt,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AjopayColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.16),
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          // Pill radius, matching AuthPrimaryButton/AppPrimaryButton's
          // shape language — was a fairly conservative 12px radius, which
          // read as generic/default Material rather than as this app's
          // own button. Any ElevatedButton not yet migrated to
          // AppPrimaryButton (e.g. inside AlertDialogs) still picks this
          // up automatically.
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          elevation: 0,
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
        // Was elevation 0 + a 6%-black hairline border — flat, no depth,
        // reads as a wireframe rather than a finished surface. Real
        // elevation (soft shadow, no border) is what actually makes a
        // white card read as "raised off the page" against Surface alt.
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: 0.10),
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
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
