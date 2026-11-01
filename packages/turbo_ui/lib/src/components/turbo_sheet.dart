import 'package:flutter/material.dart';

import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';

/// Modal bottom sheet in the raised surface colour.
Future<T?> showTurboSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isDismissible = true,
}) {
  final t = context.turbo;
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: isDismissible,
    enableDrag: isDismissible,
    backgroundColor: t.colors.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(t.radiusSheet)),
      side: BorderSide(color: t.colors.border),
    ),
    builder: (context) => SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          TurboSpacing.screen,
          TurboSpacing.md,
          TurboSpacing.screen,
          TurboSpacing.xl + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: ExcludeSemantics(
                child: Container(
                  width: TurboSizes.sheetHandleWidth,
                  height: TurboSizes.sheetHandleHeight,
                  margin: const EdgeInsets.only(bottom: TurboSpacing.lg),
                  decoration: BoxDecoration(color: t.colors.fill, borderRadius: BorderRadius.circular(t.radiusFull)),
                ),
              ),
            ),
            Flexible(child: builder(context)),
          ],
        ),
      ),
    ),
  );
}
