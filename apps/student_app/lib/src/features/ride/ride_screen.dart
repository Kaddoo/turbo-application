import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../core/problem_messages.dart';
import '../../l10n/app_localizations.dart';
import '../home/map_view.dart';
import '../safety/sos.dart';
import 'ride_providers.dart';

/// One screen for the whole life of a ride. What shows depends on its status.
class RideScreen extends ConsumerStatefulWidget {
  const RideScreen({super.key, required this.rideId});

  final String rideId;

  @override
  ConsumerState<RideScreen> createState() => _RideScreenState();
}

class _RideScreenState extends ConsumerState<RideScreen> {
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    // Re-draws the clock on the searching screen once a second.
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final id = widget.rideId;
    final ride = ref.watch(rideProvider(id));

    // One haptic when the driver arrives, and one heavy tap when the ride ends. Both only on the change
    // seen on this screen, so opening a ride that is already completed stays quiet.
    ref.listen(rideProvider(id), (prev, next) {
      final before = prev?.value?.status;
      final now = next.value?.status;
      if (before != RideStatus.driverArrived && now == RideStatus.driverArrived) {
        TurboHaptics.success();
      }
      if (before != null && before != RideStatus.completed && now == RideStatus.completed) {
        TurboHaptics.completed();
      }
    });

    final value = ride.value;
    if (value == null) {
      return Scaffold(
        body: SafeArea(
          child: ride.hasError
              ? ErrorState(message: l10n.rideLoadFailed, onRetry: () => ref.invalidate(rideProvider(id)))
              : const LoadingState(),
        ),
      );
    }

    final active = isActiveStatus(value.status);
    return PopScope(
      // An active ride cannot be backed out of.
      canPop: !active,
      child: Scaffold(
        body: SafeArea(
          child: switch (value.status) {
            RideStatus.searching => _Searching(ride: value),
            RideStatus.assigned || RideStatus.driverArrived => _Assigned(ride: value),
            RideStatus.inProgress => _InTrip(ride: value),
            RideStatus.completed => _Done(ride: value),
            RideStatus.cancelled => _Cancelled(ride: value),
          },
        ),
      ),
    );
  }
}

MapSpec _specFor(Ride ride, Tracking? tracking) => MapSpec(
      pickup: ride.pickup.point,
      dropoff: ride.dropoff.point,
      driver: tracking?.driverLocation?.point,
      route: ride.routePolyline,
    );

class _Panel extends StatelessWidget {
  const _Panel({required this.map, required this.children});

  final Widget map;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    return Column(
      children: [
        Expanded(child: Padding(padding: const EdgeInsets.all(TurboSpacing.lg), child: map)),
        // The information sits in a rounded sheet under the map; it scrolls when
        // large text makes it taller than the screen allows.
        Flexible(
          flex: 3,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: t.colors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(t.radiusSheet)),
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
        ),
      ],
    );
  }
}

class _RideMap extends ConsumerWidget {
  const _RideMap(this.ride, {this.tracking});

  final Ride ride;
  final Tracking? tracking;

  @override
  Widget build(BuildContext context, WidgetRef ref) => LayoutBuilder(
        builder: (context, c) => HomeMap(height: c.maxHeight, spec: _specFor(ride, tracking)),
      );
}

String _clockText(Duration d) => '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

Future<void> _confirmCancel(BuildContext context, WidgetRef ref, Ride ride) async {
  final l10n = AppLocalizations.of(context);
  final reasons = {
    CancelRequestReasonCodeEnum.waitTooLong: l10n.cancelWaitTooLong,
    CancelRequestReasonCodeEnum.studentChangedMind: l10n.cancelChangedMind,
    CancelRequestReasonCodeEnum.wrongLocation: l10n.cancelWrongLocation,
    CancelRequestReasonCodeEnum.other: l10n.cancelOther,
  };
  await showTurboSheet<void>(
    context: context,
    builder: (sheet) => _CancelSheet(ride: ride, reasons: reasons),
  );
}

