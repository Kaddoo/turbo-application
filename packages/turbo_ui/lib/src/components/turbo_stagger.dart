import 'package:flutter/material.dart';

import '../motion/turbo_motion.dart';

/// Fades and lifts a list row in, 30 ms after the row before it. Only the
/// first ten rows are staggered, so a long list never makes anyone wait.
/// Nothing moves with reduced motion.
class TurboStagger extends StatefulWidget {
  const TurboStagger({super.key, required this.index, required this.child});

  final int index;
  final Widget child;

  static const Duration step = Duration(milliseconds: 30);
  static const int maxStaggered = 10;
  static const double lift = 8;

  @override
  State<TurboStagger> createState() => _TurboStaggerState();
}

class _TurboStaggerState extends State<TurboStagger>
    with SingleTickerProviderStateMixin {
  AnimationController? _c;
  late Animation<double> _t;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_c != null) return;
    if (TurboMotion.reduced(context)) return;
    final delay =
        TurboStagger.step * widget.index.clamp(0, TurboStagger.maxStaggered);
    final total = delay + TurboMotion.medium;
    final c = AnimationController(vsync: this, duration: total);
    // One controller per row; the row waits by starting its curve late, so no
    // timer is left running.
    _t = CurvedAnimation(
      parent: c,
      curve: Interval(
        delay.inMilliseconds / total.inMilliseconds,
        1,
        curve: TurboMotion.standard,
      ),
    );
    _c = c..forward();
  }

  @override
  void dispose() {
    _c?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_c == null) return widget.child;
    return AnimatedBuilder(
      animation: _t,
      child: widget.child,
      builder: (_, child) => Opacity(
        opacity: _t.value,
        child: Transform.translate(
          offset: Offset(0, (1 - _t.value) * TurboStagger.lift),
          child: child,
        ),
      ),
    );
  }
}
