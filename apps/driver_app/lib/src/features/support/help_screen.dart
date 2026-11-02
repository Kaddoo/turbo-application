import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../l10n/app_localizations.dart';
import '../safety/sos.dart';

/// Help tab: the SOS block first, then what to report. Calling a supervisor or
/// campus security joins this screen when their numbers reach the contract.
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final topics = [
      (TurboArt.wrench, l10n.catVehicle),
      (TurboArt.bustsInSilhouette, l10n.catStudent),
      (TurboArt.mobilePhone, l10n.catApp),
      (TurboArt.shield, l10n.catSafety),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.helpTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(TurboSpacing.lg),
          children: [
            const HoldToSos(tall: true),
            const SizedBox(height: TurboSpacing.xl),
            Semantics(header: true, child: Text(l10n.helpReportTitle, style: text.titleLarge)),
            const SizedBox(height: TurboSpacing.sm),
            for (var row = 0; row < topics.length; row += 2)
              Padding(
                padding: const EdgeInsets.only(bottom: TurboSpacing.md),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final (i, (art, label)) in topics.skip(row).take(2).indexed) ...[
                        if (i > 0) const SizedBox(width: TurboSpacing.md),
                        Expanded(
                          child: BentoTile(
                            stretch: true,
                            label: '',
                            title: label,
                            trailing: TurboArtImage(art),
                            onTap: () => context.push('/support/new'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            const SizedBox(height: TurboSpacing.md),
            TextButton(
              style: TextButton.styleFrom(minimumSize: const Size(TurboSizes.minTap, TurboSizes.minTap)),
              onPressed: () => context.push('/support'),
              child: Text(l10n.helpMyRequests),
            ),
          ],
        ),
      ),
    );
  }
}
