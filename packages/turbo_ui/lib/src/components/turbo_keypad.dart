import 'package:flutter/material.dart';

import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';

/// A 3 x 4 number pad for the driver's PIN screen: big pills, mono digits, delete at the bottom right.
class TurboKeypad extends StatelessWidget {
  const TurboKeypad({super.key, required this.onDigit, required this.onDelete, required this.deleteLabel, this.enabled = true});

  final ValueChanged<String> onDigit;
  final VoidCallback onDelete;
  final String deleteLabel;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    final c = t.colors;
    Widget key(String k) {
      if (k.isEmpty) return const SizedBox.shrink();
      final isDelete = k == '⌫';
      return Semantics(
        button: true,
        enabled: enabled,
        label: isDelete ? deleteLabel : k,
        excludeSemantics: true,
        onTap: enabled ? () => (isDelete ? onDelete() : onDigit(k)) : null,
        child: Material(
          color: c.surface,
          shape: StadiumBorder(side: BorderSide(color: c.border)),
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: enabled ? () => (isDelete ? onDelete() : onDigit(k)) : null,
            child: Center(child: isDelete ? Icon(Icons.backspace_outlined, size: TurboSizes.iconMd, color: c.textPrimary) : Text(k, style: t.styles.monoKeypad)),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final row in const [['1', '2', '3'], ['4', '5', '6'], ['7', '8', '9'], ['', '0', '⌫']])
          Padding(
            padding: const EdgeInsets.only(bottom: TurboSpacing.sm),
            child: SizedBox(
              height: TurboSizes.buttonHeight,
              child: Row(
                children: [
                  for (var i = 0; i < row.length; i++) ...[
                    if (i > 0) const SizedBox(width: TurboSpacing.sm),
                    Expanded(child: key(row[i])),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}
