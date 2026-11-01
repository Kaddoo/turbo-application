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
      (Icons.directions_car_outlined, l10n.catVehicle),
      (Icons.person_outline, l10n.catStudent),
      (Icons.smartphone, l10n.catApp),
      (Icons.shield_outlined, l10n.catSafety),
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
            for (final (icon, label) in topics)
              TurboListRow(
                title: label,
                leading: Icon(icon),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/support/new'),
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
