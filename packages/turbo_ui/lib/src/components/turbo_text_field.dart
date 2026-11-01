import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';

/// Text field with a visible label and an inline error under it.
class TurboTextField extends StatelessWidget {
  const TurboTextField({
    super.key,
    required this.label,
    this.controller,
    this.helper,
    this.errorText,
    this.prefixText,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.textInputAction,
    this.autofillHints,
    this.enabled = true,
    this.obscureText = false,
  });

  final String label;
  final TextEditingController? controller;
  final String? helper;
  final String? errorText;
  final String? prefixText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final bool enabled;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    final c = t.colors;
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(t.radiusInput),
          borderSide: BorderSide(color: color, width: width),
        );

    // The label sits above the field and stays there (design rule: labels always above). The field is named for screen readers by that label.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(child: Padding(padding: const EdgeInsets.only(left: TurboSpacing.md, bottom: TurboSpacing.sm), child: Text(label, style: t.styles.fieldLabel))),
        Semantics(
          label: label,
          child: TextField(
            controller: controller,
            enabled: enabled,
            obscureText: obscureText,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            textInputAction: textInputAction,
            autofillHints: autofillHints,
            style: t.styles.input,
            cursorColor: c.focusRing,
            decoration: InputDecoration(
              helperText: helper,
              helperMaxLines: 3,
              errorText: errorText,
              errorMaxLines: 3,
              prefixText: prefixText,
              filled: true,
              fillColor: c.surface,
              prefixStyle: t.styles.monoPhone.copyWith(color: c.textSecondary),
              helperStyle: t.styles.fieldLabel.copyWith(fontWeight: FontWeight.w400),
              errorStyle: t.styles.fieldLabel.copyWith(color: c.danger),
              contentPadding: const EdgeInsets.symmetric(horizontal: TurboSpacing.lg + TurboSpacing.xs, vertical: TurboSpacing.lg),
              enabledBorder: border(c.controlBorder),
              disabledBorder: border(c.border),
              focusedBorder: border(c.focusRing, TurboSizes.accentBorderWidth),
              errorBorder: border(c.danger, TurboSizes.accentBorderWidth),
              focusedErrorBorder: border(c.danger, TurboSizes.accentBorderWidth),
            ),
          ),
        ),
      ],
    );
  }
}
