import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/turbo_ui_localizations.dart';
import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';

/// Six-box one-time code field with auto-advance, backspace to the previous
/// box, and paste of a whole code into any box.
class OtpField extends StatefulWidget {
  const OtpField({
    super.key,
    this.length = 6,
    this.onChanged,
    this.onCompleted,
    this.errorText,
    this.enabled = true,
  });

  final int length;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final String? errorText;
  final bool enabled;

  @override
  State<OtpField> createState() => OtpFieldState();
}

class OtpFieldState extends State<OtpField> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _nodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _nodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  String get value => _controllers.map((c) => c.text).join();

  /// Empties every box and focuses the first, for use after a wrong code.
  void clear() {
    for (final c in _controllers) {
      c.clear();
    }
    _nodes.first.requestFocus();
    widget.onChanged?.call('');
  }

  void _onChanged(int index, String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      _controllers[index].clear();
    } else {
      // A paste or autofill delivers several digits at once; spread them.
      for (var i = 0; i < digits.length && index + i < widget.length; i++) {
        _controllers[index + i].text = digits[i];
      }
      final next = (index + digits.length).clamp(0, widget.length - 1);
      _nodes[next].requestFocus();
    }
    final code = value;
    widget.onChanged?.call(code);
    if (code.length == widget.length) widget.onCompleted?.call(code);
  }

  KeyEventResult _onKey(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _controllers[index - 1].clear();
      _nodes[index - 1].requestFocus();
      widget.onChanged?.call(value);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    final c = t.colors;
    final l10n = TurboUiLocalizations.of(context);
    final hasError = widget.errorText != null;
    final edge = hasError ? c.danger : c.controlBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (var i = 0; i < widget.length; i++) ...[
              if (i > 0) const SizedBox(width: TurboSpacing.sm),
              Expanded(
                child: Semantics(
                  label: l10n.otpDigit(i + 1, widget.length),
                  textField: true,
                  child: Focus(
                    onKeyEvent: (_, e) => _onKey(i, e),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: TurboSizes.primaryAction),
                      child: TextField(
                        controller: _controllers[i],
                        focusNode: _nodes[i],
                        enabled: widget.enabled,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        autofillHints: i == 0 ? const [AutofillHints.oneTimeCode] : null,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: t.styles.monoCode,
                        cursorColor: c.focusRing,
                        onChanged: (v) => _onChanged(i, v),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: c.surface,
                          contentPadding: const EdgeInsets.symmetric(vertical: TurboSpacing.md),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(t.radiusCode),
                            borderSide: BorderSide(color: edge, width: TurboSizes.accentBorderWidth),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(t.radiusCode),
                            borderSide: BorderSide(
                              color: hasError ? c.danger : c.focusRing,
                              width: TurboSizes.focusRingWidth,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(t.radiusCode),
                            borderSide: BorderSide(color: c.border),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        if (hasError) ...[
          const SizedBox(height: TurboSpacing.sm),
          Text(
            widget.errorText!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.danger),
          ),
        ],
      ],
    );
  }
}
