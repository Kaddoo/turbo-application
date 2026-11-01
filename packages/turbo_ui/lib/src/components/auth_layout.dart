import 'package:flutter/material.dart';

import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';

/// Always-dark scope for the start-up screens, whatever the system setting.
class DarkScope extends StatelessWidget {
  const DarkScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brand = context.turbo.brand;
    return Theme(data: buildTurboTheme(brand, Brightness.dark), child: child);
  }
}

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
              fontSize: t.brand.typeScale.display * 1.5,
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

/// Dark start-up screen: wordmark on top, a raised sheet with the form, and one
/// pinned action underneath.
class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    required this.title,
    required this.children,
    required this.action,
    this.onBack,
    this.footer,
  });

  final String title;
  final List<Widget> children;
  final Widget action;
  final VoidCallback? onBack;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return DarkScope(
      child: Builder(builder: (context) {
        final t = context.turbo;
        final text = Theme.of(context).textTheme;
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: onBack == null
                      ? const SizedBox(height: TurboSizes.minTap)
                      : Padding(
                          padding: const EdgeInsets.all(TurboSpacing.sm),
                          child: BackButton(onPressed: onBack),
                        ),
                ),
                const SizedBox(height: TurboSpacing.xl),
                const BigWordmark(),
                const SizedBox(height: TurboSpacing.xxl),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: TurboSpacing.lg),
                    padding: const EdgeInsets.all(TurboSpacing.xl),
                    decoration: BoxDecoration(
                      color: t.colors.surface,
                      borderRadius: BorderRadius.circular(t.radiusCard),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Semantics(
                            header: true,
                            child: Text(title, style: text.titleLarge, textAlign: TextAlign.center),
                          ),
                          const SizedBox(height: TurboSpacing.lg),
                          ...children,
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(TurboSpacing.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      action,
                      if (footer != null) ...[const SizedBox(height: TurboSpacing.md), footer!],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
