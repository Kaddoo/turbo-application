import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../motion/turbo_motion.dart';

/// Shakes [child] sideways for 200 ms each time [trigger] changes, to say
/// "no" without words (a wrong PIN). Nothing moves with reduced motion.
class TurboShake extends StatefulWidget {
  const TurboShake({super.key, required this.trigger, required this.child});

  /// Any value that changes when a shake should play, such as a counter.
  final int trigger;
  final Widget child;

  static const double distance = 10;

  @override
  State<TurboShake> createState() => _TurboShakeState();
}

class _TurboShakeState extends State<TurboShake>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  @override
  void didUpdateWidget(TurboShake old) {
    super.didUpdateWidget(old);
    if (old.trigger != widget.trigger && !TurboMotion.reduced(context)) {
      _c.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      child: widget.child,
      builder: (_, child) {
        // Two and a half swings that die away.
        final dx = math.sin(_c.value * math.pi * 5) *
            (1 - _c.value) *
            TurboShake.distance;
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
    );
  }
}
