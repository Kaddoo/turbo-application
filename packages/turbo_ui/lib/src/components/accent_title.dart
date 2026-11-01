import 'package:flutter/material.dart';

import '../theme/turbo_theme.dart';

/// A screen title where the last word or words are lime: "Sign in with your **phone**". [accent] must be the end of [text];
/// if it is not (a translation that moves the word), the whole title is plain.
class AccentTitle extends StatelessWidget {
  const AccentTitle({super.key, required this.text, this.accent, this.style, this.textAlign = TextAlign.start});

  final String text;
  final String? accent;
  final TextStyle? style;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    final base = style ?? Theme.of(context).textTheme.headlineMedium!;
    final a = accent;
    final split = a != null && a.isNotEmpty && text.endsWith(a);
    return Semantics(
      header: true,
      label: text,
      excludeSemantics: true,
      child: split
          ? Text.rich(
              TextSpan(style: base, children: [
                TextSpan(text: text.substring(0, text.length - a.length)),
                TextSpan(text: a, style: base.copyWith(color: t.colors.accentText)),
              ]),
              textAlign: textAlign,
            )
          : Text(text, style: base, textAlign: textAlign),
    );
  }
}
