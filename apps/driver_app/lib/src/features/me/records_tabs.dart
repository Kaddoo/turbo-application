import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../l10n/app_localizations.dart';

/// The four record views as one segmented control: Trips, Shifts, Hours, Salary.
class RecordsTabs extends StatelessWidget {
  const RecordsTabs({super.key, required this.index});

  final int index;

  static const paths = ['/trips', '/trips/shifts', '/trips/hours', '/trips/salary'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = [l10n.recordsTabTrips, l10n.recordsTabShifts, l10n.recordsTabHours, l10n.recordsTabSalary];
    return Padding(
      padding: const EdgeInsets.fromLTRB(TurboSpacing.screen, TurboSpacing.sm, TurboSpacing.screen, TurboSpacing.sm),
      child: TurboSegmented(
        labels: labels,
        selectedIndex: index,
        onSelected: (i) {
          if (i != index) context.go(paths[i]);
        },
      ),
    );
  }
}
