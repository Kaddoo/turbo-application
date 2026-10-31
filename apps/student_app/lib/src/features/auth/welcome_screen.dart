import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../l10n/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TurboSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              const Wordmark(),
              const SizedBox(height: TurboSpacing.lg),
              Text(l10n.welcomeTagline, style: text.titleLarge),
              const SizedBox(height: TurboSpacing.sm),
              Text(l10n.welcomeAudience, style: text.bodyMedium),
              const Spacer(flex: 2),
              TurboButton(label: l10n.continueAction, large: true, onPressed: () => context.go('/phone')),
            ],
          ),
        ),
      ),
    );
  }
}
