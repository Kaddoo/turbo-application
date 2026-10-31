import 'package:flutter/material.dart';

import '../theme/turbo_theme.dart';

/// Short message at the bottom, with Undo where the action can be undone.
void showTurboToast(
  BuildContext context,
  String message, {
  String? undoLabel,
  VoidCallback? onUndo,
}) {
  final t = context.turbo;
  final messenger = ScaffoldMessenger.of(context);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: t.colors.surfaceRaised,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(t.radiusInput),
          side: BorderSide(color: t.colors.border),
        ),
        content: Text(message, style: Theme.of(context).textTheme.bodyMedium),
        action: undoLabel != null && onUndo != null
            ? SnackBarAction(
                label: undoLabel,
                textColor: t.colors.accentText,
                onPressed: onUndo,
              )
            : null,
      ),
    );
}
