import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../l10n/app_localizations.dart';
import '../home/service_area.dart';
import 'transaction_row.dart';
import 'wallet_providers.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    final wallet = ref.watch(walletProvider);
    final recent = ref.watch(recentTransactionsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.walletTitle)),
      body: SafeArea(
        child: wallet.when(
          loading: () => const LoadingState(),
          error: (_, _) => ErrorState(
            message: l10n.walletLoadFailed,
            onRetry: () => ref.invalidate(walletProvider),
          ),
          data: (w) {
            final owed = w.owedPesewas ?? 0;
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(walletProvider);
                ref.invalidate(recentTransactionsProvider);
                try {
                  await ref.read(walletProvider.future);
                } catch (_) {}
              },
              child: ListView(
                padding: const EdgeInsets.all(TurboSpacing.xl),
                children: [
                  TurboCard(
                    padding: const EdgeInsets.all(TurboSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.walletAvailable, style: text.bodyMedium),
                        const SizedBox(height: TurboSpacing.sm),
                        Semantics(
                          label: '${l10n.walletAvailable} ${formatPesewas(w.availablePesewas)}',
                          excludeSemantics: true,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              formatPesewas(w.availablePesewas),
                              style: text.displayLarge,
                            ),
                          ),
                        ),
                        if (w.reservedPesewas > 0) ...[
                          const SizedBox(height: TurboSpacing.xs),
                          Text(l10n.walletHeld(formatPesewas(w.reservedPesewas)), style: text.bodyLarge),
                        ],
                        if (owed > 0) ...[
                          const SizedBox(height: TurboSpacing.md),
                          Row(
                            children: [
                              Icon(Icons.error_outline, color: t.colors.danger),
                              const SizedBox(width: TurboSpacing.sm),
                              Expanded(
                                child: Text(
                                  l10n.walletOwed(formatPesewas(owed)),
                                  style: text.bodyLarge?.copyWith(color: t.colors.danger),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: TurboSpacing.xl),
                        TurboButton(
                          label: l10n.walletTopUp,
                          large: true,
                          icon: Icons.add,
                          onPressed: () => context.push('/wallet/topup'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TurboSpacing.xxl),
                  Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          header: true,
                          child: Text(
                            l10n.walletRecent,
                            style: text.titleLarge,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/wallet/transactions'),
                        child: Text(
                          l10n.walletSeeAll,
                          style: text.bodyMedium?.copyWith(
                            color: t.colors.accentText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  recent.when(
                    loading: () => const LoadingState(rows: 2),
                    error: (_, _) => ErrorState(
                      message: l10n.walletLoadFailed,
                      onRetry: () => ref.invalidate(recentTransactionsProvider),
                    ),
                    data: (items) => items.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: TurboSpacing.xl,
                            ),
                            child: EmptyState(
                              icon: Icons.receipt_long_outlined,
                              message: l10n.walletNoTransactions,
                            ),
                          )
                        : Column(
                            children: [
                              for (final tx in items) TransactionRow(tx),
                            ],
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
