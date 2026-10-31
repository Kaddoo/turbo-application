import 'package:flutter/material.dart';

import '../format/money.dart';

/// Shows integer pesewas as cedis. The only way money is rendered.
class MoneyText extends StatelessWidget {
  const MoneyText(this.pesewas, {super.key, this.style, this.color});

  final int pesewas;
  final TextStyle? style;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final base = style ?? Theme.of(context).textTheme.bodyLarge;
    return Text(
      formatPesewas(pesewas),
      style: color == null ? base : base?.copyWith(color: color),
    );
  }
}
