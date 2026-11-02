import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import 'records_tabs.dart';

final tripsProvider = FutureProvider.autoDispose<List<DriverRide>>((ref) async {
  try {
    return (await ref.read(clientProvider).api.getDriverApi().listDriverRides()).data!.data.toList();
  } catch (e) {
    throw problemOf(e);
  }
});

(String, IconData, StatusTone) rideStatusChip(AppLocalizations l10n, RideStatus s) => switch (s) {
      RideStatus.searching => (l10n.rideStatusSearching, Icons.search, StatusTone.neutral),
      RideStatus.assigned => (l10n.rideStatusAssigned, Icons.directions_car_outlined, StatusTone.neutral),
      RideStatus.driverArrived => (l10n.rideStatusArrived, Icons.place_outlined, StatusTone.success),
      RideStatus.inProgress => (l10n.rideStatusInProgress, Icons.route, StatusTone.neutral),
      RideStatus.completed => (l10n.rideStatusCompleted, Icons.check_circle_outline, StatusTone.success),
      RideStatus.cancelled => (l10n.rideStatusCancelled, Icons.cancel_outlined, StatusTone.warning),
    };

class TripsScreen extends ConsumerWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final trips = ref.watch(tripsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.recordsTitle)),
      body: SafeArea(
        child: Column(
          children: [
            const RecordsTabs(index: 0),
            Expanded(
              child: trips.when(
          loading: () => const LoadingState(),
          error: (_, _) => ErrorState(message: l10n.tripsLoadFailed, onRetry: () => ref.invalidate(tripsProvider)),
          data: (list) => list.isEmpty
              ? EmptyState(art: TurboArt.oncomingTaxi, message: l10n.tripsEmpty)
              : RefreshIndicator(
                  onRefresh: () async => ref.invalidate(tripsProvider),
                  child: ListView(
                    padding: const EdgeInsets.all(TurboSpacing.lg),
                    children: [
                      for (final (i, r) in list.indexed)
                        TurboStagger(
                          index: i,
                          child: Padding(
                          padding: const EdgeInsets.only(bottom: TurboSpacing.md),
                          child: TurboCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${r.pickup.label ?? ''} → ${r.dropoff.label ?? ''}', style: text.labelLarge),
                                const SizedBox(height: TurboSpacing.xs),
                                Text(DateFormat('d MMM, HH:mm').format(r.assignedAt.toUtc()), style: text.bodySmall),
                                const SizedBox(height: TurboSpacing.sm),
                                Builder(builder: (_) {
                                  final (label, icon, tone) = rideStatusChip(l10n, r.status);
                                  return StatusChip(label: label, icon: icon, tone: tone);
                                }),
                              ],
                            ),
                          ),
                        ),
                        ),
                    ],
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
