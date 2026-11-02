import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/driver_feedback.dart';
import '../../core/keep_awake.dart';
import '../../core/problem_messages.dart';
import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import '../duty/connectivity.dart';
import '../map/map_view.dart';
import '../safety/sos.dart';
import 'ride_providers.dart';

/// One screen for the driver's whole ride. What shows depends on the ride's
/// state, and the driver cannot leave it until the ride is over.
class DriverRideScreen extends ConsumerStatefulWidget {
  const DriverRideScreen({super.key});

  @override
  ConsumerState<DriverRideScreen> createState() => _DriverRideScreenState();
}

class _DriverRideScreenState extends ConsumerState<DriverRideScreen> {
  DriverRide? _last;
  RideOutcome? _outcome;
  DriverRide? _endRide;
  bool _resolving = false;
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  Future<void> _resolve(String id) async {
    _resolving = true;
    final r = await resolveOutcome(ref.read(clientProvider), id);
    if (!mounted) return;
    setState(() {
      _outcome = r.outcome;
      _endRide = r.ride;
      _resolving = false;
    });
  }

  void _finish() {
    ref.invalidate(currentRideProvider);
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final asyncRide = ref.watch(currentRideProvider);
    final ride = asyncRide.value;

    ref.listen(onlineProvider, (prev, next) {
      if (prev?.value != false && next.value == false) DriverFeedback.wentOffline();
    });

    if (ride != null) {
      _last = ride;
      _outcome = null;
    } else if (_last != null &&
        _outcome == null &&
        !_resolving &&
        asyncRide.hasValue) {
      final id = _last!.id;
      WidgetsBinding.instance.addPostFrameCallback((_) => _resolve(id));
    } else if (_last == null && asyncRide.hasValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/home');
      });
    }

    final Widget body;
    if (_outcome != null) {
      body = _End(
        outcome: _outcome!,
        ride: _endRide ?? _last!,
        onDone: _finish,
      );
    } else if (ride == null) {
      body = asyncRide.hasError
          ? ErrorState(
              message: l10n.rideLoadFailed,
              onRetry: () => ref.invalidate(currentRideProvider),
            )
          : const LoadingState();
    } else if (ride.status == RideStatus.assigned &&
        ride.acknowledgedAt == null) {
      body = _Offer(ride: ride);
    } else if (ride.status == RideStatus.assigned) {
      body = KeepScreenAwake(child: _ToPickup(ride: ride));
    } else if (ride.status == RideStatus.driverArrived) {
      body = KeepScreenAwake(child: _AtPickup(ride: ride));
    } else {
      body = KeepScreenAwake(child: _Trip(ride: ride));
    }

    return PopScope(
      canPop: false,
      child: Scaffold(body: SafeArea(child: body)),
    );
  }
}

/// Opens a maps app with directions to a point.
Future<void> _openNavigation(BuildContext context, GeoPoint to) async {
  final l10n = AppLocalizations.of(context);
  final choice = await showTurboSheet<String>(
    context: context,
    builder: (sheet) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TurboButton(
          label: l10n.navigateGoogle,
          driver: true,
          onPressed: () => Navigator.of(sheet).pop('google'),
        ),
        const SizedBox(height: TurboSpacing.md),
        TurboButton(
          label: l10n.navigateWaze,
          driver: true,
          variant: TurboButtonVariant.secondary,
          onPressed: () => Navigator.of(sheet).pop('waze'),
        ),
      ],
    ),
  );
  if (choice == null) return;
  final uri = choice == 'waze'
      ? Uri.parse('https://waze.com/ul?ll=${to.lat},${to.lng}&navigate=yes')
      : Uri.parse(
          'https://www.google.com/maps/dir/?api=1&destination=${to.lat},${to.lng}&travelmode=driving',
        );
  final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!ok && context.mounted) showTurboToast(context, l10n.navigateFailed);
}

String _clockText(Duration d) {
  final m = d.inMinutes.abs();
  final s = d.inSeconds.abs() % 60;
  return '$m:${s.toString().padLeft(2, '0')}';
}

class _Offer extends ConsumerStatefulWidget {
  const _Offer({required this.ride});

  final DriverRide ride;

