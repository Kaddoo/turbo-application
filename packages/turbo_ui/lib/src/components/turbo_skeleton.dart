import 'package:flutter/material.dart';

import '../motion/turbo_motion.dart';
import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';

/// Placeholder block. Pulses gently; static when reduced motion is on.
class TurboSkeleton extends StatefulWidget {
  const TurboSkeleton({super.key, this.width, this.height = TurboSpacing.lg});

  final double? width;
  final double height;

  @override
  State<TurboSkeleton> createState() => _TurboSkeletonState();
}

class _TurboSkeletonState extends State<TurboSkeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: TurboMotion.slow * 3);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (TurboMotion.reduced(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    return ExcludeSemantics(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => Opacity(
          opacity: 0.55 + 0.45 * _controller.value,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: t.colors.border,
              borderRadius: BorderRadius.circular(t.radiusInput),
            ),
          ),
        ),
      ),
    );
  }
}
