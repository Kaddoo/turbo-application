import 'package:flutter/material.dart';

import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';

enum StatusTone { neutral, success, warning, danger }

/// Status is always an icon plus a word, never colour alone.
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
    final color = switch (tone) {
      StatusTone.neutral => c.textSecondary,
      StatusTone.success => c.success,
      StatusTone.warning => c.warning,
      StatusTone.danger => c.danger,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: TurboSpacing.md, vertical: TurboSpacing.xs),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(t.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: TurboSizes.iconSm, color: color),
          const SizedBox(width: TurboSpacing.xs),
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
