import 'package:flutter/material.dart';

import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';

enum StatusTone { neutral, success, warning, danger }

/// A 26 pt status tag: soft tinted fill, an icon and a word. Status is never colour alone.
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    required this.icon,
    this.tone = StatusTone.neutral,
  });

  final String label;
  final IconData icon;
  final StatusTone tone;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    final c = t.colors;
    final (Color fore, Color fill) = switch (tone) {
      StatusTone.neutral => (c.textSecondary, c.surfaceRaised),
      StatusTone.success => (c.success, c.successTint),
      StatusTone.warning => (c.warning, c.warningTint),
      StatusTone.danger => (c.danger, c.dangerTint),
    };
    return Container(
      constraints: const BoxConstraints(minHeight: TurboSizes.tagHeight),
      padding: const EdgeInsets.symmetric(horizontal: TurboSpacing.md, vertical: TurboSpacing.xs),
      decoration: BoxDecoration(color: fill, borderRadius: BorderRadius.circular(t.radiusFull)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: TurboSizes.iconSm - TurboSpacing.xs, color: fore),
          const SizedBox(width: TurboSpacing.xs),
          Flexible(child: Text(label, style: t.styles.tag.copyWith(color: fore))),
        ],
      ),
    );
  }
}
