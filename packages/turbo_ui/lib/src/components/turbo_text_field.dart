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
    OutlineInputBorder border(Color color, [double width = TurboSizes.accentBorderWidth]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(t.radiusInput),
          borderSide: BorderSide(color: color, width: width),
        );

    return TextField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      style: Theme.of(context).textTheme.bodyLarge,
      cursorColor: c.focusRing,
      decoration: InputDecoration(
        labelText: label,
        helperText: helper,
        helperMaxLines: 3,
        errorText: errorText,
        errorMaxLines: 3,
        prefixText: prefixText,
        filled: true,
        fillColor: c.surface,
        labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: c.textSecondary),
        floatingLabelStyle: Theme.of(context).textTheme.bodySmall,
        helperStyle: Theme.of(context).textTheme.bodySmall,
        errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.danger),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: TurboSpacing.lg,
          vertical: TurboSpacing.md,
        ),
        enabledBorder: border(c.controlBorder),
        disabledBorder: border(c.border),
        focusedBorder: border(c.focusRing, TurboSizes.focusRingWidth),
        errorBorder: border(c.danger),
        focusedErrorBorder: border(c.danger, TurboSizes.focusRingWidth),
      ),
    );
  }
}
