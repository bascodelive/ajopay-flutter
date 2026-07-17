import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The recurring gold "payout day" / "Premium" treatment BRAND.md calls out
/// by name (Secondary/Gold — "Payout-day moments, celebration, Premium
/// badge, highlights"). Genuinely reused across 3+ features (subscriptions,
/// ledgers, contributions), so it lives here rather than inside one feature
/// folder — per the blueprint's own "not a dumping ground" rule for this
/// directory.
class PremiumBadge extends StatelessWidget {
  const PremiumBadge({super.key, this.label = 'PREMIUM'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AjopayColors.gold,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AjopayColors.textPrimary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
      ),
    );
  }
}
