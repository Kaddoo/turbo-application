import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../location/api_sender.dart';
import '../../location/location_access.dart';
import '../../location/location_reporter.dart';
import '../../location/tracked_point.dart';

/// Where positions come from. Replaced in tests.
typedef PositionSource = Stream<TrackedPoint> Function({required String title, required String text});

Stream<TrackedPoint> _devicePositions({required String title, required String text}) =>
    backgroundPositions(notificationTitle: title, notificationText: text);

final positionSourceProvider = Provider<PositionSource>((_) => _devicePositions);

/// Shares the driver's position while on duty, and nothing otherwise. The state
/// is what the screens show: points sent, buffered, failures, last fix.
class LocationSharing extends Notifier<ReporterState> {
  LocationReporter? _reporter;
  VoidCallback? _detach;

  @override
  ReporterState build() {
    ref.onDispose(_dispose);
    return const ReporterState();
  }

  bool get running => _reporter != null;

  /// Starts sharing. Safe to call again while running.
  void start({required String title, required String text}) {
    if (_reporter != null) return;
    final reporter = LocationReporter(
      source: ref.read(positionSourceProvider)(title: title, text: text),
      send: apiSender(ref.read(clientProvider)),
    );
    void relay() {
      if (ref.mounted) state = reporter.state.value;
    }
    reporter.state.addListener(relay);
    _detach = () => reporter.state.removeListener(relay);
    _reporter = reporter..start();
    state = reporter.state.value;
  }

  /// Stops at once: off duty means no more pings.
  Future<void> stop() async {
    final reporter = _reporter;
    if (reporter == null) return;
    _reporter = null;
    _detach?.call();
    await reporter.stop();
    reporter.dispose();
    if (ref.mounted) state = const ReporterState();
  }

  void _dispose() {
    _detach?.call();
    _reporter?.dispose();
    _reporter = null;
  }
}

final locationSharingProvider = NotifierProvider<LocationSharing, ReporterState>(LocationSharing.new);
