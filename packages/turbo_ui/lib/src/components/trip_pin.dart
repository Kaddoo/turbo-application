import 'package:flutter/material.dart';

import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';

/// The four-digit start PIN, the hero of the trip screen: 68 x 80 raised boxes with big lime mono digits.
/// With fewer than four [digits] the rest show empty (the driver's entry screen); [current] outlines the box being filled.
class TripPin extends StatelessWidget {
  const TripPin({
    super.key,
    required this.digits,
    this.length = 4,
    this.current = false,
    this.error = false,
    this.semanticLabel,
    this.digitLabel,
  });

  final String digits;
  final int length;

  /// Outline the next empty box in lime (the driver is typing).
  final bool current;
  final bool error;
  final String? semanticLabel;

  /// Reads each filled box on its own ("Digit 1: 4") for a screen reader.
  final String Function(int position, String digit)? digitLabel;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    final c = t.colors;
    return Semantics(
      label: semanticLabel,
      excludeSemantics: semanticLabel != null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < length; i++) ...[
            if (i > 0) const SizedBox(width: TurboSpacing.sm),
            Flexible(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: TurboSizes.pinBoxWidth,
                ),
                child: Semantics(
                  label: digitLabel != null && i < digits.length
                      ? digitLabel!(i + 1, digits[i])
                      : null,
                  excludeSemantics: digitLabel != null && i < digits.length,
                  child: AspectRatio(
                    aspectRatio:
                        TurboSizes.pinBoxWidth / TurboSizes.pinBoxHeight,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: c.fill,
                        borderRadius: BorderRadius.circular(t.radiusInner),
                        border: error
                            ? Border.all(
                                color: c.danger,
                                width: TurboSizes.accentBorderWidth,
                              )
                            : (current && i == digits.length
                                  ? Border.all(
                                      color: c.accentText,
                                      width: TurboSizes.accentBorderWidth,
                                    )
                                  : null),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          i < digits.length ? digits[i] : '',
                          style: t.styles.monoPin.copyWith(color: c.accentText),
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
    );
  }
}
