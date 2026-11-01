import 'package:flutter/material.dart';

import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';

/// A person: a picture when there is one, otherwise their first letter. [rounded] is the soft square used on driver and trip cards.
class TurboAvatar extends StatelessWidget {
  const TurboAvatar({super.key, required this.name, this.image, this.small = false, this.rounded = false});

  final String name;
  final ImageProvider? image;
  final bool small;
  final bool rounded;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    final size = small ? TurboSizes.avatarSmall : TurboSizes.avatar;
    final shape = rounded ? BoxShape.rectangle : BoxShape.circle;
    final radius = rounded ? BorderRadius.circular(t.radiusCode) : null;
    return Semantics(
      label: name,
      image: true,
      excludeSemantics: true,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: t.colors.surfaceRaised,
          shape: shape,
          borderRadius: radius,
          image: image == null ? null : DecorationImage(image: image!, fit: BoxFit.cover),
        ),
        child: image == null
            ? Text(name.trim().isEmpty ? '?' : name.trim().characters.first.toUpperCase(), style: t.styles.emphasis)
            : null,
      ),
    );
  }
}
