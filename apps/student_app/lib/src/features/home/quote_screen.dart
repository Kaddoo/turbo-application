import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../core/problem_messages.dart';
import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import '../wallet/wallet_providers.dart';
import '../ride/ride_providers.dart';
import 'map_view.dart';
import 'service_area.dart';
import 'trip_draft.dart';

/// Asks for a price for the chosen pickup and drop-off. The result is the
/// server's answer, unchanged: an eligible quote with a locked fare, or a plain
/// list of reasons.
class QuoteController extends AsyncNotifier<Quote> {
  @override
  Future<Quote> build() => _quote();

  Future<Quote> _quote() async {
    final draft = ref.read(tripDraftProvider);
    final pickup = draft.pickup, dropoff = draft.dropoff;
    if (pickup == null || dropoff == null) {
      throw const ApiProblem(code: ApiProblem.unknown, title: '');
    }
    try {
      final response = await ref
          .read(clientProvider)
          .api
          .getRidesApi()
          .createQuote(
            quoteRequest: QuoteRequest(pickup: pickup, dropoff: dropoff),
          );
      return response.data!;
    } catch (e) {
      throw problemOf(e);
    }
  }

  /// A new price, keeping the old one on screen while it loads.
  Future<void> refresh() async {
    state = await AsyncValue.guard(_quote);
  }
}

final quoteProvider = AsyncNotifierProvider.autoDispose<QuoteController, Quote>(
  QuoteController.new,
);

class QuoteScreen extends ConsumerStatefulWidget {
  const QuoteScreen({super.key});

