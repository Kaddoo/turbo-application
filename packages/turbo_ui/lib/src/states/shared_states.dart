import 'package:flutter/material.dart';

import '../components/turbo_button.dart';
import '../components/turbo_art.dart';
import '../components/turbo_skeleton.dart';
import '../l10n/turbo_ui_localizations.dart';
import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';

/// Skeleton rows shown while a list or page loads. Announced once as loading.
class LoadingState extends StatelessWidget {
  const LoadingState({super.key, this.rows = 4});

  final int rows;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: TurboUiLocalizations.of(context).loading,
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.all(TurboSpacing.lg),
        child: Column(
          children: [
            for (var i = 0; i < rows; i++) ...[
              const TurboSkeleton(height: TurboSpacing.xxl),
              const SizedBox(height: TurboSpacing.md),
              const TurboSkeleton(width: 160),
              const SizedBox(height: TurboSpacing.xl),
            ],
          ],
        ),
      ),
    );
  }
}

/// Teaches what goes here and offers one action. Give it a 3D [art] picture
/// from the kit, or an [icon] where the kit has none.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.icon,
    this.art,
    required this.message,
    this.actionLabel,
    this.onAction,
  }) : assert(icon != null || art != null, 'give an icon or an art');

  final IconData? icon;
  final TurboArt? art;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TurboSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (art != null)
              TurboArtImage(art!, size: TurboSizes.heroIcon)
            else
              Icon(icon, size: TurboSizes.iconLg, color: t.colors.textSecondary),
            const SizedBox(height: TurboSpacing.lg),
            Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: TurboSpacing.xl),
              TurboButton(label: actionLabel!, onPressed: onAction, expand: false),
            ],
          ],
        ),
      ),
    );
  }
}

/// Says what happened in plain words and how to retry.
class ErrorState extends StatelessWidget {
  const ErrorState({super.key, this.message, this.onRetry, this.retryLabel});

  final String? message;
  final VoidCallback? onRetry;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    final l10n = TurboUiLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TurboSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: TurboSizes.iconLg, color: t.colors.danger),
            const SizedBox(height: TurboSpacing.lg),
            Semantics(
              liveRegion: true,
              child: Text(
                message ?? l10n.errorDefault,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: TurboSpacing.xl),
              TurboButton(
                label: retryLabel ?? l10n.tryAgain,
                onPressed: onRetry,
                expand: false,
                variant: TurboButtonVariant.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
