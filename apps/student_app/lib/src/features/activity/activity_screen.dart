import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';

final myRidesProvider = FutureProvider.autoDispose<List<Ride>>((ref) async {
  final response = await ref
      .read(clientProvider)
      .api
      .getRidesApi()
      .listMyRides();
  return response.data!.data.toList();
});

class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final rides = ref.watch(myRidesProvider);
    final text = Theme.of(context).textTheme;

    (String, IconData, StatusTone) statusOf(RideStatus s) => switch (s) {
      RideStatus.searching => (
        l10n.rideStatusSearching,
        Icons.search,
        StatusTone.neutral,
      ),
      RideStatus.assigned => (
        l10n.rideStatusAssigned,
        Icons.directions_car_outlined,
        StatusTone.neutral,
      ),
      RideStatus.driverArrived => (
        l10n.rideStatusArrived,
        Icons.place_outlined,
        StatusTone.success,
      ),
      RideStatus.inProgress => (
        l10n.rideStatusInProgress,
        Icons.route,
        StatusTone.neutral,
      ),
      RideStatus.completed => (
        l10n.rideStatusCompleted,
        Icons.check_circle_outline,
        StatusTone.success,
      ),
      RideStatus.cancelled => (
        l10n.rideStatusCancelled,
        Icons.cancel_outlined,
        StatusTone.warning,
      ),
    };

    return Scaffold(
      appBar: AppBar(title: Text(l10n.activityTitle)),
      body: SafeArea(
        child: rides.when(
          loading: () => const LoadingState(),
          error: (_, _) => ErrorState(
            message: l10n.activityLoadFailed,
            onRetry: () => ref.invalidate(myRidesProvider),
          ),
          data: (items) => items.isEmpty
              ? EmptyState(
                  icon: Icons.directions_car_outlined,
                  message: l10n.activityEmpty,
                )
              : RefreshIndicator(
                  onRefresh: () async => ref.invalidate(myRidesProvider),
                  child: ListView(
                    padding: const EdgeInsets.all(TurboSpacing.lg),
                    children: [
                      for (final r in items)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: TurboSpacing.md,
                          ),
                          child: TurboCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${r.pickup.label ?? ''} → ${r.dropoff.label ?? ''}',
                                  style: text.labelLarge,
                                ),
                                const SizedBox(height: TurboSpacing.xs),
                                Text(
                                  DateFormat('d MMM, HH:mm')
                                      .format(r.requestedAt.toUtc()),
                                  style: text.bodySmall,
                                ),
                                const SizedBox(height: TurboSpacing.md),
                                Row(
                                  children: [
                                    Builder(
                                      builder: (_) {
                                        final (label, icon, tone) = statusOf(
                                          r.status,
                                        );
                                        return StatusChip(
                                          label: label,
                                          icon: icon,
                                          tone: tone,
                                        );
                                      },
                                    ),
                                    const Spacer(),
                                    MoneyText(
                                      r.farePesewas,
                                      style: text.labelLarge,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
