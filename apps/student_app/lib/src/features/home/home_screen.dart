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

            // Where the student stands, in the words of the nearest official point.
            final here = loc?.point;
            final nearest = here == null
                ? null
                : nearestPickupPoint(points, here.lat.toDouble(), here.lng.toDouble());

            Widget header() {
              final name = (me?.fullName ?? '').trim();
              return Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.homeYourPickup, style: text.bodySmall?.copyWith(color: t.colors.textSecondary)),
                        Semantics(
                          header: true,
                          child: Row(
                            children: [
                              Icon(Icons.place, size: TurboSizes.iconSm, color: t.colors.accentText),
                              const SizedBox(width: TurboSpacing.xs),
                              Expanded(
                                child: Text(
                                  nearest?.name ?? l10n.homeChoosePickup,
                                  style: text.titleMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: TurboSpacing.sm),
                  TurboIconButton(icon: Icons.shield_outlined, label: l10n.safetyTitle, onPressed: () => context.push('/safety')),
                  const SizedBox(width: TurboSpacing.sm),
                  TurboAvatar(name: name.isEmpty ? l10n.homeHelloNoName : name),
                ],
              );
            }

            Widget savedChips() => saved.maybeWhen(
                  data: (places) => places.isEmpty
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(top: TurboSpacing.xl),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Semantics(header: true, child: Text(l10n.homeSavedPlaces, style: text.titleSmall)),
                              const SizedBox(height: TurboSpacing.md),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (final p in places)
                                      Padding(
                                        padding: const EdgeInsets.only(right: TurboSpacing.sm),
                                        child: TurboChip(
                                          label: p.label,
                                          leading: const Icon(Icons.bookmark_border, size: TurboSizes.iconSm),
                                          onTap: gate.bookingsPaused || active != null
                                              ? null
                                              : () {
                                                  ref.read(tripDraftProvider.notifier).setDropoff(p.location);
                                                  _start(context, points, loc);
                                                },
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

            Widget walletChip() => wallet.when(
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
                  loading: () => const TurboSkeleton(width: 120, height: TurboSpacing.xl),
                  error: (_, _) => const SizedBox.shrink(),
                );

            return ListView(
              padding: const EdgeInsets.fromLTRB(TurboSpacing.screen, TurboSpacing.md, TurboSpacing.screen, TurboSpacing.xxl),
              children: [
                header(),
                if (data.stale)
                  Padding(
                    padding: const EdgeInsets.only(top: TurboSpacing.lg),
                    child: TurboBanner(icon: Icons.cloud_off_outlined, message: l10n.homeOfflineMap, tone: StatusTone.warning),
                  ),
                savedChips(),
                const SizedBox(height: TurboSpacing.xl),
                Semantics(header: true, child: Text(l10n.homeBookRide, style: text.titleSmall)),
                const SizedBox(height: TurboSpacing.md),
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
                    child: TurboBanner(
                      icon: Icons.pause_circle_outline,
                      message: gate.pauseMessage ?? l10n.homeBookingsPaused,
                      tone: StatusTone.warning,
                      liveRegion: true,
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(TurboSpacing.lg),
                  decoration: BoxDecoration(
                    color: t.colors.surface,
                    border: Border.all(color: t.colors.border),
                    borderRadius: BorderRadius.circular(t.radiusPanel),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Stop(icon: Icons.trip_origin, label: l10n.destPickupLabel, value: nearest?.name ?? l10n.homeChoosePickup),
                      const SizedBox(height: TurboSpacing.md),
                      walletChip(),
                      const SizedBox(height: TurboSpacing.md),
                      TurboButton(
                        label: l10n.homeWhereTo,
                        icon: Icons.search,
                        onPressed: gate.bookingsPaused || active != null ? null : () => _start(context, points, loc),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TurboSpacing.lg),
                ClipRRect(
                  borderRadius: BorderRadius.circular(t.radiusCard),
                  child: SizedBox(
                    height: 240,
                    child: HomeMap(
                      height: 240,
                      spec: MapSpec(center: loc?.point, pickupPoints: points, showMyLocation: granted),
                    ),
                  ),
                ),
                const SizedBox(height: TurboSpacing.lg),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: wallet.maybeWhen(
                        data: (w) => BentoTile(
                          label: l10n.navWallet,
                          title: formatPesewas(w.availablePesewas),
                          money: true,
                          tone: BentoTone.lime,
                          trailing: const TurboArtImage(TurboArt.moneyBag),
                          onTap: () => context.go('/wallet'),
                        ),
                        orElse: () => const SizedBox.shrink(),
                      ),
                    ),
                    const SizedBox(width: TurboSpacing.md),
                    Expanded(
                      child: BentoTile(
                        label: l10n.homeSafetyLabel,
                        title: l10n.homeSafetyTile,
                        trailing: const TurboArtImage(TurboArt.shield),
                        onTap: () => context.push('/safety'),
                      ),
                    ),
                  ],
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

/// One stop on the booking panel: a small label over the place name.
class _Stop extends StatelessWidget {
  const _Stop({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    return Row(
      children: [
        ExcludeSemantics(child: Icon(icon, color: t.colors.accentText)),
        const SizedBox(width: TurboSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: text.bodySmall?.copyWith(color: t.colors.textSecondary)),
              Text(value, style: text.titleSmall),
            ],
          ),
        ),
      ],
    );
  }
}
