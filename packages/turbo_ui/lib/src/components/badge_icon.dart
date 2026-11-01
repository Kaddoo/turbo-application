import 'package:flutter/material.dart';

import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';

/// Large round icon that opens a result screen: a check, a cross, a lock. Solid
/// in the main text colour with the icon cut out of it, so it reads in both modes.
class BadgeIcon extends StatelessWidget {
  const BadgeIcon({super.key, required this.icon, this.semanticLabel});

  final IconData icon;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    return Semantics(
      label: semanticLabel,
      excludeSemantics: semanticLabel != null,
      child: Container(
        width: TurboSizes.primaryAction + TurboSpacing.xxl,
        height: TurboSizes.primaryAction + TurboSpacing.xxl,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: t.colors.textPrimary, shape: BoxShape.circle),
        child: Icon(icon, size: TurboSizes.iconLg, color: t.colors.background),
      ),
    );
  }
}
