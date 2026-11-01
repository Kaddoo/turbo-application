import 'package:flutter/material.dart';

import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';

/// One row in a list. At least 44 pt tall so it is always a safe target.
class TurboListRow extends StatelessWidget {
  const TurboListRow({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.card = false,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  /// Draws the row as a bordered list card (place lists), not a plain line.
  final bool card;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final row = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: TurboSizes.primaryAction),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TurboSpacing.md),
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: TurboSpacing.lg)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: text.bodyLarge),
                  if (subtitle != null) Text(subtitle!, style: text.bodySmall),
                ],
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: TurboSpacing.md), trailing!],
          ],
        ),
      ),
    );
    if (card) {
      final t = context.turbo;
      final radius = BorderRadius.circular(t.radiusListCard);
      return Semantics(
        button: onTap != null,
        container: true,
        child: Padding(
          padding: const EdgeInsets.only(bottom: TurboSpacing.sm),
          child: Material(
            color: t.colors.surface,
            shape: RoundedRectangleBorder(borderRadius: radius, side: BorderSide(color: t.colors.border)),
            child: InkWell(
              borderRadius: radius,
              onTap: onTap,
              child: Padding(padding: const EdgeInsets.symmetric(horizontal: TurboSpacing.lg), child: row),
            ),
          ),
        ),
      );
    }
    return Semantics(
      button: onTap != null,
      container: true,
      child: onTap == null ? row : InkWell(onTap: onTap, child: row),
    );
  }
}
