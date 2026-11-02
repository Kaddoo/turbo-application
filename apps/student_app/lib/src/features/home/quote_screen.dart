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

    Widget stop(IconData icon, String? label) => Row(
      children: [
        Icon(icon, size: TurboSizes.iconSm, color: t.colors.textSecondary),
        const SizedBox(width: TurboSpacing.md),
        Expanded(child: Text(label ?? '', style: text.bodyLarge)),
      ],
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
                                child: HeroIcon(
                                  icon: Icons.location_off_outlined,
                                ),
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
                  return Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(TurboSpacing.screen),
                          children: [
                            if (_renewed)
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: TurboSpacing.md,
                                ),
                                child: Semantics(
                                  liveRegion: true,
                                  child: Text(
                                    l10n.quoteExpired,
                                    style: text.bodyMedium,
                                  ),
                                ),
                              ),
                            Row(
                              children: [
                                Expanded(
                                  child: Semantics(
                                    header: true,
                                    child: Text(
                                      l10n.quoteTitle,
                                      style: text.titleLarge,
                                    ),
                                  ),
                                ),
                                Text(
                                  l10n.quoteRoute(km, minutes),
                                  style: text.bodySmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: TurboSpacing.md),
                            Semantics(
                              label: formatPesewas(fare),
                              excludeSemantics: true,
                              child: Text(
                                formatPesewas(fare),
                                style: text.displayLarge,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.lock_outline,
                                  size: TurboSizes.iconSm,
                                  color: t.colors.textSecondary,
                                ),
                                const SizedBox(width: TurboSpacing.sm),
                                Expanded(
                                  child: Text(
                                    l10n.quoteFixed,
                                    style: text.bodyLarge,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: TurboSpacing.xl),
                            TurboCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  stop(Icons.trip_origin, draft.pickup?.label),
                                  const SizedBox(height: TurboSpacing.md),
                                  stop(
                                    Icons.flag_outlined,
                                    draft.dropoff?.label,
                                  ),
                                  if (eta != null) ...[
                                    const SizedBox(height: TurboSpacing.md),
                                    Text(
                                      l10n.quotePickupEta(eta),
                                      style: text.bodySmall,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: TurboSpacing.md),
                            TurboCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.account_balance_wallet_outlined,
                                        size: TurboSizes.iconSm,
                                        color: t.colors.textSecondary,
                                      ),
                                      const SizedBox(width: TurboSpacing.md),
                                      Expanded(
                                        child: Text(
                                          l10n.quoteWalletLine(
                                            formatPesewas(available),
                                            formatPesewas(available - fare),
                                          ),
                                          style: text.bodyLarge,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: TurboSpacing.sm),
                                  Text(
                                    l10n.quoteCancelRule,
                                    style: text.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            if (!q.wallet.sufficient) ...[
                              const SizedBox(height: TurboSpacing.md),
                              TurboBanner(
                                icon: Icons.warning_amber,
                                message: l10n.quoteShortfall(
                                  formatPesewas(q.wallet.shortfallPesewas),
                                ),
                                tone: StatusTone.warning,
                                liveRegion: true,
                              ),
                            ],
                          ],
                        ),
                      ),
                      pinned(
                        _bookError == null
                            ? null
                            : Padding(
                                padding: const EdgeInsets.only(
                                  bottom: TurboSpacing.md,
                                ),
                                child: Semantics(
                                  liveRegion: true,
                                  child: Text(
                                    _bookError!,
                                    style: text.bodyMedium?.copyWith(
                                      color: t.colors.danger,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                        q.wallet.sufficient
                            ? TurboButton(
                                label: l10n.quoteBook(formatPesewas(fare)),
                                loading: _booking,
                                onPressed: () => _book(q),
                              )
                            : TurboButton(
                                label: l10n.quoteTopUp(
                                  formatPesewas(q.wallet.shortfallPesewas),
                                ),
                                onPressed: () async {
                                  await context.push(
                                    '/wallet/topup',
                                    extra: q.wallet.shortfallPesewas,
                                  );
                                  // Back from topping up: the wallet has changed, so ask again.
                                  ref.invalidate(walletProvider);
                                  await ref
                                      .read(quoteProvider.notifier)
                                      .refresh();
                                },
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