  @override
  ConsumerState<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends ConsumerState<QuoteScreen> {
  Timer? _expiry;
  bool _renewed = false;
  bool _booking = false;
  String? _bookError;

  Future<void> _book(Quote q) async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _booking = true;
      _bookError = null;
    });
    try {
      final ride = await ref.read(rideActionsProvider).book(q.quoteId!);
      if (mounted) context.go('/ride/${ride.id}');
    } on ApiProblem catch (p) {
      if (!mounted) return;
      if (p.code == ProblemCode.activeRideExists.value) {
        // Already riding: open that ride instead of booking another.
        final active = await ref.refresh(activeRideProvider.future);
        if (active != null && mounted) {
          context.go('/ride/${active.id}');
          return;
        }
      }
      if (p.code == ProblemCode.quoteExpired.value ||
          p.code == ProblemCode.insufficientBalance.value) {
        // The price or the wallet moved; show the new numbers.
        await ref.read(quoteProvider.notifier).refresh();
        ref.invalidate(walletProvider);
      }
      if (mounted) setState(() => _bookError = problemMessage(l10n, p));
    } finally {
      if (mounted) setState(() => _booking = false);
    }
  }

  @override
  void dispose() {
    _expiry?.cancel();
    super.dispose();
  }

  /// When the price runs out, get a new one without asking.
  void _watchExpiry(Quote q) {
    _expiry?.cancel();
    final at = q.expiresAt;
    if (!q.eligible || at == null) return;
    final wait = at.difference(DateTime.now());
    _expiry = Timer(wait.isNegative ? Duration.zero : wait, () async {
      await ref.read(quoteProvider.notifier).refresh();
      if (mounted) setState(() => _renewed = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    final quote = ref.watch(quoteProvider);
    ref.listen(quoteProvider, (_, next) => next.whenData(_watchExpiry));
    // Once money lands, the wallet part of this price is out of date: ask again.
    ref.listen(topupProvider, (prev, next) {
      final done = next?.topup.status == TopupStatusEnum.succeeded;
      final was = prev?.topup.status == TopupStatusEnum.succeeded;
      if (done && !was) ref.read(quoteProvider.notifier).refresh();
    });

    final draft = ref.watch(tripDraftProvider);

    Widget pinned(Widget? error, Widget button) => Padding(
      padding: const EdgeInsets.all(TurboSpacing.screen),
      child: Column(mainAxisSize: MainAxisSize.min, children: [?error, button]),
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                TurboSpacing.screen,
                TurboSpacing.md,
                TurboSpacing.screen,
                0,
              ),
              child: Row(
                children: [
                  TurboIconButton(
                    icon: Icons.arrow_back,
                    label: l10n.back,
                    onPressed: () => context.go('/home/destination'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: quote.when(
                loading: () => Semantics(
                  label: l10n.quoteGettingPrice,
                  child: const LoadingState(),
                ),
                error: (e, _) => ErrorState(
                  message: e is ApiProblem && e.code != ApiProblem.unknown
                      ? problemMessage(l10n, e)
                      : l10n.quoteLoadFailed,
                  onRetry: () => ref.read(quoteProvider.notifier).refresh(),
                ),
                data: (q) {
                  if (!q.eligible) {
                    return Column(
                      children: [
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.all(TurboSpacing.screen),
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: HeroIcon(art: TurboArt.oncomingTaxi),
                              ),
                              const SizedBox(height: TurboSpacing.lg),
                              Semantics(
                                header: true,
                                child: Text(
                                  l10n.quoteIneligibleTitle,
                                  style: text.headlineMedium,
                                ),
                              ),
                              const SizedBox(height: TurboSpacing.lg),
                              // The server's own plain-language reasons, every one of them.
                              for (final r in q.reasons)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: TurboSpacing.md,
                                  ),
                                  child: TurboCard(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          color: t.colors.warning,
                                        ),
                                        const SizedBox(width: TurboSpacing.md),
                                        Expanded(
                                          child: Text(
                                            r.message,
                                            style: text.bodyLarge,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        pinned(
                          null,
                          TurboButton(
                            label: l10n.quoteChangeLocation,
                            onPressed: () => context.go('/home/destination'),
                          ),
                        ),
                      ],
                    );
                  }

                  final fare = q.farePesewas ?? 0;
                  final available = q.wallet.availablePesewas;
                  final km = ((q.routeDistanceMeters ?? 0) / 1000)
                      .toStringAsFixed(1);
                  final minutes = ((q.routeDurationSeconds ?? 0) / 60).ceil();
                  final eta = q.pickupEtaSeconds == null
                      ? null
                      : (q.pickupEtaSeconds! / 60).ceil();
                  final spec = MapSpec(
                    pickup: draft.pickup?.point,
                    dropoff: draft.dropoff?.point,
                    route: q.routePolyline,
                  );
                  Widget tile(String label, String title, TurboArt art, {BentoTone tone = BentoTone.surface}) => BentoTile(
                    label: label,
                    title: title,
                    money: true,
                    tone: tone,
                    trailing: TurboArtImage(art),
                  );
                  return Column(
                    children: [
                      // The route on the map, then the price in a sheet under it.
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(TurboSpacing.lg),
                          child: LayoutBuilder(
                            builder: (context, c) => HomeMap(height: c.maxHeight, spec: spec),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: t.colors.surface,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(t.radiusSheet)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.fromLTRB(
                                    TurboSpacing.screen,
                                    TurboSpacing.lg,
                                    TurboSpacing.screen,
                                    0,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (_renewed)
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: TurboSpacing.md),
                                          child: Semantics(
                                            liveRegion: true,
                                            child: Text(l10n.quoteExpired, style: text.bodyMedium),
                                          ),
                                        ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Semantics(
                                              header: true,
                                              child: Text(l10n.quoteFareLabel, style: text.bodySmall),
                                            ),
                                          ),
                                          StatusChip(
                                            label: l10n.quoteWontChange,
                                            icon: Icons.lock_outline,
                                            tone: StatusTone.success,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: TurboSpacing.xs),
                                      Semantics(
                                        label: '${formatPesewas(fare)}. ${l10n.quoteFixed}',
                                        excludeSemantics: true,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(formatPesewas(fare), style: text.displayLarge, maxLines: 1),
                                        ),
                                      ),
                                      Text(
                                        '${draft.pickup?.label ?? ''} → ${draft.dropoff?.label ?? ''}',
                                        style: text.bodyLarge,
                                      ),
                                      Text(l10n.quoteRoute(km, minutes), style: text.bodySmall),
                                      if (eta != null) Text(l10n.quotePickupEta(eta), style: text.bodySmall),
                                      const SizedBox(height: TurboSpacing.lg),
                                      IntrinsicHeight(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                              child: tile(l10n.quoteTileWallet, formatPesewas(available), TurboArt.moneyBag),
                                            ),
                                            const SizedBox(width: TurboSpacing.md),
                                            Expanded(
                                              child: q.wallet.sufficient
                                                  ? tile(l10n.quoteTileAfter, formatPesewas(available - fare), TurboArt.coin)
                                                  : tile(
                                                      l10n.quoteTileShort,
                                                      formatPesewas(q.wallet.shortfallPesewas),
                                                      TurboArt.warning,
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: TurboSpacing.sm),
                                      Semantics(
                                        liveRegion: !q.wallet.sufficient,
                                        child: Text(
                                          q.wallet.sufficient ? l10n.quoteCancelRule : l10n.quoteTopUpHint,
                                          style: text.bodySmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              pinned(
                                _bookError == null
                                    ? null
                                    : Padding(
                                        padding: const EdgeInsets.only(bottom: TurboSpacing.md),
                                        child: Semantics(
                                          liveRegion: true,
                                          child: Text(
                                            _bookError!,
                                            style: text.bodyMedium?.copyWith(color: t.colors.danger),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                q.wallet.sufficient
                                    ? TurboButton(
                                        label: l10n.quoteBook(formatPesewas(fare)),
                                        haptic: TurboHapticKind.confirm,
                                        loading: _booking,
                                        onPressed: () => _book(q),
                                      )
                                    : TurboButton(
                                        label: l10n.quoteTopUp(formatPesewas(q.wallet.shortfallPesewas)),
                                        onPressed: () async {
                                          await context.push('/wallet/topup', extra: q.wallet.shortfallPesewas);
                                          // Back from topping up: the wallet has changed, so ask again.
                                          ref.invalidate(walletProvider);
                                          await ref.read(quoteProvider.notifier).refresh();
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
