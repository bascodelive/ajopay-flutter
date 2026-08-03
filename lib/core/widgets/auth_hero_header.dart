import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'brand_underline.dart';

/// The gradient hero zone at the top of every auth screen — logo mark,
/// headline, and an optional subtitle, sitting above a soft brand-tinted
/// gradient with two faint blurred rings.
///
/// The ring motif is a deliberate nod to Ajopay's actual subject matter —
/// people pooling money in rotating savings *circles* — rather than a
/// generic decorative blob, so it stays quiet (low opacity, no motion)
/// instead of competing with the form below it.
///
/// Purely presentational — no controller/provider access. Screens supply
/// their own title/subtitle copy and drop their form in a card underneath.
class AuthHeroHeader extends StatelessWidget {
  const AuthHeroHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;

  /// Optional widget shown above the title (e.g. a back button row) —
  /// kept optional so screens that don't need it stay simple.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(36),
        bottomRight: Radius.circular(36),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AjopayColors.primaryDark, AjopayColors.primary],
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Decorative "savings circle" rings — quiet, low-opacity, fixed.
            Positioned(
              right: -30,
              top: -20,
              child: _ring(diameter: 120, color: Colors.white, opacity: 0.08),
            ),
            Positioned(
              right: 40,
              bottom: -36,
              child:
                  _ring(diameter: 70, color: AjopayColors.gold, opacity: 0.20),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (trailing != null) trailing!,
                if (trailing != null) const SizedBox(height: 8),
                _LogoMark(),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                // NOTE: called with no args, matching how the original
                // screens used it — I don't have brand_underline.dart's
                // source, so I'm not assuming it accepts a `color` param.
                // If it does support one, passing AjopayColors.gold here
                // would read nicely against the dark gradient.
                const BrandUnderline(),
                if (subtitle != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.82),
                        ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _ring(
      {required double diameter,
      required Color color,
      required double opacity}) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: opacity), width: 14),
      ),
    );
  }
}

/// The real Ajopay wordmark, shown directly on the gradient.
///
/// `assets/brand/mark.png` was regenerated 2026-07-31 from a proper vector
/// trace of the original logo (`assets/brand/ajp_wordmark.svg` — see that
/// file for the source), so it's now a true transparent PNG. The original
/// upload had a solid green background baked in with no alpha channel,
/// which is why the previous version of this widget wrapped it in a white
/// circle — that workaround is gone now that transparency is real.
///
/// Sized by height with `fit: BoxFit.contain` rather than forced into a
/// circle/square: this is a wordmark (~3:2 aspect), not an icon mark, so
/// it reads better as a small horizontal lockup than squeezed into a coin.
/// Kept deliberately small — 24px tall is shorter than the headline text
/// below it, so it reads as a quiet signature mark, not a second title.
class _LogoMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      constraints: const BoxConstraints(maxWidth: 90),
      child: const Image(
        image: AssetImage('assets/brand/mark.png'),
        fit: BoxFit.contain,
        alignment: Alignment.centerLeft,
      ),
    );
  }
}
