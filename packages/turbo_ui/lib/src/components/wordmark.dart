import 'package:flutter/material.dart';

import '../theme/turbo_theme.dart';

/// Text placeholder for the logo, read from the brand layer.
class Wordmark extends StatelessWidget {
  const Wordmark({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    return Semantics(
      header: true,
      child: Text(
        t.brand.wordmark,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: t.colors.textPrimary),
      ),
    );
  }
}
