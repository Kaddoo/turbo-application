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
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    final labels = [l10n.recordsTabTrips, l10n.recordsTabShifts, l10n.recordsTabHours, l10n.recordsTabSalary];
    return Padding(
      padding: const EdgeInsets.fromLTRB(TurboSpacing.lg, TurboSpacing.sm, TurboSpacing.lg, TurboSpacing.sm),
      child: Container(
        padding: const EdgeInsets.all(TurboSpacing.xs),
        decoration: BoxDecoration(
          color: t.colors.border.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(t.radiusInput),
        ),
        child: Row(
          children: [
            for (var i = 0; i < labels.length; i++)
              Expanded(
                child: Semantics(
                  button: true,
                  selected: i == index,
                  label: labels[i],
                  child: ExcludeSemantics(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(t.radiusInput),
                      onTap: i == index ? null : () => context.go(paths[i]),
                      child: Container(
                        constraints: const BoxConstraints(minHeight: TurboSizes.minTap),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: i == index ? t.colors.surface : t.colors.border.withValues(alpha: 0),
                          borderRadius: BorderRadius.circular(t.radiusInput),
                        ),
                        child: Text(
                          labels[i],
                          style: i == index ? text.labelMedium : text.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
