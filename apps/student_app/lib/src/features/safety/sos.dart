import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import '../home/location_service.dart';

/// Ghana's national emergency number. Campus security's number has to come
/// from Turbo (see CONTRACT_REQUESTS.md, CR-3).
const emergencyNumber = '112';

Future<void> callNumber(String number) => launchUrl(Uri(scheme: 'tel', path: number));

/// Sends an SOS with the student's position and ride. Throws [ApiProblem], or
/// an [ApiProblem] with code `no_location` when there is no position to send.
class SosService {
  SosService(this.ref);

  final Ref ref;

  Future<Incident> raise({String? rideId}) async {
    final here = (await ref.read(locationServiceProvider).current(ask: false)).point;
    if (here == null) throw const ApiProblem(code: 'no_location', title: '');
    try {
      final response = await ref.read(clientProvider).api.getSafetyApi().raiseSos(
            sosRequest: SosRequest(rideId: rideId, location: here),
          );
      return response.data!;
    } catch (e) {
      throw problemOf(e);
    }
  }
}

final sosServiceProvider = Provider<SosService>(SosService.new);

/// Hold for three seconds to send an SOS. Letting go sooner sends nothing.
class HoldToSos extends ConsumerStatefulWidget {
  const HoldToSos({super.key, this.rideId, this.holdFor = const Duration(seconds: 3)});

  final String? rideId;
  final Duration holdFor;

  @override
  ConsumerState<HoldToSos> createState() => _HoldToSosState();
}

class _HoldToSosState extends ConsumerState<HoldToSos> with SingleTickerProviderStateMixin {
  late final AnimationController _hold = AnimationController(vsync: this, duration: widget.holdFor)
    ..addStatusListener((s) {
      if (s == AnimationStatus.completed) _send();
    });
  bool _sending = false;

  @override
  void dispose() {
    _hold.dispose();
    super.dispose();
  }

  void _down() {
    if (_sending) return;
    TurboHaptics.warning();
    _hold.forward(from: 0);
  }

  void _up() {
    if (_hold.status != AnimationStatus.completed) _hold.reset();
  }

  Future<void> _send() async {
    setState(() => _sending = true);
    TurboHaptics.error();
    String? failure;
    try {
      await ref.read(sosServiceProvider).raise(rideId: widget.rideId);
    } on ApiProblem catch (p) {
      failure = p.code;
    }
    if (!mounted) return;
    setState(() => _sending = false);
    _hold.reset();
    await showTurboSheet<void>(
      context: context,
      builder: (_) => _SosResult(failure: failure),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      label: l10n.sosHold,
      hint: l10n.sosHoldSeconds,
      child: Listener(
        onPointerDown: (_) => _down(),
        onPointerUp: (_) => _up(),
        onPointerCancel: (_) => _up(),
        child: AnimatedBuilder(
          animation: _hold,
          builder: (context, _) {
            final left = (widget.holdFor.inSeconds * (1 - _hold.value)).ceil();
            final holding = _hold.isAnimating;
            return ConstrainedBox(
              constraints: const BoxConstraints(minHeight: TurboSizes.primaryAction),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(t.radiusFull),
                  border: Border.all(color: t.colors.danger, width: TurboSizes.accentBorderWidth),
                  color: Color.lerp(t.colors.background, t.colors.danger, _hold.value * 0.6),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: TurboSpacing.lg),
                    child: Text(
                      _sending ? l10n.sosAlerted : (holding ? l10n.sosSecondsLeft(left) : l10n.sosHold),
                      style: text.labelLarge?.copyWith(color: holding ? t.colors.textPrimary : t.colors.danger),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SosResult extends StatelessWidget {
  const _SosResult({this.failure});

  final String? failure;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    final ok = failure == null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(ok ? Icons.check_circle_outline : Icons.error_outline, color: ok ? t.colors.success : t.colors.danger, size: TurboSizes.iconLg),
        const SizedBox(height: TurboSpacing.md),
        Semantics(liveRegion: true, header: true, child: Text(ok ? l10n.sosAlerted : l10n.sosFailed, style: text.titleLarge)),
        const SizedBox(height: TurboSpacing.sm),
        Text(
          ok ? l10n.sosAlertedBody(t.brand.appName) : (failure == 'no_location' ? l10n.sosNoLocation : l10n.sosFailedBody),
          style: text.bodyLarge,
        ),
        const SizedBox(height: TurboSpacing.xl),
        if (!ok)
          Padding(
            padding: const EdgeInsets.only(bottom: TurboSpacing.md),
            child: TurboButton(
              label: l10n.sosCall(emergencyNumber),
              variant: TurboButtonVariant.destructive,
              large: true,
              onPressed: () => callNumber(emergencyNumber),
            ),
          ),
        TurboButton(label: l10n.sosDismiss, variant: TurboButtonVariant.secondary, onPressed: () => Navigator.of(context).pop()),
      ],
    );
  }
}
