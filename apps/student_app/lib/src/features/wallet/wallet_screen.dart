import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_api/turbo_api.dart' show Wallet;
import 'package:turbo_ui/turbo_ui.dart';

import '../../core/me.dart';
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
    final name = switch (ref.watch(meProvider).value) {
      MeLoaded(:final student) => student.fullName ?? '',
      _ => '',
    };

    return Scaffold(
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
                padding: const EdgeInsets.all(TurboSpacing.screen),
                children: [
                  Row(
                    children: [
                      Expanded(child: Semantics(header: true, child: Text(l10n.walletTitle, style: text.headlineMedium))),
                      TurboAvatar(name: name.isEmpty ? l10n.walletTitle : name),
                    ],
                  ),
                  const SizedBox(height: TurboSpacing.lg),
                  _BalanceCard(wallet: w, owed: owed, name: name),
                  if (owed > 0) ...[
                    const SizedBox(height: TurboSpacing.md),
                    TurboBanner(
                      icon: Icons.error_outline,
                      message: l10n.walletOwed(formatPesewas(owed)),
                      tone: StatusTone.danger,
                    ),
                  ],
                  const SizedBox(height: TurboSpacing.md),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: BentoTile(
                            label: l10n.walletTileBalance,
                            title: formatPesewas(w.balancePesewas),
                            money: true,
                          ),
                        ),
                        const SizedBox(width: TurboSpacing.md),
                        Expanded(
                          child: BentoTile(
                            label: l10n.walletTileHeld,
                            title: formatPesewas(w.reservedPesewas),
                            money: true,
                            trailing: const TurboArtImage(TurboArt.locked),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TurboSpacing.lg),
                  TurboButton(
                    label: l10n.walletTopUp,
                    icon: Icons.add,
                    onPressed: () => context.push('/wallet/topup'),
                  ),
                  const SizedBox(height: TurboSpacing.xxl),
                  Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          header: true,
                          child: Text(
                            l10n.walletRecent,
                            style: text.titleSmall,
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

/// The balance as a lime card (dark while money is owed): what can be spent, and what is held for a ride.
class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.wallet, required this.owed, required this.name});

  final Wallet wallet;
  final int owed;
  final String name;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    final lime = owed == 0;
    final fore = lime ? t.colors.onAccent : t.colors.textPrimary;
    final sub = lime ? t.colors.onAccent.withValues(alpha: 0.7) : t.colors.textSecondary;
    return Container(
      padding: const EdgeInsets.all(TurboSpacing.xl),
      decoration: BoxDecoration(
        color: lime ? t.colors.accent : t.colors.surface,
        border: lime ? null : Border.all(color: t.colors.border),
        borderRadius: BorderRadius.circular(t.radiusPanel),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.brand.wordmark, style: t.styles.emphasis.copyWith(color: fore)),
          const SizedBox(height: TurboSpacing.lg),
          Text(l10n.walletAvailable, style: text.bodySmall?.copyWith(color: sub)),
          const SizedBox(height: TurboSpacing.xs),
          Semantics(
            label: '${l10n.walletAvailable} ${formatPesewas(wallet.availablePesewas)}',
            excludeSemantics: true,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(formatPesewas(wallet.availablePesewas), style: text.displayLarge?.copyWith(color: fore)),
            ),
          ),
          if (name.isNotEmpty) ...[
            const SizedBox(height: TurboSpacing.lg),
            Text(name.toUpperCase(), style: t.styles.monoCardName.copyWith(color: sub), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ],
      ),
    );
  }
}
