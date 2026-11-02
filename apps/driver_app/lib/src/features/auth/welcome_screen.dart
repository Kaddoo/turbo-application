import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../l10n/app_localizations.dart';

/// First screen for a driver signed out: who the app is for, then a slide to carry on.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final t = context.turbo;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(TurboSpacing.screen, TurboSpacing.sm, TurboSpacing.screen, TurboSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: PhotoCard(asset: 'driver-welcome.jpg', height: double.infinity),
              ),
              const SizedBox(height: TurboSpacing.xl),
              AccentTitle(text: l10n.welcomeTagline, accent: l10n.welcomeTaglineAccent, style: text.displaySmall),
              const SizedBox(height: TurboSpacing.sm),
              Text(l10n.welcomeAudience(t.brand.appName), style: text.bodyMedium?.copyWith(color: t.colors.textSecondary)),
              const SizedBox(height: TurboSpacing.xl),
              SlideToContinue(label: l10n.continueAction, onContinue: () => context.go('/phone')),
            ],
          ),
        ),
      ),
    );
  }
}
