import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Read-only — an average rating + count, rendered as 5 stars with
/// half-star precision (rounded to the nearest 0.5) rather than just
/// rounding to a whole star, which would misrepresent e.g. a genuine
/// 4.3 average as an indistinguishable 4★ from a 4.7 average.
class StarRatingDisplay extends StatelessWidget {
  const StarRatingDisplay({
    super.key,
    required this.averageRating,
    required this.ratingCount,
    this.size = 16,
    this.showCount = true,
  });

  final double averageRating;
  final int ratingCount;
  final double size;
  final bool showCount;

  @override
  Widget build(BuildContext context) {
    if (ratingCount == 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_border, size: size, color: Colors.black38),
          const SizedBox(width: 4),
          Text(
            'No ratings yet',
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: Colors.black45),
          ),
        ],
      );
    }

    final rounded = (averageRating * 2).round() / 2;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          final position = index + 1;
          IconData icon;
          if (rounded >= position) {
            icon = Icons.star;
          } else if (rounded >= position - 0.5) {
            icon = Icons.star_half;
          } else {
            icon = Icons.star_border;
          }
          return Icon(icon, size: size, color: AjopayColors.gold);
        }),
        const SizedBox(width: 6),
        Text(
          averageRating.toStringAsFixed(1),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AjopayColors.textPrimary,
              ),
        ),
        if (showCount) ...[
          const SizedBox(width: 4),
          Text(
            '($ratingCount)',
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: Colors.black45),
          ),
        ],
      ],
    );
  }
}

/// Interactive — 5 tappable stars for the caller's own pick. Whole stars
/// only (no half-star input — asking someone to precisely tap "half a
/// star" is fiddly on a touchscreen and adds ambiguity most raters don't
/// actually want); `initialStars` pre-fills an existing rating.
class StarRatingInput extends StatefulWidget {
  const StarRatingInput({
    super.key,
    this.initialStars,
    required this.onChanged,
    this.size = 36,
  });

  final int? initialStars;
  final ValueChanged<int> onChanged;
  final double size;

  @override
  State<StarRatingInput> createState() => _StarRatingInputState();
}

class _StarRatingInputState extends State<StarRatingInput> {
  late int? _stars = widget.initialStars;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final position = index + 1;
        final filled = _stars != null && position <= _stars!;
        return IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          constraints: const BoxConstraints(),
          icon: Icon(
            filled ? Icons.star : Icons.star_border,
            size: widget.size,
            color: AjopayColors.gold,
          ),
          onPressed: () {
            setState(() => _stars = position);
            widget.onChanged(position);
          },
        );
      }),
    );
  }
}
