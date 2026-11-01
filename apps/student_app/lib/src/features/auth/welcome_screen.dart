import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../l10n/app_localizations.dart';

/// Three short slides, then on to the phone number. Photos from the design go
/// behind the text once the image files arrive.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _pages = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _go(int to) => _pages.animateToPage(
        to,
        duration: TurboMotion.duration(context, TurboMotion.medium),
        curve: TurboMotion.standard,
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final slides = [
      (l10n.welcomeTagline, l10n.welcomeAudience),
      (l10n.welcomeSlide2Title, l10n.welcomeSlide2Body),
      (l10n.welcomeSlide3Title, l10n.welcomeSlide3Body),
    ];
    final last = _page == slides.length - 1;
    return DarkScope(
      child: Builder(builder: (context) {
        final t = context.turbo;
        final text = Theme.of(context).textTheme;
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: TurboSpacing.xxl),
                const BigWordmark(),
                Expanded(
                  child: PageView(
                    controller: _pages,
                    onPageChanged: (i) => setState(() => _page = i),
                    children: [
                      for (final (title, body) in slides)
                        Padding(
                          padding: const EdgeInsets.all(TurboSpacing.xl),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Semantics(
                                header: true,
                                child: Text(title, style: text.headlineMedium),
                              ),
                              const SizedBox(height: TurboSpacing.md),
                              Text(body, style: text.bodyLarge?.copyWith(color: t.colors.textSecondary)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(TurboSpacing.xl),
                  child: Column(
                    children: [
                      Semantics(
                        label: l10n.welcomeSlideOf(_page + 1, slides.length),
                        child: ExcludeSemantics(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (var i = 0; i < slides.length; i++)
                                Container(
                                  width: i == _page ? TurboSpacing.xl : TurboSpacing.sm,
                                  height: TurboSpacing.sm,
                                  margin: const EdgeInsets.symmetric(horizontal: TurboSpacing.xs),
                                  decoration: BoxDecoration(
                                    color: i == _page ? t.colors.accent : t.colors.border,
                                    borderRadius: BorderRadius.circular(t.radiusFull),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: TurboSpacing.lg),
                      if (last)
                        TurboButton(
                          label: l10n.continueAction,
                          large: true,
                          onPressed: () => context.go('/phone'),
                        )
                      else
                        Row(
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                minimumSize: const Size(TurboSizes.minTap, TurboSizes.minTap),
                              ),
                              onPressed: () => context.go('/phone'),
                              child: Text(l10n.welcomeSkip),
                            ),
                            const Spacer(),
                            IconButton.filled(
                              tooltip: l10n.welcomeNext,
                              constraints: const BoxConstraints(
                                minWidth: TurboSizes.primaryAction,
                                minHeight: TurboSizes.primaryAction,
                              ),
                              onPressed: () => _go(_page + 1),
                              icon: const Icon(Icons.chevron_right),
                            ),
                          ],
                        ),
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
