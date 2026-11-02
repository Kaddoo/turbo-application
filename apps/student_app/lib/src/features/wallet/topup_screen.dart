import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../core/auth_draft.dart';
import '../../core/me.dart';
import '../../core/problem_messages.dart';
import '../../l10n/app_localizations.dart';
import 'amount.dart';
import 'wallet_providers.dart';

/// Pick an amount and pay. [suggested] pre-fills the amount, for example the
/// shortfall on a quote.
class TopupScreen extends ConsumerStatefulWidget {
  const TopupScreen({super.key, this.suggested});

  final int? suggested;

  @override
  ConsumerState<TopupScreen> createState() => _TopupScreenState();
}

class _TopupScreenState extends ConsumerState<TopupScreen> {
  final _custom = TextEditingController();
  int? _chip;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final s = widget.suggested;
    if (s != null) {
      if (topupChipsPesewas.contains(s)) {
        _chip = s;
      } else {
        _custom.text =
            '${s ~/ 100}${s % 100 == 0 ? '' : '.${(s % 100).toString().padLeft(2, '0')}'}';
      }
    }
  }

  @override
  void dispose() {
    _custom.dispose();
    super.dispose();
  }

  int? get _amount =>
      _custom.text.trim().isNotEmpty ? parsePesewas(_custom.text) : _chip;

  bool get _inRange =>
      _amount != null &&
      _amount! >= topupMinPesewas &&
      _amount! <= topupMaxPesewas;

  Future<void> _pay() async {
    final l10n = AppLocalizations.of(context);
    final amount = _amount;
    if (amount == null || !_inRange) {
      setState(
        () => _error = l10n.topupAmountRange(
          formatPesewas(topupMinPesewas),
          formatPesewas(topupMaxPesewas),
        ),
      );
      return;
    }
    final controller = ref.read(topupProvider.notifier);
    if (controller.hasPending) {
      final another = await showTurboConfirm(
        context: context,
        title: l10n.topupPendingTitle,
        message: l10n.topupPendingBody,
        confirmLabel: l10n.topupPendingAnother,
      );
      if (!another || !mounted) return;
      controller.clear();
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await controller.start(amount);
      if (mounted) context.pushReplacement('/wallet/topup/waiting');
    } on ApiProblem catch (p) {
      if (mounted) setState(() => _error = problemMessage(l10n, p));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final phone = switch (ref.watch(meProvider).value) {
      MeLoaded(:final student) => displayPhone(student.phone),
      _ => null,
    };
    final min = formatPesewas(topupMinPesewas),
        max = formatPesewas(topupMaxPesewas);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(TurboSpacing.screen, TurboSpacing.md, TurboSpacing.screen, 0),
              child: Row(
                children: [
                  TurboIconButton(icon: Icons.arrow_back, label: l10n.back, onPressed: () => context.pop()),
                  Expanded(
                    child: Semantics(header: true, child: Text(l10n.topupTitle, textAlign: TextAlign.center, style: text.titleMedium)),
                  ),
                  const SizedBox.square(dimension: TurboSizes.iconButton),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(TurboSpacing.screen),
                children: [
                  Semantics(
                    header: true,
                    child: Text(l10n.topupAmount, style: text.headlineMedium),
                  ),
                  const SizedBox(height: TurboSpacing.md),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: TurboSpacing.sm,
                    crossAxisSpacing: TurboSpacing.sm,
                    childAspectRatio: MediaQuery.textScalerOf(context).scale(1) > 1.3 ? 1.6 : 2.4,
                    children: [
                      for (final chip in topupChipsPesewas)
                        _AmountTile(
                          label: formatPesewas(chip),
                          selected: _chip == chip && _custom.text.trim().isEmpty,
                          onTap: () => setState(() {
                            _chip = chip;
                            _custom.clear();
                            _error = null;
                          }),
                        ),
                    ],
                  ),
                  const SizedBox(height: TurboSpacing.lg),
                  TurboTextField(
                    label: l10n.topupCustom,
                    controller: _custom,
                    helper: l10n.topupCustomHint(min, max),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    onChanged: (_) => setState(() {
                      _chip = null;
                      _error = null;
                    }),
                  ),
                  if (phone != null) ...[
                    const SizedBox(height: TurboSpacing.lg),
                    BentoTile(
                      label: l10n.topupNumberLabel,
                      title: phone,
                      trailing: const TurboArtImage(TurboArt.mobilePhone),
                    ),
                    const SizedBox(height: TurboSpacing.sm),
                    Text(l10n.topupPhoneNote(phone), style: text.bodyMedium),
                  ],
                  if (_error != null) ...[
                    const SizedBox(height: TurboSpacing.md),
                    TurboBanner(icon: Icons.error_outline, message: _error!, tone: StatusTone.danger, liveRegion: true),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TurboSpacing.screen),
              child: TurboButton(
                label: _amount != null && _inRange
                    ? l10n.topupPay(formatPesewas(_amount!))
                    : l10n.walletTopUp,
                loading: _busy,
                onPressed: _amount == null ? null : _pay,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountTile extends StatelessWidget {
  const _AmountTile({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      onTap: onTap,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(t.radiusListCard),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? t.colors.textPrimary : t.colors.surface,
            borderRadius: BorderRadius.circular(t.radiusListCard),
            border: Border.all(color: selected ? t.colors.textPrimary : t.colors.border),
          ),
          // Large text shrinks the amount to fit the tile instead of wrapping out of it.
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: TurboSpacing.sm),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: t.styles.monoMoneyLarge.copyWith(color: selected ? t.colors.background : t.colors.textPrimary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
