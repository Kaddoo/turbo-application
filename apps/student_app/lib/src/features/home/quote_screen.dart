import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../core/problem_messages.dart';
import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
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
      final response = await ref.read(clientProvider).api.getRidesApi().createQuote(
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

final quoteProvider = AsyncNotifierProvider.autoDispose<QuoteController, Quote>(QuoteController.new);

class QuoteScreen extends ConsumerStatefulWidget {
  const QuoteScreen({super.key});

  @override
  ConsumerState<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends ConsumerState<QuoteScreen> {
  Timer? _expiry;
  bool _renewed = false;

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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.quoteTitle),
        leading: BackButton(onPressed: () => context.go('/home/destination')),
      ),
      body: SafeArea(
        child: quote.when(
          loading: () => Semantics(label: l10n.quoteGettingPrice, child: const LoadingState()),
          error: (e, _) => ErrorState(
            message: e is ApiProblem && e.code != ApiProblem.unknown ? problemMessage(l10n, e) : l10n.quoteLoadFailed,
            onRetry: () => ref.read(quoteProvider.notifier).refresh(),
          ),
          data: (q) {
            if (!q.eligible) {
              return ListView(
                padding: const EdgeInsets.all(TurboSpacing.xl),
                children: [
                  Semantics(header: true, child: Text(l10n.quoteIneligibleTitle, style: text.headlineMedium)),
                  const SizedBox(height: TurboSpacing.lg),
                  // The server's own plain-language reasons, every one of them.
                  for (final r in q.reasons)
                    Padding(
                      padding: const EdgeInsets.only(bottom: TurboSpacing.md),
                      child: TurboCard(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline, color: t.colors.warning),
                            const SizedBox(width: TurboSpacing.md),
                            Expanded(child: Text(r.message, style: text.bodyLarge)),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: TurboSpacing.lg),
                  TurboButton(
                    label: l10n.quoteChangeLocation,
                    large: true,
                    onPressed: () => context.go('/home/destination'),
                  ),
                ],
              );
            }

            final fare = q.farePesewas ?? 0;
            final available = q.wallet.availablePesewas;
            final km = ((q.routeDistanceMeters ?? 0) / 1000).toStringAsFixed(1);
            final minutes = ((q.routeDurationSeconds ?? 0) / 60).ceil();
            final eta = q.pickupEtaSeconds == null ? null : (q.pickupEtaSeconds! / 60).ceil();
            return ListView(
              padding: const EdgeInsets.all(TurboSpacing.xl),
              children: [
                if (_renewed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: TurboSpacing.md),
                    child: Semantics(liveRegion: true, child: Text(l10n.quoteExpired, style: text.bodyMedium)),
                  ),
                Text(l10n.quoteRoute(km, minutes), style: text.bodyLarge),
                if (eta != null) Text(l10n.quotePickupEta(eta), style: text.bodyMedium),
                const SizedBox(height: TurboSpacing.xl),
                Semantics(
                  label: formatPesewas(fare),
                  excludeSemantics: true,
                  child: Text(
                    formatPesewas(fare),
                    style: text.headlineMedium?.copyWith(fontSize: text.headlineMedium!.fontSize! * 2),
                  ),
                ),
                Text(l10n.quoteFixed, style: text.bodyLarge),
                const SizedBox(height: TurboSpacing.xl),
                TurboCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.quoteWalletLine(formatPesewas(available), formatPesewas(available - fare)), style: text.bodyLarge),
                      const SizedBox(height: TurboSpacing.sm),
                      Text(l10n.quoteCancelRule, style: text.bodyMedium),
                      if (!q.wallet.sufficient) ...[
                        const SizedBox(height: TurboSpacing.md),
                        Row(
                          children: [
                            Icon(Icons.warning_amber, color: t.colors.warning),
                            const SizedBox(width: TurboSpacing.sm),
                            Expanded(
                              child: Text(l10n.quoteShortfall(formatPesewas(q.wallet.shortfallPesewas)), style: text.bodyMedium),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: TurboSpacing.xl),
                // Booking and top-up arrive in phase 2; the buttons are here so
                // the screen is complete, and are off until then.
                if (q.wallet.sufficient)
                  TurboButton(label: l10n.quoteBook(formatPesewas(fare)), large: true, onPressed: null)
                else
                  TurboButton(label: l10n.quoteTopUp(formatPesewas(q.wallet.shortfallPesewas)), large: true, onPressed: null),
                const SizedBox(height: TurboSpacing.sm),
                Text(l10n.quoteBookingSoon, style: text.bodySmall, textAlign: TextAlign.center),
              ],
            );
          },
        ),
      ),
    );
  }
}
