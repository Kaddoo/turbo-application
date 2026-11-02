import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({super.key});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

enum _Filter { all, completed, cancelled }

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
  _Filter _filter = _Filter.all;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final rides = ref.watch(myRidesProvider);
    final text = Theme.of(context).textTheme;
    final t = context.turbo;

    bool shown(Ride r) => switch (_filter) {
          _Filter.all => true,
          _Filter.completed => r.status == RideStatus.completed,
          _Filter.cancelled => r.status == RideStatus.cancelled,
        };

    // Rides from the last seven days first, then the rest, newest first.
    List<(String, List<Ride>)> groups(List<Ride> all) {
      final cut = clock.now().toUtc().subtract(const Duration(days: 7));
      final recent = all.where((r) => r.requestedAt.isAfter(cut)).toList();
      final older = all.where((r) => !r.requestedAt.isAfter(cut)).toList();
      return [
        if (recent.isNotEmpty) (l10n.activityThisWeek, recent),
        if (older.isNotEmpty) (l10n.activityEarlier, older),
      ];
    }

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
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(TurboSpacing.screen, TurboSpacing.lg, TurboSpacing.screen, TurboSpacing.md),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Semantics(header: true, child: Text(l10n.activityTitle, style: text.headlineMedium)),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: TurboSpacing.screen),
              child: Row(
                children: [
                  for (final (f, label) in [
                    (_Filter.all, l10n.activityFilterAll),
                    (_Filter.completed, l10n.rideStatusCompleted),
                    (_Filter.cancelled, l10n.rideStatusCancelled),
                  ])
                    Padding(
                      padding: const EdgeInsets.only(right: TurboSpacing.sm),
                      child: TurboChip(label: label, selected: _filter == f, onTap: () => setState(() => _filter = f)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: TurboSpacing.md),
            Expanded(child: rides.when(
          loading: () => const LoadingState(),
          error: (_, _) => ErrorState(
            message: l10n.activityLoadFailed,
            onRetry: () => ref.invalidate(myRidesProvider),
          ),
          data: (items) => items.isEmpty
              ? EmptyState(
                  art: TurboArt.oncomingTaxi,
                  message: l10n.activityEmpty,
                  actionLabel: l10n.homeBookRide,
                  onAction: () => context.go('/home'),
                )
              : RefreshIndicator(
                  onRefresh: () async => ref.invalidate(myRidesProvider),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: TurboSpacing.screen),
                    children: [
                      for (final group in groups(items.where(shown).toList()))
                        ...[
                          Padding(
                            padding: const EdgeInsets.only(bottom: TurboSpacing.sm),
                            child: Semantics(
                              header: true,
                              child: Text(group.$1, style: text.bodySmall),
                            ),
                          ),
                          for (final r in group.$2)
                            Padding(
                              padding: const EdgeInsets.only(bottom: TurboSpacing.md),
                              child: TurboCard(
                                onTap: () => context.push('/ride/${r.id}'),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const TurboArtImage(TurboArt.oncomingTaxi),
                                    const SizedBox(width: TurboSpacing.md),
                                    Expanded(
                                      child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // A wrap, so at large text the status drops under the date instead of overflowing.
                                    SizedBox(
                                      width: double.infinity,
                                      child: Wrap(
                                      alignment: WrapAlignment.spaceBetween,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      spacing: TurboSpacing.sm,
                                      runSpacing: TurboSpacing.xs,
                                      children: [
                                        Text(
                                          DateFormat('d MMM, HH:mm').format(r.requestedAt.toUtc()),
                                          style: text.bodySmall,
                                        ),
                                        Builder(
                                          builder: (_) {
                                            final (label, icon, tone) = statusOf(r.status);
                                            return StatusChip(label: label, icon: icon, tone: tone);
                                          },
                                        ),
                                      ],
                                      ),
                                    ),
                                    const SizedBox(height: TurboSpacing.md),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(r.pickup.label ?? '', style: text.labelLarge),
                                              const SizedBox(height: TurboSpacing.xs),
                                              Text(r.dropoff.label ?? '', style: text.bodyMedium),
                                            ],
                                          ),
                                        ),
                                        MoneyText(r.farePesewas, style: t.styles.monoMoneyRow),
                                      ],
                                    ),
                                  ],
                                ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                    ],
                  ),
                ),
        )),
          ],
        ),
      ),
    );
  }
}
