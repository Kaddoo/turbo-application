import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../core/gate.dart';
import '../../core/me.dart';
import '../../l10n/app_localizations.dart';
import 'geo.dart';
import 'location_service.dart';
import 'map_view.dart';
import '../ride/ride_providers.dart';
import 'service_area.dart';
import 'trip_draft.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  bool _openedActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // A fresh start for each visit; providers may not change during build.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(tripDraftProvider.notifier).clear(),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Back from Settings with permission granted: pick it up without asking again.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(userLocationProvider.notifier).refresh(ask: false);
      ref.read(serviceAreaProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    final area = ref.watch(serviceAreaProvider);
    final location = ref.watch(userLocationProvider);
    final gate = ref.watch(gateProvider).value ?? const GateState();
    final wallet = ref.watch(walletProvider);
    final me = switch (ref.watch(meProvider).value) {
      MeLoaded(:final student) => student,
      _ => null,
    };
    final saved = ref.watch(savedPlacesProvider);
    final active = ref.watch(activeRideProvider).value;
    // Opening the app with a ride running goes straight to it, once.
    ref.listen(activeRideProvider, (_, next) {
      final ride = next.value;
      if (ride != null && !_openedActive) {
        _openedActive = true;
        context.go('/ride/${ride.id}');
      }
    });

    return Scaffold(
      body: SafeArea(
        child: area.when(
          loading: () => const LoadingState(),
          error: (_, _) => ErrorState(
            message: l10n.homeLoadFailed,
            onRetry: () =>
                ref.read(serviceAreaProvider.notifier).refresh(force: true),
          ),
          data: (data) {
            final points = data.area.pickupPoints
                .where((p) => p.isActive)
                .toList();
            final loc = location.value;
            final granted = loc?.status == LocationStatus.granted;

            Widget locationNotice() {
              if (location.isLoading || granted || loc == null) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: TurboSpacing.md),
                child: TurboCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        header: true,
                        child: Text(
                          l10n.homeLocationDeniedTitle,
                          style: text.labelLarge,
                        ),
                      ),
                      const SizedBox(height: TurboSpacing.xs),
                      Text(
                        loc.status == LocationStatus.servicesOff
                            ? l10n.homeLocationServicesOff
                            : l10n.homeLocationDeniedBody(t.brand.appName),
                        style: text.bodyMedium,
                      ),
                      const SizedBox(height: TurboSpacing.md),
                      if (loc.status != LocationStatus.servicesOff)
                        TurboButton(
                          label: l10n.homeAllowLocation,
                          variant: TurboButtonVariant.secondary,
                          onPressed: () async {
                            if (loc.status == LocationStatus.deniedForever) {
                              await ref
                                  .read(locationServiceProvider)
                                  .openSettings();
                            } else {
                              await ref
                                  .read(userLocationProvider.notifier)
                                  .refresh();
                            }
                          },
                        ),
                    ],
                  ),
                ),
              );
            }

            Widget greeting() {
              final name = (me?.fullName ?? '').trim();
              final first = name.isEmpty ? null : name.split(RegExp(r'\s+')).first;
              final initial = first?.substring(0, 1).toUpperCase();
              final walletLine = wallet.when(
                data: (w) {
                  // Amber when the wallet cannot cover the cheapest fare.
                  final cheapest = data.area.fareBands.isEmpty
                      ? 0
                      : data.area.fareBands.map((b) => b.farePesewas).reduce((a, b) => a < b ? a : b);
                  final low = w.availablePesewas < cheapest;
                  final amount = formatPesewas(w.availablePesewas);
                  return InkWell(
                    onTap: () => context.go('/wallet'),
                    borderRadius: BorderRadius.circular(t.radiusFull),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: TurboSizes.minTap),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: StatusChip(
                          label: low ? l10n.homeWalletLow(amount) : l10n.homeWalletChip(amount),
                          icon: low ? Icons.warning_amber : Icons.account_balance_wallet_outlined,
                          tone: low ? StatusTone.warning : StatusTone.neutral,
                        ),
                      ),
                    ),
                  );
                },
                loading: () => const TurboSkeleton(width: 80, height: TurboSpacing.xl),
                error: (_, _) => const SizedBox.shrink(),
              );
              return Container(
                padding: const EdgeInsets.all(TurboSpacing.md),
                decoration: BoxDecoration(
                  color: t.colors.surface,
                  border: Border.all(color: t.colors.border),
                  borderRadius: BorderRadius.circular(t.radiusCard),
                ),
                child: Row(
                  children: [
                    ExcludeSemantics(
                      child: CircleAvatar(
                        radius: TurboSpacing.xl,
                        backgroundColor: t.colors.background,
                        child: initial == null
                            ? const Wordmark()
                            : Text(initial, style: text.titleLarge),
                      ),
                    ),
                    const SizedBox(width: TurboSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Semantics(
                            header: true,
                            child: Text(first == null ? l10n.homeHelloNoName : l10n.homeHello(first), style: text.labelLarge),
                          ),
                          walletLine,
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: l10n.safetyTitle,
                      constraints: const BoxConstraints(minWidth: TurboSizes.minTap, minHeight: TurboSizes.minTap),
                      icon: const Icon(Icons.shield_outlined),
                      onPressed: () => context.push('/safety'),
                    ),
                  ],
                ),
              );
            }

            Widget savedTiles() => saved.maybeWhen(
                  data: (places) => places.isEmpty
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(top: TurboSpacing.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Semantics(header: true, child: Text(l10n.homeSavedPlaces, style: text.labelMedium)),
                              const SizedBox(height: TurboSpacing.sm),
                              SizedBox(
                                height: TurboSizes.primaryAction + TurboSpacing.xxl,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    for (final p in places)
                                      Padding(
                                        padding: const EdgeInsets.only(right: TurboSpacing.sm),
                                        child: SizedBox(
                                          width: TurboSizes.primaryAction + TurboSpacing.xxl,
                                          child: TurboCard(
                                            padding: const EdgeInsets.all(TurboSpacing.sm),
                                            semanticLabel: p.label,
                                            onTap: gate.bookingsPaused
                                                ? null
                                                : () {
                                                    ref.read(tripDraftProvider.notifier).setDropoff(p.location);
                                                    _start(context, points, loc);
                                                  },
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.bookmark_border),
                                                const SizedBox(height: TurboSpacing.xs),
                                                Text(p.label, style: text.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                  orElse: () => const SizedBox.shrink(),
                );

            return Column(
              children: [
                if (data.stale)
                  Container(
                    width: double.infinity,
                    color: t.colors.surface,
                    padding: const EdgeInsets.all(TurboSpacing.md),
                    child: Row(
                      children: [
                        Icon(Icons.cloud_off_outlined, size: TurboSizes.iconSm, color: t.colors.warning),
                        const SizedBox(width: TurboSpacing.sm),
                        Expanded(child: Text(l10n.homeOfflineMap, style: text.bodySmall)),
                      ],
                    ),
                  ),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: TurboSpacing.lg),
                          child: LayoutBuilder(
                            builder: (context, c) => HomeMap(
                              height: c.maxHeight,
                              spec: MapSpec(center: loc?.point, pickupPoints: points, showMyLocation: granted),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: TurboSpacing.xl,
                        right: TurboSpacing.xl,
                        top: TurboSpacing.md,
                        child: greeting(),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(TurboSpacing.lg),
                  decoration: BoxDecoration(
                    color: t.colors.surface,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(t.radiusCard)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      locationNotice(),
                      if (active != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: TurboSpacing.md),
                          child: TurboCard(
                            onTap: () => context.go('/ride/${active.id}'),
                            semanticLabel: l10n.homeActiveOpen,
                            child: Row(
                              children: [
                                Icon(Icons.directions_car, color: t.colors.accentText),
                                const SizedBox(width: TurboSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(l10n.homeActiveRide, style: text.labelLarge),
                                      Text('${active.pickup.label ?? ''} → ${active.dropoff.label ?? ''}', style: text.bodySmall),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right),
                              ],
                            ),
                          ),
                        ),
                      if (gate.bookingsPaused)
                        Padding(
                          padding: const EdgeInsets.only(bottom: TurboSpacing.md),
                          child: Row(
                            children: [
                              Icon(Icons.pause_circle_outline, color: t.colors.warning),
                              const SizedBox(width: TurboSpacing.sm),
                              Expanded(
                                child: Semantics(
                                  liveRegion: true,
                                  child: Text(gate.pauseMessage ?? l10n.homeBookingsPaused, style: text.bodyMedium),
                                ),
                              ),
                            ],
                          ),
                        ),
                      TurboButton(
                        label: l10n.homeWhereTo,
                        large: true,
                        icon: Icons.search,
                        onPressed: gate.bookingsPaused || active != null ? null : () => _start(context, points, loc),
                      ),
                      savedTiles(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Opens the destination screen with the pickup already guessed: the nearest
  /// official pickup point to where the student stands, if known.
  void _start(
    BuildContext context,
    List<PickupPoint> points,
    UserLocation? loc,
  ) {
    final here = loc?.point;
    if (here != null && ref.read(tripDraftProvider).pickup == null) {
      final nearest = nearestPickupPoint(
        points,
        here.lat.toDouble(),
        here.lng.toDouble(),
      );
      ref
          .read(tripDraftProvider.notifier)
          .setPickup(
            nearest != null ? locationOfPickup(nearest) : Location(point: here),
          );
    }
    context.go('/home/destination');
  }
}
