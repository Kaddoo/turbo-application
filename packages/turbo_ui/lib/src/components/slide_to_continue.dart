import 'package:flutter/material.dart';

import '../motion/turbo_motion.dart';
import '../theme/spacing.dart';
import '../theme/turbo_theme.dart';

/// "Slide to continue" on the welcome screens: a 74 pt track with a lime knob. Dragging past the middle continues.
/// Tapping the track also continues, so nobody needs to drag (and screen readers get a plain button).
class SlideToContinue extends StatefulWidget {
  const SlideToContinue({super.key, required this.label, required this.onContinue, this.icon = Icons.directions_car_outlined});

  final String label;
  final VoidCallback onContinue;
  final IconData icon;

  @override
  State<SlideToContinue> createState() => _SlideToContinueState();
}

class _SlideToContinueState extends State<SlideToContinue> {
  double _drag = 0;

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    final c = t.colors;
    const knob = TurboSizes.buttonHeight + TurboSpacing.sm;
    const track = knob + TurboSpacing.sm * 2;
    return Semantics(
      button: true,
      label: widget.label,
      excludeSemantics: true,
      onTap: widget.onContinue,
      child: LayoutBuilder(
        builder: (context, box) {
          final max = (box.maxWidth - knob - TurboSpacing.sm * 2).clamp(0.0, double.infinity);
          return GestureDetector(
            onTap: widget.onContinue,
            onHorizontalDragUpdate: (d) => setState(() => _drag = (_drag + d.delta.dx).clamp(0.0, max)),
            onHorizontalDragEnd: (_) {
              final done = max > 0 && _drag > max * 0.6;
              setState(() => _drag = 0);
              if (done) widget.onContinue();
            },
            child: Container(
              height: track,
              decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(t.radiusFull), border: Border.all(color: c.border)),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Center(child: Padding(padding: const EdgeInsets.only(left: knob), child: Text(widget.label, style: Theme.of(context).textTheme.labelLarge))),
                  AnimatedPositioned(
                    duration: _drag == 0 ? TurboMotion.duration(context, TurboMotion.fast) : Duration.zero,
                    left: TurboSpacing.sm + _drag,
                    child: Container(
                      width: knob,
                      height: knob,
                      decoration: BoxDecoration(color: c.accent, shape: BoxShape.circle),
                      child: Icon(widget.icon, color: c.onAccent, size: TurboSizes.iconMd),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
