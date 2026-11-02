import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// Turns the screen lock off or on. Replaced in tests, where there is no plugin.
final screenAwakeProvider = Provider<Future<void> Function(bool awake)>(
  (_) => (awake) => WakelockPlus.toggle(enable: awake),
);

/// Keeps the screen on while [child] is showing, so the phone in the mount
/// does not go dark mid-ride. The system lets go of it when the app leaves
/// the front, and this lets go of it when the child goes away.
class KeepScreenAwake extends ConsumerStatefulWidget {
  const KeepScreenAwake({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<KeepScreenAwake> createState() => _KeepScreenAwakeState();
}

class _KeepScreenAwakeState extends ConsumerState<KeepScreenAwake> {
  late final Future<void> Function(bool) _toggle = ref.read(screenAwakeProvider);

  @override
  void initState() {
    super.initState();
    _toggle(true);
  }

  @override
  void dispose() {
    _toggle(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
