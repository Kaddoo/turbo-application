import 'package:flutter/material.dart';

import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';
import 'turbo_icon_button.dart';

/// "Write a reply": a pill field with a round lime send button.
class MessageComposer extends StatelessWidget {
  const MessageComposer({super.key, required this.controller, required this.hint, required this.sendLabel, required this.onSend, this.enabled = true});

  final TextEditingController controller;
  final String hint;
  final String sendLabel;
  final VoidCallback? onSend;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    final c = t.colors;
    return Row(
      children: [
        Expanded(
          child: Container(
            constraints: const BoxConstraints(minHeight: TurboSizes.buttonHeight),
            padding: const EdgeInsets.symmetric(horizontal: TurboSpacing.lg),
            decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(t.radiusFull), border: Border.all(color: c.border)),
            child: TextField(
              controller: controller,
              enabled: enabled,
              minLines: 1,
              maxLines: 4,
              style: t.styles.input,
              cursorColor: c.focusRing,
              decoration: InputDecoration(border: InputBorder.none, hintText: hint, hintStyle: t.styles.input.copyWith(color: c.textSecondary)),
            ),
          ),
        ),
        const SizedBox(width: TurboSpacing.sm),
        TurboIconButton(icon: Icons.arrow_upward, label: sendLabel, onPressed: enabled ? onSend : null, tone: TurboIconTone.lime),
      ],
    );
  }
}
