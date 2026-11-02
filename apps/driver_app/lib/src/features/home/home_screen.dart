import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../core/driver_feedback.dart';
import '../../core/driver_gaps.dart';
import '../../core/profile.dart';
import '../../core/problem_messages.dart';
import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../location/location_access.dart';
import '../duty/connectivity.dart';
import '../duty/location_sharing.dart';
import '../duty/readiness.dart';
import '../map/map_view.dart';
import '../me/documents_screen.dart';
import '../me/record_screens.dart';
import '../support/call_supervisor_button.dart';
import 'location_priming.dart';
import 'readiness_board.dart';

/// The home tab: off duty (readiness and the big button) or on duty (waiting).
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  Timer? _tick;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tick?.cancel();
    super.dispose();
  }

  /// Back from Settings or from the background: read everything again.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(readinessProvider);
      ref.read(profileProvider.notifier).reload();
    }
  }

  Future<void> _setDuty(bool on) async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final profile =
          (await ref
                  .read(clientProvider)
                  .api
                  .getDriverApi()
                  .setDuty(dutyUpdate: DutyUpdate(onDuty: on)))
              .data!;
      ref.read(profileProvider.notifier).adopt(profile);
    } catch (e) {
      final problem = problemOf(e);
      if (mounted) {
        setState(
          () => _error = problem.code == ApiProblem.network
              ? l10n.dutyFailed
              : problemMessage(l10n, problem),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _goOff() async {
    final l10n = AppLocalizations.of(context);
    final ok = await showTurboConfirm(
      context: context,
      title: l10n.homeOffDutyConfirmTitle,
      message: l10n.homeOffDutyConfirmBody,
      confirmLabel: l10n.homeOffDutyConfirm,
    );
    if (ok) await _setDuty(false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    final loaded = ref.watch(profileProvider).value;
    final profile = loaded is ProfileLoaded ? loaded.profile : null;
    if (profile == null) {
      return const Scaffold(body: SafeArea(child: LoadingState()));
    }
    final on = profile.dutyStatus == DriverProfileDutyStatusEnum.onDuty;
    final sharing = ref.watch(locationSharingProvider);
    final online = ref.watch(onlineProvider).value ?? true;
    ref.listen(onlineProvider, (prev, next) {
      if (prev?.value != false && next.value == false) {
        DriverFeedback.wentOffline();
      }
    });
    final now = clock.now();

    Widget banner(String message, {bool danger = true}) => Padding(
      padding: const EdgeInsets.only(bottom: TurboSpacing.md),
      child: TurboCard(
        child: Row(
          children: [
            Icon(
              danger ? Icons.error_outline : Icons.warning_amber,
              color: danger ? t.colors.danger : t.colors.warning,
            ),
            const SizedBox(width: TurboSpacing.md),
            Expanded(
              child: Semantics(
                liveRegion: true,
                child: Text(message, style: text.bodyLarge),
              ),
            ),
          ],
        ),
      ),
    );

    final vehicle = profile.vehicle;
    final docs = ref.watch(driverDocsProvider).value;
    final expired = [
      for (final d in docs ?? const <DriverDoc>[])
        if (d.status == DocStatus.expired) d,
    ];
    // Today's shift, by the Accra date (UTC).
    final shifts = ref.watch(shiftsProvider).value;
    String? shiftText;
    if (shifts != null) {
      final today = clock.now().toUtc();
      final mine = shifts.where((x) {
        final d = x.startsAt.toUtc();
        return d.year == today.year &&
            d.month == today.month &&
            d.day == today.day;
      });
      shiftText = mine.isEmpty
          ? l10n.shiftNoneToday
          : '${DateFormat('HH:mm').format(mine.first.startsAt.toUtc())} – ${DateFormat('HH:mm').format(mine.first.endsAt.toUtc())}';
    }
    final firstName = profile.fullName.split(' ').first;

    if (!on) {
      final readiness = ref.watch(readinessProvider);
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ListView(
                      padding: const EdgeInsets.all(TurboSpacing.screen),
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.homeOffDuty, style: text.bodySmall),
                                  Semantics(
                                    header: true,
                                    child: Text(
                                      l10n.homeGreeting(firstName),
                                      style: text.headlineMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TurboAvatar(name: firstName),
                          ],
                        ),
                        const SizedBox(height: TurboSpacing.lg),
                        TurboCard(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.homeYourVehicle,
                                      style: text.bodySmall,
                                    ),
                                    const SizedBox(height: TurboSpacing.xs),
                                    Text(
                                      vehicle == null
                                          ? l10n.homeNoVehicle
                                          : l10n.homeVehicle(
                                              vehicle.colour,
                                              vehicle.make,
                                              vehicle.model,
                                            ),
                                      style: text.titleLarge,
                                    ),
                                    if (vehicle != null)
                                      Text(
                                        vehicle.plateNumber,
                                        style: context.turbo.styles.emphasis,
                                      ),
                                  ],
                                ),
                              ),
                              // No car picture: the one we have is a silver saloon, not every driver's car.
                            ],
                          ),
                        ),
                        const SizedBox(height: TurboSpacing.lg),
                        if (expired.isNotEmpty) ...[
                          banner(
                            l10n.docBanner(
                              docName(l10n, expired.first.type),
                              DateFormat('d MMM')
                                  .format(expired.first.expiresOn!),
                            ),
                          ),
                          const CallSupervisorButton(),
                          const SizedBox(height: TurboSpacing.lg),
                        ],
                        readiness.when(
                          loading: () => const LoadingState(rows: 2),
                          error: (_, _) => ErrorState(
                            onRetry: () => ref.invalidate(readinessProvider),
                          ),
                          data: (r) {
                            final source = ref.read(readinessSourceProvider);
                            return ReadinessBoard(
                              readiness: r,
                              documents: docs,
                              shift: shiftText,
                              onOpenDocuments: () =>
                                  context.go('/me/documents'),
                              onFixLocation: () async {
                                final viaSettings =
                                    r.location ==
                                        DriverLocationAccess.whileInUse ||
                                    r.location ==
                                        DriverLocationAccess.deniedForever;
                                if (!await showLocationPriming(
                                  context,
                                  viaSettings: viaSettings,
                                )) {
                                  return;
                                }
                                if (viaSettings) {
                                  await source.openSettings();
                                } else {
                                  await source.requestLocation();
                                }
                                ref.invalidate(readinessProvider);
                              },
                              onFixNotifications: () async {
                                if (!await source.requestNotifications()) {
                                  await source.openSettings();
                                }
                                ref.invalidate(readinessProvider);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    // A soft edge, so it is clear the tiles go on under the button.
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: IgnorePointer(
                        child: Container(
                          height: TurboSpacing.xl,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                context.turbo.colors.background.withValues(
                                  alpha: 0,
                                ),
                                context.turbo.colors.background,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(TurboSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: TurboSpacing.md),
                        child: Semantics(
                          liveRegion: true,
                          child: TurboBanner(
                            icon: Icons.error_outline,
                            message: _error!,
                            tone: StatusTone.danger,
                          ),
                        ),
                      ),
                    TurboButton(
                      label: l10n.homeGoOnDuty,
                      driver: true,
                      loading: _busy,
                      onPressed: () => _setDuty(true),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // On duty. Say it plainly when sharing has stalled; never hide a failure.
    final silent = sharing.gpsSilent(now, const Duration(seconds: 30));
    final unreachable = sharing.serverUnreachable(
      now,
      const Duration(seconds: 30),
    );
    final since = sharing.startedAt;
    String elapsed() {
      if (since == null) return '';
      final d = now.difference(since);
      return '${d.inHours}:${(d.inMinutes % 60).toString().padLeft(2, '0')}';
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TurboSpacing.lg,
                      ),
                      child: LayoutBuilder(
                        builder: (context, c) => HomeMap(
                          height: c.maxHeight,
                          spec: const MapSpec(showMyLocation: true),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: TurboSpacing.xl,
                    right: TurboSpacing.xl,
                    top: TurboSpacing.md,
                    child: Column(
                      children: [
                        if (!online) banner(l10n.bannerOffline),
                        if (online && silent) banner(l10n.bannerNotSharing),
                        if (online && !silent && unreachable)
                          banner(l10n.bannerServer, danger: false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(TurboSpacing.lg),
              decoration: BoxDecoration(
                color: t.colors.surface,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(t.radiusCard),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (since != null)
                    Row(
                      children: [
                        Icon(
                          Icons.check,
                          size: TurboSizes.iconSm,
                          color: t.colors.success,
                        ),
                        const SizedBox(width: TurboSpacing.xs),
                        Expanded(
                          child: Text(
                            l10n.homeOnDutyFor(elapsed()),
                            style: text.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  Semantics(
                    header: true,
                    liveRegion: true,
                    child: Text(
                      l10n.homeOnDutyWaiting,
                      style: text.headlineMedium,
                    ),
                  ),
                  const SizedBox(height: TurboSpacing.md),
                  Wrap(
                    spacing: TurboSpacing.sm,
                    runSpacing: TurboSpacing.sm,
                    children: [
                      StatusChip(
                        label: l10n.indicatorGps,
                        icon: silent ? Icons.location_off : Icons.gps_fixed,
                        tone: silent ? StatusTone.danger : StatusTone.success,
                      ),
                      StatusChip(
                        label: l10n.indicatorConnection,
                        icon: online ? Icons.wifi : Icons.wifi_off,
                        tone: online ? StatusTone.success : StatusTone.danger,
                      ),
                    ],
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: TurboSpacing.md),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        _error!,
                        style: text.bodyLarge?.copyWith(color: t.colors.danger),
                      ),
                    ),
                  ],
                  const SizedBox(height: TurboSpacing.md),
                  TurboButton(
                    label: l10n.homeGoOffDuty,
                    variant: TurboButtonVariant.secondary,
                    loading: _busy,
                    onPressed: _goOff,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
