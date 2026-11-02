import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Things the screens need that the contract does not carry yet: the driver's
/// documents (CR-5) and the supervisor's phone number (CR-6). When the contract
/// has them, only [ApiGaps] below changes; no screen does.
enum DriverDocType { driversLicence, vehicleRegistration, insurance, roadworthy }

enum DocStatus { valid, expiring, expired }

@immutable
class DriverDoc {
  const DriverDoc(this.type, this.expiresOn);

  final DriverDocType type;
  final DateTime? expiresOn;

  /// Expiring means under 30 days left. The server should say this (CR-5); until it does the phone works it out from the date.
  DocStatus get status {
    final on = expiresOn;
    if (on == null) return DocStatus.valid;
    final now = clock.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);
    final days = DateTime.utc(on.year, on.month, on.day).difference(today).inDays;
    return days < 0
        ? DocStatus.expired
        : days < 30
            ? DocStatus.expiring
            : DocStatus.valid;
  }
}

abstract class DriverGaps {
  /// Null means the app cannot tell (the contract has no documents yet).
  Future<List<DriverDoc>?> documents();

  /// Null means no number is known, so no call button is drawn.
  Future<String?> supervisorPhone();
}

/// What a real build shows until the contract has the fields: nothing invented.
class ApiGaps implements DriverGaps {
  const ApiGaps();

  @override
  Future<List<DriverDoc>?> documents() async => null;

  @override
  Future<String?> supervisorPhone() async => null;
}

/// Made-up values to look at the screens before the contract lands. Switched on only with `--dart-define=SAMPLE_DRIVER_DATA=true`, so a real build never shows them.
class SampleGaps implements DriverGaps {
  const SampleGaps();

  @override
  Future<List<DriverDoc>?> documents() async {
    final now = clock.now().toUtc();
    DateTime inDays(int d) => DateTime.utc(now.year, now.month, now.day).add(Duration(days: d));
    return [
      DriverDoc(DriverDocType.driversLicence, inDays(300)),
      DriverDoc(DriverDocType.vehicleRegistration, inDays(12)),
      DriverDoc(DriverDocType.insurance, inDays(-20)),
      DriverDoc(DriverDocType.roadworthy, inDays(200)),
    ];
  }

  @override
  Future<String?> supervisorPhone() async => '+233200000000';
}

final driverGapsProvider = Provider<DriverGaps>(
  (ref) => const bool.fromEnvironment('SAMPLE_DRIVER_DATA') ? const SampleGaps() : const ApiGaps(),
);

final driverDocsProvider = FutureProvider.autoDispose<List<DriverDoc>?>((ref) => ref.watch(driverGapsProvider).documents());

final supervisorPhoneProvider = FutureProvider.autoDispose<String?>((ref) => ref.watch(driverGapsProvider).supervisorPhone());
