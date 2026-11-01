import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../core/problem_messages.dart';
import '../../l10n/app_localizations.dart';
import 'transaction_row.dart';
import 'wallet_providers.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(transactionsProvider);
    final controller = ref.read(transactionsProvider.notifier);

    String label(TransactionType? type) => switch (type) {
      null => l10n.navWallet,
      TransactionType.topup => l10n.txTopUp,
      TransactionType.rideCharge => l10n.txRide,
      TransactionType.refund => l10n.txRefund,
      TransactionType.adjustment => l10n.txAdjustment,
      _ => l10n.txHeld,
    };

    const filters = <TransactionType?>[
      null,
      TransactionType.topup,
      TransactionType.rideCharge,
      TransactionType.refund,
      TransactionType.adjustment,
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.transactionsTitle)),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: TurboSizes.primaryAction,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: TurboSpacing.lg,
                  vertical: TurboSpacing.sm,
                ),
                children: [
                  for (final f in filters)
                    Padding(
                      padding: const EdgeInsets.only(right: TurboSpacing.sm),
                      child: ChoiceChip(
                        label: Text(
                          f == null ? l10n.transactionsTitle : label(f),
                        ),
                        selected: controller.filter == f,
                        onSelected: (_) => controller.setFilter(f),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: state.when(
                loading: () => const LoadingState(),
                error: (e, _) => ErrorState(
                  message: e is ApiProblem
                      ? problemMessage(l10n, e)
                      : l10n.walletLoadFailed,
                  onRetry: () => controller.setFilter(controller.filter),
                ),
                data: (s) => s.items.isEmpty
                    ? EmptyState(
                        icon: Icons.receipt_long_outlined,
                        message: l10n.walletNoTransactions,
                      )
                    : ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TurboSpacing.lg,
                        ),
                        children: [
                          ..._byDay(context, l10n, s.items),
                          if (s.hasMore)
                            Padding(
                              padding: const EdgeInsets.all(TurboSpacing.lg),
                              child: TurboButton(
                                label: l10n.transactionsLoadMore,
                                variant: TurboButtonVariant.secondary,
                                loading: s.loadingMore,
                                onPressed: controller.more,
                              ),
                            ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Entries under a heading for their day: Today, Yesterday, then the date.
List<Widget> _byDay(BuildContext context, AppLocalizations l10n, List<WalletTransaction> items) {
  final text = Theme.of(context).textTheme;
  final today = DateUtils.dateOnly(clock.now().toUtc());
  String heading(DateTime d) {
    final days = today.difference(DateUtils.dateOnly(d.toUtc())).inDays;
    if (days == 0) return l10n.txToday;
    if (days == 1) return l10n.txYesterday;
    return DateFormat('d MMM').format(d.toUtc());
  }

  final out = <Widget>[];
  String? last;
  for (final tx in items) {
    final h = heading(tx.createdAt);
    if (h != last) {
      last = h;
      out.add(
        Padding(
          padding: const EdgeInsets.only(top: TurboSpacing.md, bottom: TurboSpacing.xs),
          child: Semantics(header: true, child: Text(h, style: text.bodySmall)),
        ),
      );
    }
    out.add(TransactionRow(tx));
  }
  return out;
}
