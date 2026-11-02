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

    // The four filters of the design. Adjustments and reversals show under All.
    final filters = <(TransactionType?, String)>[
      (null, l10n.txFilterAll),
      (TransactionType.topup, l10n.txFilterTopups),
      (TransactionType.rideCharge, l10n.txFilterRides),
      (TransactionType.refund, l10n.txFilterRefunds),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.transactionsTitle)),
      body: SafeArea(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: TurboSpacing.lg,
                vertical: TurboSpacing.sm,
              ),
              child: Row(
                children: [
                  for (final (f, name) in filters)
                    Padding(
                      padding: const EdgeInsets.only(right: TurboSpacing.sm),
                      child: TurboChip(
                        label: name,
                        selected: controller.filter == f,
                        onTap: () => controller.setFilter(f),
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
