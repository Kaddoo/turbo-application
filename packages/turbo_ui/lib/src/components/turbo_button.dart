import 'package:flutter/material.dart';

import '../l10n/turbo_ui_localizations.dart';
import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';

/// Primary is the lime fill and there is one per screen. Light is the near-white fill for a second strong action on a dark photo or map.
/// Destructive is a soft red fill, SOS the emergency red, outline and text are for quiet actions.
enum TurboButtonVariant { primary, secondary, light, destructive, outline, text, sos }

/// Every button is a 60 pt pill. The driver's main actions are [driver] buttons: 80 pt and larger type.
class TurboButton extends StatelessWidget {
  const TurboButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = TurboButtonVariant.primary,
    this.loading = false,
    this.large = false,
    this.driver = false,
    this.icon,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final TurboButtonVariant variant;
  final bool loading;

  /// Kept for older screens: every button is already the full 60 pt size.
  final bool large;

  /// The 80 pt driver action with 22 pt type.
  final bool driver;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    final c = t.colors;
    final isText = variant == TurboButtonVariant.text;
    final height = driver
        ? TurboSizes.driverButtonHeight
        : isText
            ? TurboSizes.textButtonHeight
            : TurboSizes.buttonHeight;
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(t.radiusFull));
    final size = Size(expand ? double.infinity : 0, height);

    final (Color fill, Color fore, BorderSide side) = switch (variant) {
      TurboButtonVariant.primary => (c.accent, c.onAccent, BorderSide(color: c.accentBorder, width: TurboSizes.accentBorderWidth)),
      TurboButtonVariant.secondary => (c.surfaceRaised, c.textPrimary, BorderSide.none),
      TurboButtonVariant.light => (c.textPrimary, c.background, BorderSide.none),
      TurboButtonVariant.destructive => (c.dangerTint, c.danger, BorderSide.none),
      TurboButtonVariant.outline => (c.background.withValues(alpha: 0), c.textPrimary, BorderSide(color: c.controlBorder)),
      TurboButtonVariant.text => (c.background.withValues(alpha: 0), c.textPrimary, BorderSide.none),
      TurboButtonVariant.sos => (c.sos, c.onSos, BorderSide.none),
    };
    final disabledFill = switch (variant) {
      TurboButtonVariant.primary => c.accent.withValues(alpha: 0.4),
      TurboButtonVariant.outline || TurboButtonVariant.text => fill,
      _ => c.surface,
    };

    final textStyle = driver ? t.styles.driverButton : Theme.of(context).textTheme.labelLarge;
    final style = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(size),
      padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: TurboSpacing.xl, vertical: TurboSpacing.md)),
      shape: WidgetStatePropertyAll(shape),
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.disabled) ? disabledFill : fill),
      foregroundColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.disabled) ? (variant == TurboButtonVariant.primary ? c.onAccent.withValues(alpha: 0.6) : c.textSecondary) : fore,
      ),
      side: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.disabled) && variant != TurboButtonVariant.primary ? BorderSide(color: c.border) : side,
      ),
      overlayColor: WidgetStatePropertyAll(fore.withValues(alpha: 0.12)),
      textStyle: WidgetStatePropertyAll(textStyle),
    );

    final Widget content = loading
        ? ExcludeSemantics(child: SizedBox.square(dimension: TurboSizes.iconSm, child: CircularProgressIndicator(strokeWidth: 2, color: fore)))
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, size: TurboSizes.iconSm), const SizedBox(width: TurboSpacing.sm)],
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
        child: loading ? Semantics(label: label, child: content) : content,
      ),
    );
  }
}
