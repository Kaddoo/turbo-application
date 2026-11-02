import 'package:flutter/material.dart';

import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';

enum BentoTone { surface, lime, light }

/// One tile of the home and profile "bento" grid: a small label, a headline, and an optional picture or icon in the corner.
/// An empty [label] leaves the small line out. The lime tile is for the one number that matters (the wallet).
class BentoTile extends StatelessWidget {
  const BentoTile({super.key, required this.label, required this.title, this.trailing, this.tone = BentoTone.surface, this.onTap, this.semanticLabel, this.footer, this.money = false, this.tag, this.stretch = false});

  final String label;
  final String title;

  /// A 3D icon, picture or any small widget in the bottom corner.
  final Widget? trailing;
  final BentoTone tone;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final Widget? footer;

  /// A status chip for the bottom left, on the same line as [trailing] (which then sits at the right).
  final Widget? tag;

  /// Set when the tile sits in a row of equal height (an IntrinsicHeight row): the chip and picture then go to the bottom, so pictures line up across the row.
  final bool stretch;

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
            child: Builder(
              builder: (context) {
                final Widget? bottom = tag != null
                    ? SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.end,
                          runSpacing: TurboSpacing.sm,
                          children: [tag!, ?trailing],
                        ),
                      )
                    : trailing == null
                    ? null
                    : SizedBox(width: double.infinity, child: Align(alignment: AlignmentDirectional.centerEnd, child: trailing!));
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: stretch ? MainAxisSize.max : MainAxisSize.min,
                  children: [
                    if (label.isNotEmpty) ...[
                      Text(label, style: t.styles.tag.copyWith(color: sub)),
                      const SizedBox(height: TurboSpacing.xs),
                    ],
                    if (money)
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(title, maxLines: 1, style: t.styles.monoMoneyLarge.copyWith(color: fore)),
                      )
                    else
                      Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: fore)),
                    if (bottom != null) ...[
                      const SizedBox(height: TurboSpacing.sm),
                      if (stretch) const Spacer(),
                      bottom,
                    ],
                    if (footer != null) ...[const SizedBox(height: TurboSpacing.sm), footer!],
                  ],
                );
              },
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
