import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The fixed set of preset avatars — matches backend `AvatarId` exactly
/// (AVATAR_1..AVATAR_8). What each preset actually looks like is purely
/// a client-side decision: a brand-colored circle with a distinct icon,
/// deliberately built from colors/icons already in this app rather than
/// new image assets, so it stays visually consistent with everything
/// else without adding a single asset file.
class AvatarPreset {
  const AvatarPreset(this.id, this.color, this.icon);

  final String id;
  final Color color;
  final IconData icon;
}

/// Cycles through the brand palette (primary, primaryDark, gold) rather
/// than inventing new colors — see AjopayColors' own "do not introduce a
/// new color" rule in app_theme.dart.
const List<AvatarPreset> avatarPresets = [
  AvatarPreset('AVATAR_1', AjopayColors.primary, Icons.savings_outlined),
  AvatarPreset('AVATAR_2', AjopayColors.primaryDark, Icons.eco_outlined),
  AvatarPreset('AVATAR_3', AjopayColors.gold, Icons.star_outline),
  AvatarPreset('AVATAR_4', AjopayColors.primary, Icons.diamond_outlined),
  AvatarPreset('AVATAR_5', AjopayColors.primaryDark, Icons.bolt_outlined),
  AvatarPreset('AVATAR_6', AjopayColors.gold, Icons.favorite_outline),
  AvatarPreset('AVATAR_7', AjopayColors.primary, Icons.water_drop_outlined),
  AvatarPreset('AVATAR_8', AjopayColors.primaryDark, Icons.wb_sunny_outlined),
];

AvatarPreset _presetFor(String avatarId) {
  return avatarPresets.firstWhere(
    (p) => p.id == avatarId,
    // Defensive fallback — a server-added preset the client doesn't
    // know about yet (or bad/legacy data) still renders something
    // sensible rather than throwing.
    orElse: () => avatarPresets.first,
  );
}

/// Drop-in replacement for an initials CircleAvatar anywhere a user's
/// chosen preset should show. Falls back to initials if `avatarId` is
/// null (e.g. a DTO that doesn't carry one — other users' summaries
/// elsewhere in the app, if that's ever wired up later).
class AvatarCircle extends StatelessWidget {
  const AvatarCircle({
    super.key,
    required this.avatarId,
    this.fullNameForFallback,
    this.radius = 24,
  });

  final String? avatarId;
  final String? fullNameForFallback;
  final double radius;

  String get _initials {
    final name = fullNameForFallback?.trim() ?? '';
    if (name.isEmpty) return '?';
    final parts = name.split(RegExp(r'\s+'));
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    if (avatarId == null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: AjopayColors.primaryTint,
        child: Text(
          _initials,
          style: TextStyle(
            color: AjopayColors.primaryDark,
            fontWeight: FontWeight.w700,
            fontSize: radius * 0.7,
          ),
        ),
      );
    }

    final preset = _presetFor(avatarId!);
    return CircleAvatar(
      radius: radius,
      backgroundColor: preset.color,
      child: Icon(preset.icon, color: Colors.white, size: radius),
    );
  }
}

/// Opens a grid picker of every preset, highlighting `currentAvatarId`.
/// Returns the tapped preset's id, or null if dismissed without a
/// selection. The caller decides what to do with the result (this
/// widget has no knowledge of AccountController).
Future<String?> showAvatarPickerSheet(
  BuildContext context, {
  required String currentAvatarId,
}) {
  return showModalBottomSheet<String>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => _AvatarPickerSheet(currentAvatarId: currentAvatarId),
  );
}

class _AvatarPickerSheet extends StatelessWidget {
  const _AvatarPickerSheet({required this.currentAvatarId});

  final String currentAvatarId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose an avatar',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'You can change this anytime.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: avatarPresets.map((preset) {
                  final isSelected = preset.id == currentAvatarId;
                  return SizedBox(
                    width: 64,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () => Navigator.of(context).pop(preset.id),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? AjopayColors.primary
                                    : Colors.transparent,
                                width: 2.5,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 26,
                              backgroundColor: preset.color,
                              child: Icon(preset.icon,
                                  color: Colors.white, size: 26),
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Always reserved, whether selected or not —
                          // keeps every cell the same height so the Wrap
                          // never re-flows/jumps as a selection changes.
                          SizedBox(
                            height: 16,
                            child: isSelected
                                ? Icon(Icons.check_circle,
                                    size: 16, color: AjopayColors.primary)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
