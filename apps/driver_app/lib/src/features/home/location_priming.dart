import 'package:flutter/material.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../l10n/app_localizations.dart';

/// Explains "Always" location in three steps before the system prompt or
/// Settings opens, so the driver knows which choice to make. Completes with
/// true when the driver chooses to continue.
Future<bool> showLocationPriming(BuildContext context, {required bool viaSettings}) async {
  final l10n = AppLocalizations.of(context);
  final steps = viaSettings
      ? [l10n.primingSettingsStep1, l10n.primingSettingsStep2, l10n.primingSettingsStep3]
      : [l10n.primingAskStep1, l10n.primingAskStep2, l10n.primingAskStep3];
  final go = await showTurboSheet<bool>(
    context: context,
    builder: (sheet) {
      final text = Theme.of(sheet).textTheme;
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(child: HeroIcon(art: TurboArt.roundPushpin)),
          const SizedBox(height: TurboSpacing.md),
          Text(l10n.primingTitle, style: text.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: TurboSpacing.sm),
          Text(l10n.primingBody, style: text.bodyLarge, textAlign: TextAlign.center),
          const SizedBox(height: TurboSpacing.lg),
          for (var i = 0; i < steps.length; i++) ...[
            _Step(number: i + 1, label: steps[i]),
            const SizedBox(height: TurboSpacing.sm),
          ],
          const SizedBox(height: TurboSpacing.md),
          TurboButton(
            label: viaSettings ? l10n.readinessOpenSettings : l10n.primingContinue,
            driver: true,
            onPressed: () => Navigator.of(sheet).pop(true),
          ),
          const SizedBox(height: TurboSpacing.sm),
          TurboButton(
            label: l10n.primingNotNow,
            variant: TurboButtonVariant.secondary,
            onPressed: () => Navigator.of(sheet).pop(false),
          ),
        ],
      );
    },
  );
  return go ?? false;
}

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.label});

  final int number;
  final String label;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    return Semantics(
      label: '$number. $label',
      excludeSemantics: true,
      child: Row(
        children: [
          Container(
            width: TurboSizes.minTap,
            height: TurboSizes.minTap,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: t.colors.surfaceRaised, shape: BoxShape.circle),
            child: Text('$number', style: text.titleMedium?.copyWith(color: t.colors.accentText)),
          ),
          const SizedBox(width: TurboSpacing.md),
          Expanded(child: Text(label, style: text.bodyLarge)),
        ],
      ),
    );
  }
}
