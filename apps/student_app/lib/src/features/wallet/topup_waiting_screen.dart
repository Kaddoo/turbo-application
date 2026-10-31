import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../l10n/app_localizations.dart';
import '../home/service_area.dart';
import 'wallet_providers.dart';

/// Shown after Pay. Polls by itself, can be checked by hand, and says plainly
/// when the answer is still unknown. A payment is never called failed unless
/// the server says so.
class TopupWaitingScreen extends ConsumerStatefulWidget {
  const TopupWaitingScreen({super.key});

  @override
  ConsumerState<TopupWaitingScreen> createState() => _TopupWaitingScreenState();
}

class _TopupWaitingScreenState extends ConsumerState<TopupWaitingScreen>
    with WidgetsBindingObserver {
  Timer? _tick;
  DateTime _now = clock.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = clock.now());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tick?.cancel();
    super.dispose();
  }

  /// Coming back from approving on the phone: ask at once.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(topupProvider.notifier).check();
    }
  }

  void _leave() {
    ref.read(topupProvider.notifier).clear();
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/wallet');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    final flow = ref.watch(topupProvider);
    final wallet = ref.watch(walletProvider).value;

    if (flow == null) {
      return Scaffold(
        body: SafeArea(child: ErrorState(onRetry: () => context.go('/wallet'))),
      );
    }

    Widget result({
      required IconData icon,
      required Color color,
      required String title,
      required String body,
      required List<Widget> actions,
    }) => ListView(
      padding: const EdgeInsets.all(TurboSpacing.xl),
      children: [
        const SizedBox(height: TurboSpacing.xxl),
        Icon(icon, size: TurboSizes.iconLg + TurboSpacing.xl, color: color),
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
        const SizedBox(height: TurboSpacing.md),
        Text(body, style: text.bodyLarge, textAlign: TextAlign.center),
        const SizedBox(height: TurboSpacing.xxl),
        ...actions,
      ],
    );

    final Widget body;
    switch (flow.topup.status) {
      case TopupStatusEnum.succeeded:
        body = result(
          icon: Icons.check_circle_outline,
          color: t.colors.success,
          title: l10n.topupSuccessTitle,
          body: wallet == null
              ? ''
              : l10n.topupSuccessBody(formatPesewas(wallet.availablePesewas)),
          actions: [
            TurboButton(label: l10n.topupDone, large: true, onPressed: _leave),
          ],
        );
      case TopupStatusEnum.failed:
        body = result(
          icon: Icons.error_outline,
          color: t.colors.danger,
          title: l10n.topupFailedTitle,
          body: l10n.topupFailedBody,
          actions: [
            TurboButton(
              label: l10n.topupTryAgain,
              large: true,
              onPressed: () {
                ref.read(topupProvider.notifier).clear();
                context.pushReplacement('/wallet/topup');
              },
            ),
            const SizedBox(height: TurboSpacing.md),
            TurboButton(
              label: l10n.topupLeave,
              variant: TurboButtonVariant.secondary,
              onPressed: _leave,
            ),
          ],
        );
      default:
        if (flow.timedOut) {
          body = result(
            icon: Icons.schedule,
            color: t.colors.warning,
            title: l10n.topupSlowTitle,
            body: l10n.topupSlowBody,
            actions: [
              TurboButton(
                label: l10n.topupCheckStatus,
                variant: TurboButtonVariant.secondary,
                loading: flow.checking,
                onPressed: () => ref.read(topupProvider.notifier).check(),
              ),
              const SizedBox(height: TurboSpacing.md),
              TurboButton(label: l10n.topupLeave, onPressed: _leave),
            ],
          );
        } else {
          final left =
              (TopupController.watchFor - _now.difference(flow.startedAt))
                  .inSeconds
                  .clamp(0, 999);
          body = ListView(
            padding: const EdgeInsets.all(TurboSpacing.xl),
            children: [
              const SizedBox(height: TurboSpacing.xl),
              Semantics(
                header: true,
                liveRegion: true,
                child: Text(l10n.topupWaitTitle, style: text.headlineMedium),
              ),
              if (flow.topup.checkout?.message != null) ...[
                const SizedBox(height: TurboSpacing.md),
                Text(flow.topup.checkout!.message!, style: text.bodyLarge),
              ],
              const SizedBox(height: TurboSpacing.xl),
              for (final (i, step) in [
                l10n.topupStep1,
                l10n.topupStep2,
                l10n.topupStep3,
              ].indexed)
                Padding(
                  padding: const EdgeInsets.only(bottom: TurboSpacing.md),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: TurboSpacing.md,
                        backgroundColor: t.colors.surface,
                        child: Text('${i + 1}', style: text.labelMedium),
                      ),
                      const SizedBox(width: TurboSpacing.md),
                      Expanded(child: Text(step, style: text.bodyLarge)),
                    ],
                  ),
                ),
              const SizedBox(height: TurboSpacing.lg),
              LinearProgressIndicator(
                value: left / TopupController.watchFor.inSeconds,
                color: t.colors.accentText,
                backgroundColor: t.colors.border,
              ),
              const SizedBox(height: TurboSpacing.sm),
              Text(l10n.topupWaitSeconds(left), style: text.bodySmall),
              const SizedBox(height: TurboSpacing.xl),
              TurboButton(
                label: l10n.topupCheckStatus,
                variant: TurboButtonVariant.secondary,
                loading: flow.checking,
                onPressed: () => ref.read(topupProvider.notifier).check(),
              ),
              const SizedBox(height: TurboSpacing.md),
              TurboButton(
                label: l10n.topupLeave,
                variant: TurboButtonVariant.secondary,
                onPressed: _leave,
              ),
            ],
          );
        }
    }

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SafeArea(child: body),
    );
  }
}
