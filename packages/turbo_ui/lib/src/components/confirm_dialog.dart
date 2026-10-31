import 'package:flutter/material.dart';

import '../l10n/turbo_ui_localizations.dart';
import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';
import 'turbo_button.dart';
import 'turbo_text_field.dart';

/// Asks before an action. Pass [typeToConfirm] only for the irreversible:
/// the confirm button stays off until the person types that phrase.
Future<bool> showTurboConfirm({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
  bool destructive = false,
  String? typeToConfirm,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (_) => _ConfirmDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      destructive: destructive,
      typeToConfirm: typeToConfirm,
    ),
  );
  return result ?? false;
}

class _ConfirmDialog extends StatefulWidget {
  const _ConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.destructive,
    required this.typeToConfirm,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final bool destructive;
  final String? typeToConfirm;

  @override
  State<_ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<_ConfirmDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    final l10n = TurboUiLocalizations.of(context);
    final phrase = widget.typeToConfirm;
    final confirmed = phrase == null || _controller.text.trim() == phrase;

    return Dialog(
      backgroundColor: t.colors.surfaceRaised,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(t.radiusCard),
        side: BorderSide(color: t.colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(TurboSpacing.xl),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
              ),
              const SizedBox(height: TurboSpacing.md),
              Text(widget.message, style: Theme.of(context).textTheme.bodyMedium),
              if (phrase != null) ...[
                const SizedBox(height: TurboSpacing.lg),
                TurboTextField(
                  label: l10n.typeToConfirm(phrase),
                  controller: _controller,
                  onChanged: (_) => setState(() {}),
                ),
              ],
              const SizedBox(height: TurboSpacing.xl),
              TurboButton(
                label: widget.confirmLabel,
                variant: widget.destructive
                    ? TurboButtonVariant.destructive
                    : TurboButtonVariant.primary,
                onPressed: confirmed ? () => Navigator.of(context).pop(true) : null,
              ),
              const SizedBox(height: TurboSpacing.sm),
              TurboButton(
                label: l10n.cancel,
                variant: TurboButtonVariant.secondary,
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
