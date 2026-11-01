import 'package:flutter/material.dart';

import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';
import 'hero_icon.dart';
import 'status_chip.dart';

/// A full-screen message with one way forward: update required, maintenance, couldn't start, account suspended.
/// A big picture, a short title, one or two lines, a tag if it helps, and the action pinned at the bottom.
class SystemMessage extends StatelessWidget {
  const SystemMessage({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.action,
    this.footer,
    this.tag,
    this.image,
  });

  final IconData icon;
  final ImageProvider? image;
  final String title;
  final String? message;
  final Widget? action;

  /// Small text under the action (a support number or email).
  final Widget? footer;
  final StatusChip? tag;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final t = context.turbo;
        final text = Theme.of(context).textTheme;
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TurboSpacing.screen,
                        vertical: TurboSpacing.xl,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          HeroIcon(icon: icon, image: image),
                          const SizedBox(height: TurboSpacing.xl),
                          if (tag != null) ...[
                            tag!,
                            const SizedBox(height: TurboSpacing.md),
                          ],
                          Semantics(
                            header: true,
                            child: Text(
                              title,
                              style: text.headlineMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          if (message != null) ...[
                            const SizedBox(height: TurboSpacing.md),
                            Text(
                              message!,
                              style: text.bodyLarge?.copyWith(
                                color: t.colors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                if (action != null || footer != null)
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
                        ?action,
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
