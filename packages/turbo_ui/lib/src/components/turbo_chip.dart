import 'package:flutter/material.dart';

import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';

/// A 50 pt pill for filters and saved places. Selected is the light fill. [leading] holds a 3D icon or a small picture.
/// [outline] is the 34 pt lime-outlined pill used over photos ("Fare locked").
class TurboChip extends StatelessWidget {
  const TurboChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.leading,
    this.outline = false,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final Widget? leading;
  final bool outline;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    final c = t.colors;
    final fill = outline ? c.background.withValues(alpha: 0) : (selected ? c.textPrimary : c.surfaceRaised);
    final fore = outline ? c.accentText : (selected ? c.background : c.textPrimary);
    final style = outline ? t.styles.tag.copyWith(color: fore) : Theme.of(context).textTheme.labelMedium!.copyWith(color: fore, fontWeight: FontWeight.w500);
    final height = outline ? TurboSizes.smallChipHeight : TurboSizes.chipHeight;
    final pad = outline ? TurboSpacing.md + TurboSpacing.xs : TurboSpacing.lg + TurboSpacing.xs;
    return Semantics(
      button: onTap != null,
      selected: selected,
      label: label,
      excludeSemantics: true,
      onTap: onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: height < TurboSizes.minTap ? TurboSizes.minTap : height),
        child: Center(
          widthFactor: 1,
          heightFactor: 1,
          child: Material(
            color: fill,
            shape: StadiumBorder(side: outline ? BorderSide(color: c.accentText) : BorderSide.none),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: onTap,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: height),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: pad),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (leading != null) ...[leading!, const SizedBox(width: TurboSpacing.sm)],
                      Flexible(child: Text(label, style: style)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A row of 2 to 4 tabs as one pill; the selected one is the light fill. Used for Trips, Shifts, Hours and Salary.
class TurboSegmented extends StatelessWidget {
  const TurboSegmented({super.key, required this.labels, required this.selectedIndex, required this.onSelected});

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    final c = t.colors;
    return Container(
      padding: const EdgeInsets.all(TurboSpacing.xs),
      decoration: BoxDecoration(color: c.surfaceRaised, borderRadius: BorderRadius.circular(t.radiusFull)),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: Semantics(
                button: true,
                selected: i == selectedIndex,
                label: labels[i],
                excludeSemantics: true,
                onTap: () => onSelected(i),
                child: InkWell(
                  customBorder: const StadiumBorder(),
                  onTap: () => onSelected(i),
                  child: Container(
                    constraints: const BoxConstraints(minHeight: TurboSizes.minTap),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: TurboSpacing.sm),
                    decoration: BoxDecoration(
                      color: i == selectedIndex ? c.textPrimary : c.background.withValues(alpha: 0),
                      borderRadius: BorderRadius.circular(t.radiusFull),
                    ),
                    child: Text(
                      labels[i],
                      textAlign: TextAlign.center,
                      style: t.styles.tab.copyWith(color: i == selectedIndex ? c.background : c.textSecondary),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
