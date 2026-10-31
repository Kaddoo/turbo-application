import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../core/profile.dart';
import '../../core/problem_messages.dart';
import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../location/location_access.dart';
import '../duty/connectivity.dart';
import '../duty/location_sharing.dart';
import '../duty/readiness.dart';
import '../map/map_view.dart';

/// The home tab: off duty (readiness and the big button) or on duty (waiting).
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with WidgetsBindingObserver {
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
      final profile = (await ref.read(clientProvider).api.getDriverApi().setDuty(dutyUpdate: DutyUpdate(onDuty: on))).data!;
      ref.read(profileProvider.notifier).adopt(profile);
    } catch (e) {
      final problem = problemOf(e);
      if (mounted) {
        setState(() => _error = problem.code == ApiProblem.network ? l10n.dutyFailed : problemMessage(l10n, problem));
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
    if (profile == null) return const Scaffold(body: SafeArea(child: LoadingState()));
    final on = profile.dutyStatus == DriverProfileDutyStatusEnum.onDuty;
    final sharing = ref.watch(locationSharingProvider);
    final online = ref.watch(onlineProvider).value ?? true;
    final now = clock.now();

    Widget banner(String message, {bool danger = true}) => Padding(
          padding: const EdgeInsets.only(bottom: TurboSpacing.md),
          child: TurboCard(
            child: Row(
              children: [
                Icon(danger ? Icons.error_outline : Icons.warning_amber, color: danger ? t.colors.danger : t.colors.warning),
                const SizedBox(width: TurboSpacing.md),
                Expanded(child: Semantics(liveRegion: true, child: Text(message, style: text.bodyLarge))),
              ],
            ),
          ),
        );

    final vehicle = profile.vehicle;
    final firstName = profile.fullName.split(' ').first;

    if (!on) {
      final readiness = ref.watch(readinessProvider);
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(TurboSpacing.xl),
                  children: [
                    Semantics(header: true, child: Text(l10n.homeGreeting(firstName), style: text.headlineMedium)),
                    const SizedBox(height: TurboSpacing.sm),
                    Text(
                      vehicle == null ? l10n.homeNoVehicle : l10n.homeVehicle(vehicle.colour, vehicle.make, vehicle.model, vehicle.plateNumber),
                      style: text.bodyLarge,
                    ),
                    const SizedBox(height: TurboSpacing.xl),
                    Semantics(header: true, child: Text(l10n.readinessTitle, style: text.titleLarge)),
                    const SizedBox(height: TurboSpacing.sm),
                    readiness.when(
                      loading: () => const LoadingState(rows: 1),
                      error: (_, _) => ErrorState(onRetry: () => ref.invalidate(readinessProvider)),
                      data: (r) {
                        final source = ref.read(readinessSourceProvider);
                        Widget row(String label, bool ok, {VoidCallback? fix, String? fixLabel}) => TurboListRow(
                              title: label,
                              leading: Icon(ok ? Icons.check_circle_outline : Icons.error_outline, color: ok ? t.colors.success : t.colors.danger),
                              trailing: ok
                                  ? Text(l10n.readinessOk, style: text.bodyMedium?.copyWith(color: t.colors.success))
                                  : TextButton(
                                      onPressed: fix,
                                      child: Text(fixLabel ?? l10n.readinessFix, style: text.bodyMedium?.copyWith(color: t.colors.accentText)),
                                    ),
                            );
                        return Column(
                          children: [
                            row(
                              l10n.readinessLocation,
                              r.locationOk,
                              fixLabel: r.location == DriverLocationAccess.whileInUse || r.location == DriverLocationAccess.deniedForever
                                  ? l10n.readinessOpenSettings
                                  : l10n.readinessLocationFix,
                              fix: () async {
                                if (r.location == DriverLocationAccess.whileInUse || r.location == DriverLocationAccess.deniedForever) {
                                  await source.openSettings();
                                } else {
                                  await source.requestLocation();
                                }
                                ref.invalidate(readinessProvider);
                              },
                            ),
                            row(l10n.readinessBattery, r.batteryOk),
                            row(l10n.readinessInternet, r.online),
                            row(
                              l10n.readinessNotifications,
                              r.notifications,
                              fix: () async {
                                if (!await source.requestNotifications()) await source.openSettings();
                                ref.invalidate(readinessProvider);
                              },
                            ),
                            TurboListRow(
                              title: l10n.readinessDocuments,
                              leading: Icon(Icons.description_outlined, color: t.colors.textSecondary),
                            ),
                          ],
                        );
                      },
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
                        child: Semantics(liveRegion: true, child: Text(_error!, style: text.bodyLarge?.copyWith(color: t.colors.danger))),
                      ),
                    TurboButton(label: l10n.homeGoOnDuty, large: true, loading: _busy, onPressed: () => _setDuty(true)),
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
    final unreachable = sharing.serverUnreachable(now, const Duration(seconds: 30));
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
              child: Padding(
                padding: const EdgeInsets.all(TurboSpacing.lg),
                child: LayoutBuilder(
                  builder: (context, c) => HomeMap(height: c.maxHeight, spec: const MapSpec(showMyLocation: true)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(TurboSpacing.lg, 0, TurboSpacing.lg, TurboSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!online) banner(l10n.bannerOffline),
                  if (online && silent) banner(l10n.bannerNotSharing),
                  if (online && !silent && unreachable) banner(l10n.bannerServer, danger: false),
                  Semantics(header: true, liveRegion: true, child: Text(l10n.homeOnDutyWaiting, style: text.titleLarge)),
                  if (since != null) Text(l10n.homeOnDutyFor(elapsed()), style: text.bodyMedium),
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
                    Semantics(liveRegion: true, child: Text(_error!, style: text.bodyLarge?.copyWith(color: t.colors.danger))),
                  ],
                  const SizedBox(height: TurboSpacing.md),
                  TurboButton(label: l10n.homeGoOffDuty, variant: TurboButtonVariant.secondary, loading: _busy, onPressed: _goOff),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