  @override
  ConsumerState<_Offer> createState() => _OfferState();
}

class _OfferState extends ConsumerState<_Offer> {
  bool _busy = false;
  String? _error;
  bool _warned = false;
  Timer? _tick;

  int get _left => (ackWindow - clock.now().difference(widget.ride.assignedAt))
      .inSeconds
      .clamp(0, ackWindow.inSeconds);

  @override
  void initState() {
    super.initState();
    // The offer has just taken over the screen: sound and a buzz, once.
    DriverFeedback.offered();
    // Count down every second, and sound once when ten seconds are left.
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final left = _left;
      if (!_warned && left > 0 && left <= 10) {
        _warned = true;
        DriverFeedback.offerExpiring();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  Future<void> _accept() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(driverRideActionsProvider).acknowledge(widget.ride.id);
      DriverFeedback.accepted();
    } on ApiProblem catch (p) {
      if (mounted) setState(() => _error = problemMessage(l10n, p));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _decline() async {
    final l10n = AppLocalizations.of(context);
    final reason = await showTurboSheet<DeclineRequestReasonCodeEnum>(
      context: context,
      builder: (sheet) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              l10n.declineTitle,
              style: Theme.of(sheet).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: TurboSpacing.md),
          for (final (code, label) in [
            (DeclineRequestReasonCodeEnum.vehicleIssue, l10n.declineVehicle),
            (DeclineRequestReasonCodeEnum.tooFar, l10n.declineFar),
            (DeclineRequestReasonCodeEnum.unwell, l10n.declineUnwell),
            (DeclineRequestReasonCodeEnum.other, l10n.declineOther),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: TurboSpacing.sm),
              child: TurboButton(
                label: label,
                variant: TurboButtonVariant.secondary,
                onPressed: () => Navigator.of(sheet).pop(code),
              ),
            ),
        ],
      ),
    );
    if (reason == null || !mounted) return;
    try {
      await ref.read(driverRideActionsProvider).decline(widget.ride.id, reason);
    } on ApiProblem catch (p) {
      if (mounted) setState(() => _error = problemMessage(l10n, p));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    final r = widget.ride;
    final left = _left;
    final km = ((r.pickupDistanceMeters ?? 0) / 1000).toStringAsFixed(1);
    final minutes = ((r.pickupEtaSeconds ?? 0) / 60).ceil();

    Widget line(String value, TextStyle? style) => Padding(
      padding: const EdgeInsets.symmetric(vertical: TurboSpacing.sm),
      child: Text(value, style: style),
    );
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(TurboSpacing.screen),
            children: [
              Center(
                child: Semantics(
                  label: l10n.assignSeconds(left),
                  child: SizedBox.square(
                    dimension: 140,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox.expand(
                          child: CircularProgressIndicator(
                            value: left / ackWindow.inSeconds,
                            strokeWidth: 10,
                            color: left <= 10
                                ? t.colors.danger
                                : t.colors.accentText,
                            backgroundColor: t.colors.border,
                          ),
                        ),
                        Text(
                          l10n.assignSeconds(left),
                          style: t.styles.monoCountdown,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: TurboSpacing.xl),
              Semantics(
                header: true,
                liveRegion: true,
                child: Text(
                  l10n.assignTitle,
                  style: text.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                r.pickup.label ?? '',
                style: t.styles.driverTitle,
                textAlign: TextAlign.center,
              ),
              if (r.pickup.landmark != null)
                Text(
                  r.pickup.landmark!,
                  style: text.bodyLarge?.copyWith(color: t.colors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: TurboSpacing.xl),
              TurboCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    line(l10n.assignDistance(km, minutes), text.bodyLarge),
                    const Divider(),
                    line(
                      l10n.assignTrip(
                        (r.routeDistanceMeters / 1000).toStringAsFixed(1),
                      ),
                      text.bodyLarge,
                    ),
                    const Divider(),
                    line(
                      l10n.assignStudent(r.student.firstName),
                      text.bodyLarge,
                    ),
                    if (r.farePesewas != null) ...[
                      const Divider(),
                      line(
                        l10n.assignFare(formatPesewas(r.farePesewas!)),
                        text.bodyLarge,
                      ),
                    ],
                  ],
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
                  child: TurboBanner(icon: Icons.error_outline, message: _error!, tone: StatusTone.danger, liveRegion: true),
                ),
              TurboButton(
                label: l10n.assignAccept,
                driver: true,
                loading: _busy,
                onPressed: _accept,
              ),
              const SizedBox(height: TurboSpacing.md),
              TurboButton(
                label: l10n.assignDecline,
                driver: true,
                variant: TurboButtonVariant.secondary,
                onPressed: _busy ? null : _decline,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickMessages extends ConsumerWidget {
  const _QuickMessages({required this.ride, required this.codes});

  final DriverRide ride;
  final List<QuickMessageCode> codes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    String label(QuickMessageCode c) => switch (c) {
      QuickMessageCode.runningLate => l10n.qmRunningLate,
      QuickMessageCode.imHere => l10n.qmImHere,
      QuickMessageCode.atTheGate => l10n.qmAtTheGate,
      QuickMessageCode.cannotFindYou => l10n.qmCannotFindYou,
      QuickMessageCode.onMyWay => l10n.qmOnMyWay,
      QuickMessageCode.pleaseComeOut => l10n.qmPleaseComeOut,
    };
    return SizedBox(
      height: TurboSizes.primaryAction,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final c in codes)
            Padding(
              padding: const EdgeInsets.only(right: TurboSpacing.sm),
              child: ActionChip(
                label: Text(label(c)),
                onPressed: () async {
                  try {
                    await ref
                        .read(driverRideActionsProvider)
                        .message(ride.id, c);
                  } on ApiProblem {
                    if (context.mounted) {
                      showTurboToast(context, l10n.rideMessageFailed);
                    }
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// The rounded panel under the map. Scrolls if large text makes it taller than the screen.
class _Sheet extends StatelessWidget {
  const _Sheet({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    return Flexible(
      flex: 0,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.7,
        ),
        decoration: BoxDecoration(
          color: t.colors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(t.radiusCard),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(TurboSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}

class _Map extends StatelessWidget {
  const _Map({required this.to, this.route});

  final GeoPoint to;

  /// The trip's road, shown once the trip has started.
  final String? route;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) => HomeMap(
      height: c.maxHeight,
      spec: MapSpec(dropoff: to, showMyLocation: true, route: route),
    ),
  );
}

class _ToPickup extends ConsumerStatefulWidget {
  const _ToPickup({required this.ride});

  final DriverRide ride;

  @override
  ConsumerState<_ToPickup> createState() => _ToPickupState();
}

class _ToPickupState extends ConsumerState<_ToPickup> {
  bool _busy = false;
  String? _error;

  Future<void> _arrived() async {
    final l10n = AppLocalizations.of(context);
    final actions = ref.read(driverRideActionsProvider);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final here = await actions.position();
      if (here == null) throw const ApiProblem(code: 'no_location', title: '');
      final target = widget.ride.pickup.point;
      final far =
          distanceMeters(
            here.lat.toDouble(),
            here.lng.toDouble(),
            target.lat.toDouble(),
            target.lng.toDouble(),
          ) >
          arrivedRadiusMeters;
      if (far && mounted) {
        // A soft check: far from the pickup asks first, but never forbids.
        final sure = await showTurboConfirm(
          context: context,
          title: l10n.pickupFarTitle,
          message: l10n.pickupFarBody,
          confirmLabel: l10n.pickupFarConfirm,
        );
        if (!sure) return;
      }
      await actions.arrived(widget.ride.id, here);
      DriverFeedback.arrived();
    } on ApiProblem catch (p) {
      if (mounted) {
        setState(
          () => _error = p.code == 'no_location'
              ? l10n.rideActionFailed
              : problemMessage(l10n, p),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    final r = widget.ride;
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: TurboSpacing.lg),
            child: _Map(to: r.pickup.point),
          ),
        ),
        _Sheet(
          children: [
            Semantics(
              header: true,
              child: Text(l10n.pickupTitle, style: text.titleLarge),
            ),
            Text(r.pickup.label ?? '', style: text.headlineMedium),
            if (r.pickup.landmark != null)
              Text(r.pickup.landmark!, style: text.bodyLarge),
            Text(
              l10n.assignStudent(r.student.firstName),
              style: text.bodyMedium,
            ),
            const SizedBox(height: TurboSpacing.md),
            TurboButton(
              label: l10n.pickupNavigate,
              driver: true,
              variant: TurboButtonVariant.secondary,
              icon: Icons.navigation_outlined,
              onPressed: () => _openNavigation(context, r.pickup.point),
            ),
            const SizedBox(height: TurboSpacing.md),
            _QuickMessages(
              ride: r,
              codes: const [
                QuickMessageCode.runningLate,
                QuickMessageCode.imHere,
                QuickMessageCode.atTheGate,
                QuickMessageCode.cannotFindYou,
              ],
            ),
            const SizedBox(height: TurboSpacing.md),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: TurboSpacing.md),
                child: Semantics(
                  liveRegion: true,
                  child: Text(
                    _error!,
                    style: text.bodyLarge?.copyWith(color: t.colors.danger),
                  ),
                ),
              ),
            TurboButton(
              label: l10n.pickupArrived,
              driver: true,
              loading: _busy,
              onPressed: _arrived,
            ),
            const SizedBox(height: TurboSpacing.md),
            HoldToSos(rideId: r.id),
          ],
        ),
      ],
    );
  }
}

class _AtPickup extends ConsumerStatefulWidget {
  const _AtPickup({required this.ride});

  final DriverRide ride;

  @override
  ConsumerState<_AtPickup> createState() => _AtPickupState();
}

class _AtPickupState extends ConsumerState<_AtPickup> {
  bool _entering = false;
  String _pin = '';
  bool _busy = false;
  bool _locked = false;
  int _shakes = 0;
  String? _error;

  Future<void> _start() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(driverRideActionsProvider).start(widget.ride.id, _pin);
      DriverFeedback.pinAccepted();
    } on ApiProblem catch (p) {
      DriverFeedback.pinWrong();
      if (!mounted) return;
      setState(() {
        _pin = '';
        _shakes++;
        if (p.code == 'pin_locked') {
          _locked = true;
        } else {
          _error = problemMessage(l10n, p);
        }
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _notHere() async {
    final l10n = AppLocalizations.of(context);
    final ok = await showTurboConfirm(
      context: context,
      title: l10n.waitingNotHereConfirmTitle,
      message: l10n.waitingNotHereConfirmBody,
      confirmLabel: l10n.waitingNotHereConfirm,
      destructive: true,
    );
    if (!ok || !mounted) return;
    try {
      await ref.read(driverRideActionsProvider).noShow(widget.ride.id);
    } on ApiProblem catch (p) {
      if (mounted) setState(() => _error = problemMessage(l10n, p));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    final r = widget.ride;

    if (_locked) {
      return Padding(
        padding: const EdgeInsets.all(TurboSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            const BadgeIcon(icon: Icons.lock_outline),
            const SizedBox(height: TurboSpacing.lg),
            Semantics(
              header: true,
              liveRegion: true,
              child: Text(l10n.pinLockedTitle, style: text.headlineMedium),
            ),
            const SizedBox(height: TurboSpacing.sm),
            Text(l10n.pinLockedBody, style: text.titleLarge),
            const Spacer(),
          ],
        ),
      );
    }

    if (_entering) {
      return Padding(
        padding: const EdgeInsets.all(TurboSpacing.screen),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Semantics(
                  header: true,
                  child: Text(l10n.pinTitle, style: text.headlineMedium),
                ),
              ),
              const SizedBox(height: TurboSpacing.sm),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(l10n.pinHint, style: text.bodyMedium),
              ),
              const SizedBox(height: TurboSpacing.xl),
              TurboShake(
                trigger: _shakes,
                child: TripPin(digits: _pin, current: true, error: _error != null),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: TurboSpacing.md),
                  child: Semantics(
                    liveRegion: true,
                    child: Text(
                      _error!,
                      style: text.bodyLarge?.copyWith(color: t.colors.danger),
                    ),
                  ),
                ),
              const SizedBox(height: TurboSpacing.xl),
              TurboKeypad(
                enabled: !_busy,
                deleteLabel: l10n.pinDelete,
                onDigit: (k) => setState(() {
                  _error = null;
                  if (_pin.length < 4) _pin += k;
                }),
                onDelete: () => setState(() {
                  _error = null;
                  if (_pin.isNotEmpty) _pin = _pin.substring(0, _pin.length - 1);
                }),
              ),
              const SizedBox(height: TurboSpacing.lg),
              TurboButton(
                label: l10n.pinStart,
                driver: true,
                loading: _busy,
                onPressed: _pin.length == 4 ? _start : null,
              ),
              const SizedBox(height: TurboSpacing.sm),
              TextButton(
                onPressed: () => setState(() => _entering = false),
                child: Text(l10n.back, style: text.bodyLarge),
              ),
            ],
          ),
        ),
      );
    }

    final noShowAt = r.noShowAvailableAt;
    final now = clock.now();
    final canNoShow = noShowAt != null && !now.isBefore(noShowAt);
    // The wait started five minutes before the no-show time (decision D26).
    final waited = noShowAt == null
        ? Duration.zero
        : now.difference(noShowAt.subtract(const Duration(minutes: 5)));

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(TurboSpacing.xl),
            children: [
              Semantics(
                header: true,
                child: Text(l10n.waitingTitle, style: text.bodyLarge),
              ),
              Text(
                l10n.waitingTimer(_clockText(waited)),
                style: text.headlineMedium?.copyWith(
                  fontSize: text.headlineMedium!.fontSize! * 2,
                ),
              ),
              const SizedBox(height: TurboSpacing.lg),
              TurboCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.assignStudent(r.student.firstName),
                      style: text.titleLarge,
                    ),
                    Text(r.pickup.label ?? '', style: text.bodyLarge),
                    if (r.pickup.landmark != null)
                      Text(r.pickup.landmark!, style: text.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(height: TurboSpacing.lg),
              _QuickMessages(
                ride: r,
                codes: const [
                  QuickMessageCode.imHere,
                  QuickMessageCode.atTheGate,
                  QuickMessageCode.pleaseComeOut,
                  QuickMessageCode.cannotFindYou,
                ],
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
                    child: Text(
                      _error!,
                      style: text.bodyLarge?.copyWith(color: t.colors.danger),
                    ),
                  ),
                ),
              if (!canNoShow && noShowAt != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: TurboSpacing.md),
                  child: Text(
                    l10n.waitingNotHereAt(
                      '${noShowAt.toUtc().hour.toString().padLeft(2, '0')}:${noShowAt.toUtc().minute.toString().padLeft(2, '0')}',
                    ),
                    style: text.bodyMedium,
                  ),
                ),
              if (canNoShow) ...[
                TurboButton(
                  label: l10n.waitingNotHere,
                  variant: TurboButtonVariant.secondary,
                  onPressed: _notHere,
                ),
                const SizedBox(height: TurboSpacing.md),
              ],
              TurboButton(
                label: l10n.waitingStart,
                driver: true,
                onPressed: () => setState(() => _entering = true),
              ),
              const SizedBox(height: TurboSpacing.md),
              HoldToSos(rideId: r.id),
            ],
          ),
        ),
      ],
    );
  }
}

