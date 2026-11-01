import 'package:flutter/material.dart';

import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';

enum TurboIconTone { surface, lime, light, sos }

/// A round 54 pt button with one icon: back, search, call, SOS. Always give it a spoken [label].
class TurboIconButton extends StatelessWidget {
  const TurboIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.tone = TurboIconTone.surface,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final TurboIconTone tone;

  @override
  Widget build(BuildContext context) {
    final c = context.turbo.colors;
    final (Color fill, Color fore, Color edge) = switch (tone) {
      TurboIconTone.surface => (c.surface, c.textPrimary, c.border),
      TurboIconTone.lime => (c.accent, c.onAccent, c.accentBorder),
      TurboIconTone.light => (c.textPrimary, c.background, c.textPrimary),
      TurboIconTone.sos => (c.sos, c.onSos, c.sos),
    };
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: label,
      excludeSemantics: true,
      onTap: onPressed,
      child: Material(
        color: fill,
        shape: CircleBorder(side: BorderSide(color: edge)),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox.square(dimension: TurboSizes.iconButton, child: Icon(icon, size: TurboSizes.iconMd, color: fore)),
        ),
      ),
    );
  }
}
