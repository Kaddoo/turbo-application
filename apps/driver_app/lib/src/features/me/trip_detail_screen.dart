import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../l10n/app_localizations.dart';
import 'trips_screen.dart';

/// One past trip: where it went, how far, and how far along it got. The list
/// already holds the ride, so nothing is fetched here. The contract gives the
/// times a ride was assigned and accepted; later steps show a state, not a time.
class TripDetailScreen extends StatelessWidget {
  const TripDetailScreen({super.key, required this.ride});

  final DriverRide? ride;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final r = ride;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.tripDetailTitle)),
      body: SafeArea(
        child: r == null
            ? ErrorState(message: l10n.tripsLoadFailed, onRetry: () => context.pop())
            : _Detail(ride: r),
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.ride});

  final DriverRide ride;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final (statusLabel, statusIcon, statusTone) = rideStatusChip(l10n, ride.status);
    String time(DateTime d) => DateFormat('d MMM, HH:mm').format(d.toUtc());
    final km = (ride.routeDistanceMeters / 1000).toStringAsFixed(1);
    final minutes = ride.routeDurationSeconds == null ? null : (ride.routeDurationSeconds! / 60).ceil();

    final accepted = ride.acknowledgedAt != null;
    final entries = <TimelineEntry>[
      TimelineEntry(title: l10n.tripStepAssigned, status: TimelineStatus.done, detail: time(ride.assignedAt)),
      if (ride.status == RideStatus.cancelled) ...[
        if (accepted)
          TimelineEntry(title: l10n.tripStepAccepted, status: TimelineStatus.done, detail: time(ride.acknowledgedAt!)),
        TimelineEntry(title: l10n.tripStepCancelled, status: TimelineStatus.done),
      ] else ...[
        // How many steps are finished: assigned, accepted, arrived, started, completed.
        for (final (i, title) in [
          l10n.tripStepAccepted,
          l10n.tripStepArrived,
          l10n.tripStepStarted,
          l10n.tripStepCompleted,
        ].indexed)
          TimelineEntry(
            title: title,
            status: _stepStatus(i + 1, _reached(ride)),
            detail: i == 0 && accepted ? time(ride.acknowledgedAt!) : null,
          ),
      ],
    ];

    return ListView(
      padding: const EdgeInsets.all(TurboSpacing.screen),
      children: [
        Semantics(
          header: true,
          child: Text('${ride.pickup.label ?? ''} → ${ride.dropoff.label ?? ''}', style: text.headlineSmall),
        ),
        const SizedBox(height: TurboSpacing.sm),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: StatusChip(label: statusLabel, icon: statusIcon, tone: statusTone),
        ),
        const SizedBox(height: TurboSpacing.lg),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: BentoTile(
                  label: l10n.tripDetailDistance,
                  title: l10n.assignKm(km),
                  trailing: const TurboArtImage(TurboArt.motorway),
                ),
              ),
              const SizedBox(width: TurboSpacing.md),
              Expanded(
                child: BentoTile(
                  label: l10n.tripDetailTime,
                  title: minutes == null ? '–' : l10n.tripDetailMinutes(minutes),
                  trailing: const TurboArtImage(TurboArt.alarmClock),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: TurboSpacing.xl),
        Semantics(header: true, child: Text(l10n.tripDetailProgress, style: text.titleMedium)),
        const SizedBox(height: TurboSpacing.md),
        TurboTimeline(entries: entries),
        const SizedBox(height: TurboSpacing.lg),
        TurboButton(
          label: l10n.tripDetailReport,
          variant: TurboButtonVariant.secondary,
          onPressed: () => context.push('/support/new', extra: ride.id),
        ),
      ],
    );
  }

  /// Steps after "assigned" that are finished: 0 = none, 4 = all.
  static int _reached(DriverRide r) => switch (r.status) {
        RideStatus.completed => 4,
        RideStatus.inProgress => 2,
        RideStatus.driverArrived => 2,
        _ => r.acknowledgedAt != null ? 1 : 0,
      };

  static TimelineStatus _stepStatus(int step, int reached) => step <= reached
      ? TimelineStatus.done
      : step == reached + 1
          ? TimelineStatus.current
          : TimelineStatus.upcoming;
}