class _Trip extends ConsumerStatefulWidget {
  const _Trip({required this.ride});

  final DriverRide ride;

  @override
  ConsumerState<_Trip> createState() => _TripState();
}

class _TripState extends ConsumerState<_Trip> {
  final _seen = clock.now();
  bool _busy = false;
  String? _error;

  /// The completion that is waiting for a signal. Kept so the driver is never
  /// stuck: it is retried until the server answers.
  GeoPoint? _pending;
  Timer? _retry;

  @override
  void dispose() {
    _retry?.cancel();
    super.dispose();
  }

  Future<void> _complete() async {
    final l10n = AppLocalizations.of(context);
    final ok = await showTurboConfirm(
      context: context,
      title: l10n.tripCompleteConfirmTitle,
      message: l10n.tripCompleteConfirmBody,
      confirmLabel: l10n.tripCompleteConfirm,
    );
    if (!ok || !mounted) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final here =
        await ref.read(driverRideActionsProvider).position() ??
        widget.ride.dropoff.point;
    await _send(here);
  }

  Future<void> _send(GeoPoint at) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(driverRideActionsProvider).complete(widget.ride.id, at);
      DriverFeedback.tripCompleted();
      _retry?.cancel();
      if (mounted) setState(() => _pending = null);
    } on ApiProblem catch (p) {
      if (!mounted) return;
      if (p.code == ApiProblem.network || (p.status ?? 0) >= 500) {
        // No signal: keep the completion and try again until it lands.
        setState(() => _pending = at);
        _retry?.cancel();
        _retry = Timer.periodic(const Duration(seconds: 5), (_) => _send(at));
      } else {
        setState(() {
          _pending = null;
          _error = problemMessage(l10n, p);
        });
        _retry?.cancel();
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    final r = widget.ride;
    final elapsed = clock.now().difference(_seen);

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: TurboSpacing.lg),
            child: _Map(to: r.dropoff.point, route: r.routePolyline),
          ),
        ),
        _Sheet(
          children: [
            Semantics(
              header: true,
              child: Text(l10n.tripTitle, style: text.titleLarge),
            ),
            Text(
              l10n.tripDropoff(r.dropoff.label ?? ''),
              style: text.headlineMedium?.copyWith(
                fontSize: text.headlineMedium!.fontSize! * 1.25,
              ),
            ),
            Text(l10n.tripElapsed(_clockText(elapsed)), style: text.bodyMedium),
            const SizedBox(height: TurboSpacing.md),
            TurboButton(
              label: l10n.tripNavigate,
              driver: true,
              variant: TurboButtonVariant.secondary,
              icon: Icons.navigation_outlined,
              onPressed: () => _openNavigation(context, r.dropoff.point),
            ),
            const SizedBox(height: TurboSpacing.md),
            if (_pending != null)
              TurboCard(
                child: Row(
                  children: [
                    const SizedBox.square(
                      dimension: TurboSizes.iconMd,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: TurboSpacing.md),
                    Expanded(
                      child: Semantics(
                        liveRegion: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.tripWaitingSignal,
                              style: text.labelLarge,
                            ),
                            Text(
                              l10n.tripWaitingSignalBody,
                              style: text.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: TurboSpacing.md),
                  child: Semantics(
                    liveRegion: true,
                    child: Text(
                      _error!,
                      style: text.bodyLarge?.copyWith(color: t.colors.danger),
                    ),
                  ),
                ),
              TurboButton(
                label: l10n.tripComplete,
                driver: true,
                loading: _busy,
                onPressed: _complete,
              ),
            ],
            const SizedBox(height: TurboSpacing.md),
            HoldToSos(rideId: r.id),
            TextButton(
              onPressed: () => context.push('/support/new', extra: r.id),
              child: Text(
                l10n.tripReport,
                style: text.bodyMedium?.copyWith(color: t.colors.accentText),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _End extends StatelessWidget {
  const _End({required this.outcome, required this.ride, required this.onDone});

  final RideOutcome outcome;
  final DriverRide ride;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final (IconData icon, String title, String body) = switch (outcome) {
      RideOutcome.completed => (
        Icons.check,
        l10n.doneTitle,
        l10n.doneDetails(
          (ride.routeDistanceMeters / 1000).toStringAsFixed(1),
          ((ride.routeDurationSeconds ?? 0) / 60).round(),
        ),
      ),
      RideOutcome.cancelled => (
        Icons.close,
        l10n.cancelledTitle,
        '${l10n.cancelledBySystem} ${l10n.cancelledBody}',
      ),
      RideOutcome.passed => (
        Icons.swap_horiz,
        l10n.assignPassed,
        l10n.assignPassedBody,
      ),
    };
    return Padding(
      padding: const EdgeInsets.all(TurboSpacing.xl),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: TurboSpacing.xxl),
                Center(child: BadgeIcon(icon: icon)),
                const SizedBox(height: TurboSpacing.xl),
                Semantics(
                  header: true,
                  liveRegion: true,
                  child: Text(
                    title,
                    style: text.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: TurboSpacing.sm),
                Text(body, style: text.titleLarge, textAlign: TextAlign.center),
              ],
            ),
          ),
          TurboButton(label: l10n.doneBack, driver: true, onPressed: onDone),
        ],
      ),
    );
  }
}
