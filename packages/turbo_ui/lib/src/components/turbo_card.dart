import 'package:flutter/material.dart';

import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';

/// Surface with a border instead of a shadow.
class TurboCard extends StatelessWidget {
  const TurboCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(TurboSpacing.lg),
    this.semanticLabel,
    this.color,
    this.selected = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final String? semanticLabel;

  /// Fill when the card sits on a surface of its own; defaults to the surface role.
  final Color? color;

  /// A chosen option in a list: a lime outline instead of the hairline.
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    final radius = BorderRadius.circular(t.radiusCard);
    final body = Ink(
      decoration: BoxDecoration(
        color: color ?? t.colors.surface,
        border: Border.all(color: selected ? t.colors.accentText : t.colors.border, width: selected ? TurboSizes.accentBorderWidth : 1),
        borderRadius: radius,
      ),
      child: Padding(padding: padding, child: child),
    );
    return Semantics(
      container: true,
      label: semanticLabel,
      button: onTap != null,
      child: Material(
        type: MaterialType.transparency,
        child: onTap == null
            ? body
            : InkWell(
                onTap: onTap,
                borderRadius: radius,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: TurboSizes.minTap),
                  child: body,
                ),
              ),
      ),
    );
  }
}
