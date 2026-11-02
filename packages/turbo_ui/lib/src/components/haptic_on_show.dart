import 'package:flutter/widgets.dart';

import '../haptics/turbo_haptics.dart';

/// Plays one haptic the first time [child] is shown, for a screen that appears because something just happened
/// (the top-up result after the wait). It never repeats on rebuild. Pair it with the visual change it confirms.
class HapticOnShow extends StatefulWidget {
  const HapticOnShow({super.key, required this.kind, required this.child});

  final TurboHapticKind kind;
  final Widget child;

  @override
  State<HapticOnShow> createState() => _HapticOnShowState();
}

class _HapticOnShowState extends State<HapticOnShow> {
  @override
  void initState() {
    super.initState();
    TurboHaptics.play(widget.kind);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
