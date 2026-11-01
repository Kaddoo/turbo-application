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

/// Rounded bar that floats above the content with icons only. The selected
/// item is a solid square; every item keeps a spoken label and a 44 pt target.
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
        padding: const EdgeInsets.fromLTRB(TurboSpacing.lg, TurboSpacing.sm, TurboSpacing.lg, TurboSpacing.sm),
        child: Container(
          padding: const EdgeInsets.all(TurboSpacing.xs),
          decoration: BoxDecoration(
            color: t.colors.surface,
            border: Border.all(color: t.colors.border),
            borderRadius: BorderRadius.circular(t.radiusCard),
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
                        borderRadius: BorderRadius.circular(t.radiusInput),
                        onTap: () => onSelected(i),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: TurboSizes.minTap + TurboSpacing.xs),
                          child: Center(
                            heightFactor: 1,
                            child: AnimatedContainer(
                              duration: TurboMotion.duration(context, TurboMotion.fast),
                              width: TurboSizes.primaryAction,
                              height: TurboSizes.minTap,
                              decoration: BoxDecoration(
                                color: i == selectedIndex ? t.colors.textPrimary : Colors.transparent,
                                borderRadius: BorderRadius.circular(t.radiusInput),
                              ),
                              child: Icon(
                                i == selectedIndex ? items[i].selectedIcon : items[i].icon,
                                size: TurboSizes.iconMd,
                                color: i == selectedIndex ? t.colors.background : t.colors.textSecondary,
                              ),
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
