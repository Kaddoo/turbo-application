import 'package:flutter/material.dart';

import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';
import 'turbo_art.dart';

/// The large picture above a title on sign-in and system screens: a 3D picture from the kit ([art]), or [image], or [icon] drawn on a raised tile.
class HeroIcon extends StatelessWidget {
  const HeroIcon({super.key, this.icon, this.image, this.art, this.size = TurboSizes.heroIcon});

  final TurboArt? art;

  final IconData? icon;
  final ImageProvider? image;
  final double size;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: (art?.image ?? image) != null
            ? Image(image: (art?.image ?? image)!, fit: BoxFit.contain)
            : DecoratedBox(
                decoration: BoxDecoration(color: t.colors.surfaceRaised, borderRadius: BorderRadius.circular(t.radiusTile)),
                child: Icon(icon, size: size / 2, color: t.colors.accentText),
              ),
      ),
    );
  }
}
