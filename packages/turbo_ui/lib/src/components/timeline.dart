import 'package:flutter/material.dart';

import '../l10n/turbo_ui_localizations.dart';
import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';

enum TimelineStatus { done, current, upcoming }

class TimelineEntry {
  const TimelineEntry({
    required this.title,
    required this.status,
    this.detail,
  });

  final String title;
  final TimelineStatus status;

  /// Usually a time, already formatted for Africa/Accra.
  final String? detail;
}

/// Vertical list of steps. State is an icon and a spoken word, not colour.
class TurboTimeline extends StatelessWidget {
  const TurboTimeline({super.key, required this.entries});

  final List<TimelineEntry> entries;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    final l10n = TurboUiLocalizations.of(context);
    final text = Theme.of(context).textTheme;

    return Column(
      children: [
        for (var i = 0; i < entries.length; i++)
          Semantics(
            container: true,
            label: [
              entries[i].title,
              switch (entries[i].status) {
                TimelineStatus.done => l10n.timelineDone,
                TimelineStatus.current => l10n.timelineCurrent,
                TimelineStatus.upcoming => l10n.timelineUpcoming,
              },
              if (entries[i].detail != null) entries[i].detail!,
            ].join(', '),
            excludeSemantics: true,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: TurboSizes.iconMd,
                    child: Column(
                      children: [
                        Icon(
                          switch (entries[i].status) {
                            TimelineStatus.done => Icons.check_circle,
                            TimelineStatus.current => Icons.radio_button_checked,
                            TimelineStatus.upcoming => Icons.radio_button_unchecked,
                          },
                          size: TurboSizes.iconMd,
                          color: entries[i].status == TimelineStatus.upcoming
                              ? t.colors.textSecondary
                              : t.colors.accentText,
                        ),
                        if (i < entries.length - 1)
                          Expanded(child: VerticalDivider(width: 1, color: t.colors.controlBorder)),
                      ],
                    ),
                  ),
                  const SizedBox(width: TurboSpacing.md),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: TurboSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entries[i].title, style: text.bodyLarge),
                          if (entries[i].detail != null)
                            Text(entries[i].detail!, style: text.bodySmall),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
