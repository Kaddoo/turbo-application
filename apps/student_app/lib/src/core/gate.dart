import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turbo_api/turbo_api.dart';

import 'providers.dart';
import 'semver.dart';

enum GateStatus { open, updateRequired, maintenance }

class GateState {
  const GateState({
    this.status = GateStatus.open,
    this.bookingsPaused = false,
    this.pauseMessage,
    this.maintenanceMessage,
    this.offline = false,
  });

  final GateStatus status;
  final bool bookingsPaused;
  final String? pauseMessage;
  final String? maintenanceMessage;

  /// The last check could not reach the server. The app carries on.
  final bool offline;
}

GateState gateFrom(AppConfig config, String platform, String version) {
  final min = switch (platform) {
    'ios' => config.minVersion.ios,
    'android' => config.minVersion.android,
    _ => config.minVersion.web,
  };
  final status = config.maintenance.active
      ? GateStatus.maintenance
      : isOlderThan(version, min)
          ? GateStatus.updateRequired
          : GateStatus.open;
  return GateState(
    status: status,
    bookingsPaused: config.bookingsPaused,
    pauseMessage: config.pauseMessage,
    maintenanceMessage: config.maintenance.message,
  );
}

/// Checked on start and on every resume. A failed check never blocks the app
/// unless the server explicitly answers 426.
class GateController extends AsyncNotifier<GateState> {
  @override
  Future<GateState> build() => _check();

  Future<GateState> _check() async {
    final version = await ref.read(appVersionProvider.future);
    try {
      final response = await ref.read(clientProvider).api.getMetaApi().getAppConfig();
      return gateFrom(response.data!, platformKey(), version);
    } catch (e) {
      final problem = problemOf(e);
      if (problem.isUpgradeRequired) return const GateState(status: GateStatus.updateRequired);
      return const GateState(offline: true);
    }
  }

  Future<void> recheck() async {
    state = AsyncData(await _check());
  }
}

final gateProvider = AsyncNotifierProvider<GateController, GateState>(GateController.new);
