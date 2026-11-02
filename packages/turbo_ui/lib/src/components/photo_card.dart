import 'package:flutter/material.dart';

import '../theme/turbo_theme.dart';

/// A photo with a soft dark fade at the bottom and room for text on top of it.
/// The picture is decoration: it is hidden from screen readers, so put anything that matters in [child].
class PhotoCard extends StatelessWidget {
  const PhotoCard({super.key, required this.asset, this.height = 240, this.child, this.alignment = Alignment.bottomLeft});

  /// Name of a file in `assets/photos` of this package, like `trip-status-trotro.jpg`.
  final String asset;
  final double height;
  final Widget? child;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    return ClipRRect(
      borderRadius: BorderRadius.circular(t.radiusPanel),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ExcludeSemantics(
              child: Image.asset('assets/photos/$asset', package: 'turbo_ui', fit: BoxFit.cover),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [t.colors.background.withValues(alpha: 0), t.colors.background.withValues(alpha: 0.85)],
                ),
              ),
            ),
            if (child != null) Align(alignment: alignment, child: Padding(padding: const EdgeInsets.all(16), child: child)),
          ],
        ),
      ),
    );
  }
}
