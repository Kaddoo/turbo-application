import 'package:flutter/material.dart';

import '../l10n/turbo_ui_localizations.dart';
import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';

enum TurboButtonVariant { primary, secondary, destructive }

/// Primary, secondary and destructive buttons. One primary per screen.
/// [large] gives the 56 pt target used by glanceable screens.
class TurboButton extends StatelessWidget {
  const TurboButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = TurboButtonVariant.primary,
    this.loading = false,
    this.large = false,
    this.icon,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final TurboButtonVariant variant;
  final bool loading;
  final bool large;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    final c = t.colors;
    final height = large ? TurboSizes.primaryAction : TurboSizes.minTap;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(t.radiusFull),
    );
    final size = Size(expand ? double.infinity : 0, height);

    final (Color fill, Color fore, BorderSide side) = switch (variant) {
      TurboButtonVariant.primary => (
          c.accent,
          c.onAccent,
          BorderSide(color: c.accentBorder, width: TurboSizes.accentBorderWidth),
        ),
      TurboButtonVariant.secondary => (
          c.background,
          c.textPrimary,
          BorderSide(color: c.controlBorder, width: TurboSizes.accentBorderWidth),
        ),
      TurboButtonVariant.destructive => (
          c.danger,
          c.onDanger,
          BorderSide(color: c.danger, width: TurboSizes.accentBorderWidth),
        ),
    };

    final style = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(size),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: TurboSpacing.xl, vertical: TurboSpacing.md),
      ),
      shape: WidgetStatePropertyAll(shape),
      backgroundColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.disabled) ? c.surface : fill,
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.disabled) ? c.textSecondary : fore,
      ),
      side: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.disabled) ? BorderSide(color: c.border) : side,
      ),
      overlayColor: WidgetStatePropertyAll(fore.withValues(alpha: 0.12)),
      textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.labelLarge),
    );

    final Widget content = loading
        ? ExcludeSemantics(
            child: SizedBox.square(
              dimension: TurboSizes.iconSm,
              child: CircularProgressIndicator(strokeWidth: 2, color: fore),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: TurboSizes.iconSm),
                const SizedBox(width: TurboSpacing.sm),
              ],
              Flexible(child: Text(label, textAlign: TextAlign.center)),
            ],
          );

    // FilledButton already exposes button, enabled and tap to assistive tech.
    // While loading, the label stays and a hint says why it is inert.
    return Semantics(
      hint: loading ? TurboUiLocalizations.of(context).loading : null,
      child: FilledButton(
        style: style,
        onPressed: loading ? null : onPressed,
        child: loading
            ? Semantics(label: label, child: content)
            : content,
      ),
    );
  }
}
