import 'package:flutter/material.dart';

import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';

/// The large picture above a title on sign-in and system screens. The design uses a 3D icon here; until those pictures are approved
/// and bundled, [icon] is drawn on a raised tile. Pass [image] to show the 3D picture instead; nothing else changes.
class HeroIcon extends StatelessWidget {
  const HeroIcon({super.key, this.icon, this.image, this.size = TurboSizes.heroIcon});

  final IconData? icon;
  final ImageProvider? image;
  final double size;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: image != null
            ? Image(image: image!, fit: BoxFit.contain)
            : DecoratedBox(
                decoration: BoxDecoration(color: t.colors.surfaceRaised, borderRadius: BorderRadius.circular(t.radiusTile)),
                child: Icon(icon, size: size / 2, color: t.colors.accentText),
              ),
      ),
    );
  }
}
