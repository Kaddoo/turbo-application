import 'package:flutter/material.dart';

import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';
import 'status_chip.dart';

/// A message that stays on screen: always an icon and words, never colour alone.
/// Neutral is for plain notes, success for good news, warning for "check this", danger for "this blocks you".
class TurboBanner extends StatelessWidget {
  const TurboBanner({super.key, required this.message, required this.icon, this.title, this.tone = StatusTone.neutral, this.liveRegion = false});

  final String message;
  final String? title;
  final IconData icon;
  final StatusTone tone;

  /// Announce changes to a screen reader (errors and warnings that appear after the page loads).
  final bool liveRegion;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    final c = t.colors;
    final text = Theme.of(context).textTheme;
    final (Color fill, Color fore) = switch (tone) {
      StatusTone.neutral => (c.surface, c.textSecondary),
      StatusTone.success => (c.successTint, c.success),
      StatusTone.warning => (c.warningTint, c.warning),
      StatusTone.danger => (c.dangerTint, c.danger),
    };
    return Semantics(
      container: true,
      liveRegion: liveRegion,
      child: Container(
        padding: const EdgeInsets.all(TurboSpacing.lg),
        decoration: BoxDecoration(
          color: fill,
          border: tone == StatusTone.neutral ? Border.all(color: c.border) : null,
          borderRadius: BorderRadius.circular(t.radiusInner),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: TurboSizes.iconMd, color: fore),
            const SizedBox(width: TurboSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) Text(title!, style: text.titleSmall?.copyWith(color: tone == StatusTone.neutral ? c.textPrimary : fore)),
                  Text(message, style: text.bodyMedium?.copyWith(color: tone == StatusTone.neutral ? c.textSecondary : c.textPrimary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