class _CancelSheet extends ConsumerStatefulWidget {
  const _CancelSheet({required this.ride, required this.reasons});

  final Ride ride;
  final Map<CancelRequestReasonCodeEnum, String> reasons;

  @override
  ConsumerState<_CancelSheet> createState() => _CancelSheetState();
}

class _CancelSheetState extends ConsumerState<_CancelSheet> {
  CancelRequestReasonCodeEnum? _reason;
  bool _busy = false;
  String? _error;

  Future<void> _cancel() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(rideActionsProvider).cancel(widget.ride.id, _reason ?? CancelRequestReasonCodeEnum.other);
      if (mounted) Navigator.of(context).pop();
    } on ApiProblem catch (p) {
      if (mounted) setState(() => _error = p.code == ApiProblem.network ? l10n.rideCancelFailed : problemMessage(l10n, p));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(header: true, child: Text(l10n.rideCancelTitle, style: text.titleLarge)),
        const SizedBox(height: TurboSpacing.xs),
        Text(l10n.rideCancelFree, style: text.bodyMedium),
        const SizedBox(height: TurboSpacing.md),
        RadioGroup<CancelRequestReasonCodeEnum>(
          groupValue: _reason,
          onChanged: (v) {
            if (!_busy) setState(() => _reason = v);
          },
          child: Column(
            children: [
              for (final e in widget.reasons.entries)
                RadioListTile<CancelRequestReasonCodeEnum>(
                  value: e.key,
                  title: Text(e.value, style: text.bodyLarge),
                  contentPadding: EdgeInsets.zero,
                  activeColor: t.colors.accentText,
                ),
            ],
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: TurboSpacing.sm),
          Semantics(liveRegion: true, child: Text(_error!, style: text.bodyMedium?.copyWith(color: t.colors.danger))),
        ],
        const SizedBox(height: TurboSpacing.lg),
        TurboButton(label: l10n.rideCancel, variant: TurboButtonVariant.destructive, loading: _busy, onPressed: _cancel),
        const SizedBox(height: TurboSpacing.sm),
        TurboButton(label: l10n.rideKeep, variant: TurboButtonVariant.secondary, onPressed: _busy ? null : () => Navigator.of(context).pop()),
      ],
    );
  }
}

class _Searching extends ConsumerWidget {
  const _Searching({required this.ride});

  final Ride ride;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final held = ride.payment.heldPesewas;
    return _Panel(
      map: _RideMap(ride),
      children: [
        Row(
          children: [
            Expanded(child: Semantics(header: true, liveRegion: true, child: Text(l10n.rideSearchingTitle, style: text.titleLarge))),
            Text(_clockText(sinceRequested(ride)), style: text.bodyMedium),
          ],
        ),
        const SizedBox(height: TurboSpacing.md),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: BentoTile(
                  label: l10n.rideTileFareHeld,
                  title: formatPesewas(held > 0 ? held : ride.farePesewas),
                  tone: BentoTone.lime,
                  money: true,
                  trailing: const TurboArtImage(TurboArt.locked),
                ),
              ),
              const SizedBox(width: TurboSpacing.md),
              Expanded(
                child: BentoTile(
                  label: l10n.rideTileTo,
                  title: ride.dropoff.label ?? '',
                  trailing: const TurboArtImage(TurboArt.roundPushpin),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: TurboSpacing.sm),
        Text(l10n.rideSearchingFrom(ride.pickup.label ?? ''), style: text.bodyMedium),
        const SizedBox(height: TurboSpacing.lg),
        TurboButton(
          label: l10n.rideCancel,
          variant: TurboButtonVariant.secondary,
          onPressed: () => _confirmCancel(context, ref, ride),
        ),
      ],
    );
  }
}

class _DriverRow extends StatelessWidget {
  const _DriverRow({required this.ride, this.subtitle});

