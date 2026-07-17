import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The app's one signature visual detail — a short gold underline echoing
/// the AJP app icon's own gold underline beneath the wordmark. Meant for
/// a handful of key screen headlines (Login, Register, empty states),
/// never as a decoration repeated everywhere — that's what would make it
/// stop reading as a signature and start reading as noise.
class BrandUnderline extends StatelessWidget {
  const BrandUnderline({super.key, this.width = 40});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 3,
      decoration: BoxDecoration(
        color: AjopayColors.gold,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
