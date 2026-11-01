import 'package:flutter/material.dart';

import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';

enum BentoTone { surface, lime, light }

/// One tile of the home and profile "bento" grid: a small label, a headline, and an optional picture or icon in the corner.
/// The lime tile is for the one number that matters (the wallet).
class BentoTile extends StatelessWidget {
  const BentoTile({super.key, required this.label, required this.title, this.trailing, this.tone = BentoTone.surface, this.onTap, this.semanticLabel, this.footer, this.money = false});

  final String label;
  final String title;

  /// A 3D icon, picture or any small widget in the bottom corner.
  final Widget? trailing;
  final BentoTone tone;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final Widget? footer;

  /// Set for an amount: it is drawn in the mono font.
  final bool money;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    final c = t.colors;
    final (Color fill, Color fore, Color sub) = switch (tone) {
      BentoTone.surface => (c.surface, c.textPrimary, c.textSecondary),
      BentoTone.lime => (c.accent, c.onAccent, c.onAccent),
      BentoTone.light => (c.textPrimary, c.background, c.background),
    };
    final radius = BorderRadius.circular(t.radiusTile);
    return Semantics(
      container: true,
      button: onTap != null,
      label: semanticLabel ?? '$label, $title',
      excludeSemantics: true,
      onTap: onTap,
      child: Material(
        color: fill,
        shape: RoundedRectangleBorder(borderRadius: radius, side: tone == BentoTone.surface ? BorderSide(color: c.border) : BorderSide.none),
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(TurboSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: t.styles.tag.copyWith(color: sub)),
                const SizedBox(height: TurboSpacing.xs),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: Text(title, style: (money ? t.styles.monoMoneyLarge : Theme.of(context).textTheme.titleLarge)!.copyWith(color: fore))),
                    if (trailing != null) ...[const SizedBox(width: TurboSpacing.sm), trailing!],
                  ],
                ),
                if (footer != null) ...[const SizedBox(height: TurboSpacing.sm), footer!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A raised panel inside a card or sheet: the start PIN, a landmark, a plate.
class InnerPanel extends StatelessWidget {
  const InnerPanel({super.key, required this.child, this.padding = const EdgeInsets.all(TurboSpacing.lg)});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    return Container(
      padding: padding,
      decoration: BoxDecoration(color: t.colors.surfaceRaised, borderRadius: BorderRadius.circular(t.radiusInner)),
      child: child,
    );
  }
}
