import 'package:flutter/material.dart';

import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';
import 'accent_title.dart';
import 'hero_icon.dart';
import 'turbo_icon_button.dart';

/// Large wordmark for start-up screens, read from the brand layer.
class BigWordmark extends StatelessWidget {
  const BigWordmark({super.key, this.onAccent = false});

  /// True on the accent-filled splash, where the text takes the on-accent colour.
  final bool onAccent;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    return Semantics(
      header: true,
      child: Text(
        t.brand.wordmark,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontSize: t.brand.typeScale.splash,
          color: onAccent ? t.colors.onAccent : t.colors.textPrimary,
        ),
      ),
    );
  }
}

/// The accent-filled splash with the wordmark.
class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    return Scaffold(
      backgroundColor: t.colors.accent,
      body: const Center(child: BigWordmark(onAccent: true)),
    );
  }
}

/// Dark start-up screen: back button and a small wordmark on top, then a picture, an accent title and a lead line, the form, and one pinned action.
class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    required this.title,
    required this.children,
    required this.action,
    this.accent,
    this.lead,
    this.icon,
    this.onBack,
    this.footer,
    this.centered = false,
  });

  final String title;

  /// The end of [title] shown in lime.
  final String? accent;

  /// A line under the title.
  final String? lead;
  final IconData? icon;
  final List<Widget> children;
  final Widget action;
  final VoidCallback? onBack;
  final Widget? footer;

  /// Centre the picture, title and lead (the terms screen).
  final bool centered;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final t = context.turbo;
        final text = Theme.of(context).textTheme;
        final align = centered
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start;
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    TurboSpacing.screen,
                    TurboSpacing.sm,
                    TurboSpacing.screen,
                    0,
                  ),
                  child: SizedBox(
                    height: TurboSizes.iconButton,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (onBack != null)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TurboIconButton(
                              icon: Icons.chevron_left,
                              label: MaterialLocalizations.of(context)
                                  .backButtonTooltip,
                              onPressed: onBack,
                            ),
                          ),
                        Text(
                          t.brand.wordmark,
                          style: t.styles.wordmark.copyWith(
                            fontSize: t.brand.typeScale.emphasis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      TurboSpacing.screen,
                      TurboSpacing.xl,
                      TurboSpacing.screen,
                      TurboSpacing.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: align,
                      children: [
                        if (icon != null) ...[
                          HeroIcon(icon: icon),
                          const SizedBox(height: TurboSpacing.lg),
                        ],
                        AccentTitle(
                          text: title,
                          accent: accent,
                          textAlign: centered
                              ? TextAlign.center
                              : TextAlign.start,
                        ),
                        if (lead != null) ...[
                          const SizedBox(height: TurboSpacing.sm),
                          Text(
                            lead!,
                            style: text.bodyMedium?.copyWith(
                              color: t.colors.textSecondary,
                            ),
                            textAlign: centered
                                ? TextAlign.center
                                : TextAlign.start,
                          ),
                        ],
                        const SizedBox(height: TurboSpacing.xl),
                        ...children,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    TurboSpacing.screen,
                    TurboSpacing.md,
                    TurboSpacing.screen,
                    TurboSpacing.lg,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      action,
                      if (footer != null) ...[
                        const SizedBox(height: TurboSpacing.md),
                        footer!,
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
