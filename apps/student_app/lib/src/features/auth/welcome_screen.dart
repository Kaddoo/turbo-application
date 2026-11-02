import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../l10n/app_localizations.dart';

/// The first screen after the splash: what the service is, in one picture and one line, and a slide to carry on.
/// The picture is drawn here (a grid and a car) until the photo from the design is approved and bundled.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Builder(
      builder: (context) {
        final t = context.turbo;
        final text = Theme.of(context).textTheme;
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                TurboSpacing.screen,
                TurboSpacing.sm,
                TurboSpacing.screen,
                TurboSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(t.radiusSheet),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ColoredBox(color: t.colors.accent),
                          CustomPaint(
                            painter: _GridPainter(
                              t.colors.onAccent.withValues(alpha: 0.08),
                            ),
                          ),
                          Center(
                            child: ExcludeSemantics(
                              child: Icon(
                                Icons.directions_car_filled_outlined,
                                size: TurboSizes.iconLg * 3,
                                color: t.colors.onAccent,
                              ),
                            ),
                          ),
                          Positioned(
                            left: TurboSpacing.lg,
                            top: TurboSpacing.lg,
                            child: ExcludeSemantics(
                              child: Container(
                                width: TurboSizes.iconButton,
                                height: TurboSizes.iconButton,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: t.colors.background,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  _initials(t.brand.wordmark),
                                  style: text.labelLarge?.copyWith(
                                    color: t.colors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: TurboSpacing.lg,
                            bottom: TurboSpacing.lg,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: TurboSpacing.lg,
                                vertical: TurboSpacing.md,
                              ),
                              decoration: BoxDecoration(
                                color: t.colors.background,
                                borderRadius: BorderRadius.circular(
                                  t.radiusFull,
                                ),
                              ),
                              child: Text(
                                l10n.welcomeFixedFares,
                                style: text.labelMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: TurboSpacing.xl),
                  AccentTitle(
                    text: l10n.welcomeTagline,
                    accent: l10n.welcomeTaglineAccent,
                    style: text.displaySmall,
                  ),
                  const SizedBox(height: TurboSpacing.sm),
                  Text(
                    l10n.welcomeAudience,
                    style: text.bodyMedium?.copyWith(
                      color: t.colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: TurboSpacing.xl),
                  SlideToContinue(
                    label: l10n.welcomeContinue,
                    onContinue: () => context.go('/phone'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Faint map-like grid behind the car.
class _GridPainter extends CustomPainter {
  _GridPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const step = TurboSizes.iconButton;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => old.color != color;
}

/// First and last letter of the wordmark, the short mark in the corner of the card.
String _initials(String name) {
  final letters = name.characters;
  return letters.length < 2 ? name : '${letters.first}${letters.last}';
}
