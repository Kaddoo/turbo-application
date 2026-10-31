import 'package:flutter/material.dart';

import '../l10n/turbo_ui_localizations.dart';
import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';

/// Rounded frame for the map. Pass the map widget as [child]; without one it
/// shows a calm placeholder so screens still lay out when the map is off.
class TurboMapContainer extends StatelessWidget {
  const TurboMapContainer({
    super.key,
    this.child,
    this.height = 240,
    this.semanticLabel,
    this.overlay,
  });

  final Widget? child;
  final double height;
  final String? semanticLabel;

  /// Sits over the map, such as an ETA card.
  final Widget? overlay;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    return Semantics(
      container: true,
      label: semanticLabel,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(t.radiusCard),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: t.colors.surface,
            border: Border.all(color: t.colors.border),
            borderRadius: BorderRadius.circular(t.radiusCard),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              child ??
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(TurboSpacing.lg),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.map_outlined, size: TurboSizes.iconLg, color: t.colors.textSecondary),
                          const SizedBox(height: TurboSpacing.sm),
                          Text(
                            TurboUiLocalizations.of(context).mapUnavailable,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
              if (overlay != null)
                Positioned(
                  left: TurboSpacing.md,
                  right: TurboSpacing.md,
                  bottom: TurboSpacing.md,
                  child: overlay!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