  final Ride ride;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    final driver = ride.driver;
    final v = ride.vehicle;
    return Row(
      children: [
        TurboAvatar(
          name: driver?.firstName ?? '?',
          image: driver?.photoUrl != null ? NetworkImage(driver!.photoUrl!) : null,
        ),
        const SizedBox(width: TurboSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(driver?.firstName ?? '', style: text.labelLarge),
              if (v != null) Text(l10n.rideVehicleLine(v.colour, v.make, v.model), style: text.bodySmall),
              if (subtitle != null) Text(subtitle!, style: text.bodySmall),
            ],
          ),
        ),
        if (v != null)
          Flexible(
            child: Semantics(
              label: '${l10n.ridePlate} ${v.plateNumber.split('').join(' ')}',
              excludeSemantics: true,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(l10n.ridePlate, style: text.bodySmall),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: TurboSpacing.md, vertical: TurboSpacing.xs),
                  decoration: BoxDecoration(
                    border: Border.all(color: t.colors.controlBorder),
                    borderRadius: BorderRadius.circular(t.radiusInput),
                  ),
                  // Shrinks rather than overflows when text is scaled up a lot.
                  child: FittedBox(fit: BoxFit.scaleDown, child: Text(v.plateNumber, style: t.styles.monoPlate)),
                ),
              ],
            ),
            ),
          ),
      ],
    );
  }
}

class _Assigned extends ConsumerWidget {
  const _Assigned({required this.ride});

  final Ride ride;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    final arrived = ride.status == RideStatus.driverArrived;
    final tracking = ref.watch(trackingProvider(ride.id)).value;
    final messages = ref.watch(rideMessagesProvider(ride.id)).value ?? const <QuickMessage>[];
    final lastFromDriver = messages.where((m) => m.from == QuickMessageFromEnum.driver).lastOrNull;
    final eta = tracking?.etaSeconds ?? ride.pickupEtaSeconds;
    final pin = ride.pin;
    final stale = tracking != null && clock.now().difference(tracking.updatedAt) > const Duration(seconds: 60);

    String label(QuickMessageCode c) => switch (c) {
          QuickMessageCode.imHere => l10n.qmImHere,
          QuickMessageCode.runningLate => l10n.qmRunningLate,
          QuickMessageCode.atTheGate => l10n.qmAtTheGate,
          QuickMessageCode.cannotFindYou => l10n.qmCannotFindYou,
          QuickMessageCode.pleaseComeOut => l10n.qmPleaseComeOut,
          QuickMessageCode.onMyWay => l10n.qmOnMyWay,
        };

