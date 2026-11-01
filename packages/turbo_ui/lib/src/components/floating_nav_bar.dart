import 'package:flutter/material.dart';

import '../motion/turbo_motion.dart';
import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';

class FloatingNavItem {
  const FloatingNavItem({required this.icon, required this.selectedIcon, required this.label});

  final IconData icon;
  final IconData selectedIcon;

  /// Spoken name; the bar shows icons only.
  final String label;
}

/// A pill that floats above the content with icons only. The open tab is a 56 pt lime circle; the others are quiet icons.
/// Every item keeps a spoken label and a target of at least 44 pt.
class FloatingNavBar extends StatelessWidget {
  const FloatingNavBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<FloatingNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(TurboSpacing.screen, TurboSpacing.sm, TurboSpacing.screen, TurboSpacing.md),
        child: Container(
          padding: const EdgeInsets.all(TurboSpacing.xs),
          decoration: BoxDecoration(
            color: t.colors.surface,
            border: Border.all(color: t.colors.border),
            borderRadius: BorderRadius.circular(t.radiusFull),
          ),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: Semantics(
                    button: true,
                    selected: i == selectedIndex,
                    label: items[i].label,
                    child: ExcludeSemantics(
                      child: InkWell(
                        customBorder: const StadiumBorder(),
                        onTap: () => onSelected(i),
                        child: Center(
                          heightFactor: 1,
                          child: AnimatedContainer(
                            duration: TurboMotion.duration(context, TurboMotion.fast),
                            width: TurboSizes.navItem,
                            height: TurboSizes.navItem,
                            decoration: BoxDecoration(
                              color: i == selectedIndex ? t.colors.accent : t.colors.surface.withValues(alpha: 0),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              i == selectedIndex ? items[i].selectedIcon : items[i].icon,
                              size: TurboSizes.iconMd,
                              color: i == selectedIndex ? t.colors.onAccent : t.colors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
