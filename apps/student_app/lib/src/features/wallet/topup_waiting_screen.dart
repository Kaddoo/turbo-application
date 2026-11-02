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
      required TurboArt art,
      required String title,
      required String body,
      required List<Widget> actions,
      Widget? extra,
    }) => ListView(
      padding: const EdgeInsets.all(TurboSpacing.xl),
      children: [
        const SizedBox(height: TurboSpacing.xxl),
        Center(child: HeroIcon(art: art)),
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
        if (body.isNotEmpty) Text(body, style: text.bodyLarge, textAlign: TextAlign.center),
        if (extra != null) ...[const SizedBox(height: TurboSpacing.lg), extra],
        const SizedBox(height: TurboSpacing.xxl),
        ...actions,
      ],
    );

    final Widget body;
    switch (flow.topup.status) {
      case TopupStatusEnum.succeeded:
        // One light tap when the money lands.
        body = HapticOnShow(
          kind: TurboHapticKind.success,
          child: result(
            art: TurboArt.checkMarkButton,
            title: l10n.topupSuccessTitle,
            body: l10n.topupSuccessAdded(formatPesewas(flow.topup.amountPesewas)),
            extra: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (wallet != null) ...[
                    Expanded(
                      child: BentoTile(
                        label: l10n.topupTileBalance,
                        title: formatPesewas(wallet.availablePesewas),
                        tone: BentoTone.lime,
                        money: true,
                      ),
                    ),
                    const SizedBox(width: TurboSpacing.md),
                  ],
                  Expanded(
                    child: BentoTile(
                      label: l10n.topupTileReference,
                      title: flow.topup.reference,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TurboButton(label: l10n.topupDone, onPressed: _leave),
            ],
          ),
        );
      case TopupStatusEnum.failed:
        body = result(
          art: TurboArt.warning,
          title: l10n.topupFailedTitle,
          body: l10n.topupFailedBody,
          actions: [
            TurboButton(
              label: l10n.topupTryAgain,
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
            art: TurboArt.hourglassNotDone,
            title: l10n.topupSlowTitle,
            body: l10n.topupSlowBody,
            extra: Center(
              child: StatusChip(
                label: l10n.topupPendingChip(formatPesewas(flow.topup.amountPesewas)),
                icon: Icons.schedule,
                tone: StatusTone.warning,
              ),
            ),
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
          // The two buttons stay pinned at the bottom, so Check status is always in reach.
          body = Column(
            children: [
              Expanded(
                child: ListView(
            padding: const EdgeInsets.all(TurboSpacing.xl),
            children: [
              const Center(child: HeroIcon(art: TurboArt.mobilePhone)),
              const SizedBox(height: TurboSpacing.lg),
              Semantics(
                header: true,
                liveRegion: true,
                child: Text(l10n.topupWaitTitle, style: text.headlineMedium, textAlign: TextAlign.center),
              ),
              const SizedBox(height: TurboSpacing.md),
              // The time left, big and in the mono face, with what is being approved.
              Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  spacing: TurboSpacing.sm,
                  children: [
                    Text(
                      '${(left ~/ 60).toString().padLeft(2, '0')}:${(left % 60).toString().padLeft(2, '0')}',
                      style: t.styles.monoCountdown.copyWith(color: t.colors.accentText),
                    ),
                    Text(
                      l10n.topupWaitLeftAmount(formatPesewas(flow.topup.amountPesewas)),
                      style: text.bodyMedium,
                    ),
                  ],
                ),
              ),
              if (flow.topup.checkout?.message != null) ...[
                const SizedBox(height: TurboSpacing.md),
                Text(flow.topup.checkout!.message!, style: text.bodyLarge),
              ],
              const SizedBox(height: TurboSpacing.xl),
              TurboCard(
                child: Column(
                  children: [
                    for (final (i, step) in [
                      l10n.topupStep1,
                      l10n.topupStep2,
                      l10n.topupStep3,
                    ].indexed)
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: i == 2 ? 0 : TurboSpacing.md,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: TurboSpacing.md,
                              backgroundColor: t.colors.accent,
                              child: Text('${i + 1}', style: text.labelMedium?.copyWith(color: t.colors.onAccent)),
                            ),
                            const SizedBox(width: TurboSpacing.md),
                            Expanded(child: Text(step, style: text.bodyLarge)),
                          ],
                        ),
                      ),
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
              const SizedBox(height: TurboSpacing.md),
              Text(l10n.topupNeverPin(t.brand.appName), style: text.bodySmall, textAlign: TextAlign.center),
            ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(TurboSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TurboButton(
                      label: l10n.topupCheckStatus,
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
                ),
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