    return _Panel(
      map: _RideMap(ride, tracking: tracking),
      children: [
        if (arrived)
          TurboBanner(
            icon: Icons.check_circle_outline,
            message: l10n.rideDriverArrived,
            tone: StatusTone.success,
            liveRegion: true,
          )
        else
          Semantics(header: true, liveRegion: true, child: Text(l10n.rideDriverOnWay, style: text.titleLarge)),
        if (!arrived && eta != null) Text(l10n.rideEtaMinutes((eta / 60).ceil()), style: text.bodyMedium),
        if (stale)
          Padding(
            padding: const EdgeInsets.only(top: TurboSpacing.xs),
            child: Text(l10n.rideLocationDelayed, style: text.bodyMedium?.copyWith(color: t.colors.warning)),
          ),
        const SizedBox(height: TurboSpacing.md),
        if (pin != null) ...[
          Text(l10n.ridePinLabel, style: text.bodySmall),
          const SizedBox(height: TurboSpacing.xs),
          // Each digit is read on its own, so a screen reader says "Digit 1: 4".
          InnerPanel(
            child: TripPin(digits: pin, digitLabel: (i, d) => l10n.ridePinDigit(i, d)),
          ),
          const SizedBox(height: TurboSpacing.xs),
          Text(l10n.ridePinHint, style: text.bodySmall),
          const SizedBox(height: TurboSpacing.md),
        ],
        _DriverRow(ride: ride, subtitle: l10n.ridePickupAt(ride.pickup.label ?? '')),
        if (lastFromDriver != null)
          Padding(
            padding: const EdgeInsets.only(top: TurboSpacing.sm),
            child: Semantics(
              liveRegion: true,
              child: Text(l10n.rideDriverSaid(ride.driver?.firstName ?? '', label(lastFromDriver.code)), style: text.bodyMedium),
            ),
          ),
        const SizedBox(height: TurboSpacing.md),
        SizedBox(
          height: TurboSizes.minTap,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (final code in const [
                QuickMessageCode.imHere,
                QuickMessageCode.runningLate,
                QuickMessageCode.atTheGate,
                QuickMessageCode.pleaseComeOut,
              ])
                Padding(
                  padding: const EdgeInsets.only(right: TurboSpacing.sm),
                  child: TurboChip(
                    label: label(code),
                    onTap: () async {
                      try {
                        await ref.read(rideActionsProvider).sendMessage(ride.id, code);
                      } on ApiProblem {
                        if (context.mounted) showTurboToast(context, l10n.rideMessageFailed);
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: TurboSpacing.md),
        Row(
          children: [
            Expanded(
              child: TurboButton(
                label: l10n.rideShareTrip,
                variant: TurboButtonVariant.secondary,
                icon: Icons.ios_share,
                onPressed: () => context.push('/ride/${ride.id}/share'),
              ),
            ),
            const SizedBox(width: TurboSpacing.md),
            Expanded(
              child: TurboButton(
                label: l10n.rideSafety,
                variant: TurboButtonVariant.secondary,
                icon: Icons.shield_outlined,
                onPressed: () => context.push('/safety', extra: ride.id),
              ),
            ),
          ],
        ),
        const SizedBox(height: TurboSpacing.sm),
        TextButton(
          onPressed: () => _confirmCancel(context, ref, ride),
          child: Text(l10n.rideCancel, style: text.bodyLarge),
        ),
      ],
    );
  }
}

class _InTrip extends ConsumerWidget {
  const _InTrip({required this.ride});

  final Ride ride;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final tracking = ref.watch(trackingProvider(ride.id)).value;
    final eta = tracking?.etaSeconds;
    return _Panel(
      map: _RideMap(ride, tracking: tracking),
      children: [
        PhotoCard(
          asset: 'trip-status-trotro.jpg',
          height: 140,
          child: Text('${ride.pickup.label ?? ''} → ${ride.dropoff.label ?? ''}', style: text.titleMedium),
        ),
        const SizedBox(height: TurboSpacing.md),
        Row(
          children: [
            Expanded(child: Semantics(header: true, child: Text(l10n.rideInTripTitle, style: text.titleLarge))),
            Flexible(child: StatusChip(label: l10n.rideFareLocked(formatPesewas(ride.farePesewas)), icon: Icons.lock_outline)),
          ],
        ),
        if (eta != null) Text(l10n.rideArrivingIn((eta / 60).ceil()), style: text.bodyMedium),
        const SizedBox(height: TurboSpacing.md),
        _DriverRow(ride: ride),
        const SizedBox(height: TurboSpacing.md),
        Row(
          children: [
            Expanded(
              child: TurboButton(
                label: l10n.rideShareTrip,
                variant: TurboButtonVariant.secondary,
                icon: Icons.ios_share,
                onPressed: () => context.push('/ride/${ride.id}/share'),
              ),
            ),
            const SizedBox(width: TurboSpacing.md),
            Expanded(child: HoldToSos(rideId: ride.id)),
          ],
        ),
        const SizedBox(height: TurboSpacing.md),
        TurboButton(
          label: l10n.rideSafety,
          icon: Icons.shield_outlined,
          onPressed: () => context.push('/safety', extra: ride.id),
        ),
        const SizedBox(height: TurboSpacing.sm),
        // The server refuses to cancel once the trip has started; say what to do.
        Text(l10n.rideNoCancelNote, style: text.bodySmall, textAlign: TextAlign.center),
      ],
    );
  }
}

class _Done extends ConsumerStatefulWidget {
  const _Done({required this.ride});

  final Ride ride;

  @override
  ConsumerState<_Done> createState() => _DoneState();
}

class _DoneState extends ConsumerState<_Done> {
  int _stars = 0;
  final _comment = TextEditingController();
  bool _sending = false;
  bool _rated = false;
  String? _error;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _rate() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      await ref.read(rideActionsProvider).rate(widget.ride.id, _stars, _comment.text);
      if (mounted) setState(() => _rated = true);
    } on ApiProblem {
      if (mounted) setState(() => _error = l10n.rideRateFailed);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    final ride = widget.ride;
    final minutes = ride.startedAt != null && ride.completedAt != null ? ride.completedAt!.difference(ride.startedAt!).inMinutes : 0;
    final km = (ride.routeDistanceMeters / 1000).toStringAsFixed(1);
    final charged = ride.payment.chargedPesewas > 0 ? ride.payment.chargedPesewas : ride.farePesewas;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(TurboSpacing.xl),
            children: [
              const Center(child: BadgeIcon(icon: Icons.check)),
              const SizedBox(height: TurboSpacing.lg),
              Semantics(header: true, child: Text(l10n.rideDoneTitle, style: text.headlineMedium, textAlign: TextAlign.center)),
              const SizedBox(height: TurboSpacing.lg),
              TurboCard(
                child: Column(
                  children: [
                    Row(children: [
                      Expanded(child: Text(l10n.rideFareCharged, style: text.bodyMedium)),
                      MoneyText(charged, style: text.titleLarge),
                    ]),
                    const SizedBox(height: TurboSpacing.md),
                    Row(children: [
                      Expanded(child: Text(l10n.rideDistanceTime, style: text.bodyMedium)),
                      Text(l10n.rideDistanceTimeValue(km, minutes), style: text.bodyLarge),
                    ]),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () => context.push('/ride/${ride.id}/receipt'),
                        child: Text(l10n.rideViewReceipt, style: text.bodyMedium?.copyWith(color: t.colors.accentText)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TurboSpacing.xl),
              if (_rated)
                Semantics(liveRegion: true, child: Text(l10n.rideRated, style: text.bodyLarge))
              else ...[
                Semantics(header: true, child: Text(l10n.rideRateTitle(ride.driver?.firstName ?? ''), style: text.titleLarge)),
                const SizedBox(height: TurboSpacing.sm),
                Row(
                  children: [
                    for (var i = 1; i <= 5; i++)
                      Semantics(
                        button: true,
                        selected: _stars >= i,
                        label: '$i',
                        child: IconButton(
                          constraints: const BoxConstraints(minWidth: TurboSizes.minTap, minHeight: TurboSizes.minTap),
                          onPressed: () => setState(() => _stars = i),
                          icon: Icon(_stars >= i ? Icons.star : Icons.star_border, color: t.colors.accentText),
                        ),
                      ),
                  ],
                ),
                TurboTextField(label: l10n.rideRateComment, controller: _comment),
                if (_error != null) ...[
                  const SizedBox(height: TurboSpacing.sm),
                  Text(_error!, style: text.bodyMedium?.copyWith(color: t.colors.danger)),
                ],
                const SizedBox(height: TurboSpacing.md),
                TurboButton(
                  label: l10n.rideRateSubmit,
                  variant: TurboButtonVariant.secondary,
                  loading: _sending,
                  onPressed: _stars == 0 ? null : _rate,
                ),
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(TurboSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TurboButton(label: l10n.rideDone, onPressed: () => context.go('/home')),
              TextButton(
                onPressed: () => context.push('/support/new', extra: ride.id),
                child: Text(l10n.rideReport, style: text.bodyMedium?.copyWith(color: t.colors.accentText)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Cancelled extends ConsumerWidget {
  const _Cancelled({required this.ride});

  final Ride ride;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    final c = ride.cancellation;
    final reason = c?.reasonCode;

    final (String title, String body) = switch (reason) {
      CancellationReasonCodeEnum.noDriverAvailable => (l10n.rideCancelledNoDriver, l10n.rideCancelledNoDriverBody),
      CancellationReasonCodeEnum.driverUnavailable || CancellationReasonCodeEnum.vehicleIssue => (l10n.rideCancelledDriver, l10n.rideCancelledDriverBody),
      CancellationReasonCodeEnum.riderNoShow => (l10n.rideCancelledNoShow, l10n.rideCancelledNoShowBody),
      CancellationReasonCodeEnum.serviceIssue || CancellationReasonCodeEnum.adminDecision => (l10n.rideCancelledService, l10n.rideCancelledServiceBody),
      _ => c?.by == CancellationByEnum.student
          ? (l10n.rideCancelledYou, l10n.rideCancelledYouBody)
          : (l10n.rideCancelledService, l10n.rideCancelledServiceBody),
    };

    // What happened to the money, in the server's own numbers.
    final p = ride.payment;
    final money = p.refundedPesewas > 0
        ? l10n.rideRefunded(formatPesewas(p.refundedPesewas))
        : p.chargedPesewas > 0
            ? l10n.rideCharged(formatPesewas(p.chargedPesewas))
            : l10n.rideNotCharged;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(TurboSpacing.xl),
            children: [
              const Center(child: HeroIcon(art: TurboArt.oncomingTaxi)),
              const SizedBox(height: TurboSpacing.lg),
              Semantics(header: true, liveRegion: true, child: Text(title, style: text.headlineMedium, textAlign: TextAlign.center)),
              const SizedBox(height: TurboSpacing.md),
              Text(body, style: text.bodyLarge, textAlign: TextAlign.center),
              const SizedBox(height: TurboSpacing.lg),
              TurboCard(
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: t.colors.success),
                    const SizedBox(width: TurboSpacing.md),
                    Expanded(child: Semantics(liveRegion: true, child: Text(money, style: text.bodyLarge))),
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
              if (reason == CancellationReasonCodeEnum.noDriverAvailable)
                TurboButton(label: l10n.rideTryAgain, onPressed: () => context.go('/home/destination')),
              const SizedBox(height: TurboSpacing.sm),
              TurboButton(
                label: l10n.rideBackHome,
                large: reason != CancellationReasonCodeEnum.noDriverAvailable,
                variant: reason == CancellationReasonCodeEnum.noDriverAvailable ? TurboButtonVariant.secondary : TurboButtonVariant.primary,
                onPressed: () => context.go('/home'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ReceiptScreen extends ConsumerWidget {
  const ReceiptScreen({super.key, required this.rideId});

  final String rideId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final receipt = ref.watch(receiptProvider(rideId));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.receiptTitle)),
      body: SafeArea(
        child: receipt.when(
          loading: () => const LoadingState(),
          error: (_, _) => ErrorState(message: l10n.rideLoadFailed, onRetry: () => ref.invalidate(receiptProvider(rideId))),
          data: (r) => ListView(
            padding: const EdgeInsets.all(TurboSpacing.xl),
            children: [
              Text(l10n.receiptNumber(r.receiptNumber), style: text.titleLarge),
              Text(DateFormat('d MMM yyyy, HH:mm').format(r.issuedAt.toUtc()), style: text.bodySmall),
              const SizedBox(height: TurboSpacing.lg),
              if (r.pickup != null) Text(r.pickup!.label ?? '', style: text.bodyLarge),
              if (r.dropoff != null) Text(r.dropoff!.label ?? '', style: text.bodyLarge),
              const SizedBox(height: TurboSpacing.lg),
              for (final line in r.lines)
                Padding(
                  padding: const EdgeInsets.only(bottom: TurboSpacing.sm),
                  child: Row(children: [
                    Expanded(child: Text(line.label, style: text.bodyLarge)),
                    MoneyText(line.amountPesewas),
                  ]),
                ),
              const Divider(),
              Row(children: [
                Expanded(child: Text(l10n.receiptTotal, style: text.titleLarge)),
                MoneyText(r.totalPesewas, style: text.titleLarge),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
