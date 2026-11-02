import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../l10n/app_localizations.dart';

/// One wallet entry. Holds and releases are labelled, not shown as spending.
class TransactionRow extends StatelessWidget {
  const TransactionRow(this.tx, {super.key});

  final WalletTransaction tx;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = context.turbo;
    final (String label, TurboArt art) = switch (tx.type) {
      TransactionType.topup => (l10n.txTopUp, TurboArt.coin),
      TransactionType.rideHold => (l10n.txHeld, TurboArt.locked),
      TransactionType.rideRelease => (l10n.txReleased, TurboArt.key),
      TransactionType.rideCharge => (l10n.txRide, TurboArt.oncomingTaxi),
      TransactionType.refund => (l10n.txRefund, TurboArt.moneyBag),
      TransactionType.adjustment => (l10n.txAdjustment, TurboArt.creditCard),
      TransactionType.providerReversal => (l10n.txReversal, TurboArt.warning),
    };
    // Accra is UTC+0 all year, so no zone conversion is needed.
    final when = DateFormat('d MMM, HH:mm').format(tx.createdAt.toUtc());
    // Holds and releases move money between available and held; only real
    // balance changes are shown in a sign and colour-free way.
    final amount = tx.affectsBalance
        ? formatPesewas(tx.amountPesewas)
        : formatPesewas(tx.amountPesewas.abs());
    return TurboListRow(
      title: tx.description,
      subtitle: '$label · $when',
      leading: Container(
        width: TurboSizes.minTap,
        height: TurboSizes.minTap,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: t.colors.surface, borderRadius: BorderRadius.circular(t.radiusInput)),
        child: TurboArtImage(art, size: TurboSizes.iconLg - TurboSpacing.sm),
      ),
      trailing: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.35),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            amount,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: tx.affectsBalance && tx.amountPesewas > 0 ? t.colors.success : null,
                ),
          ),
        ),
      ),
    );
  }
}
