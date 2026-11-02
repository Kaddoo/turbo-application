import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turbo_api/turbo_api.dart';

import 'profile.dart';
import 'providers.dart';

/// The driver's documents (CR-5) and the supervisor's phone number (CR-6), read
/// from the profile and the app config (contract 0.5.0). [SampleGaps] stands in
/// when a build is made with SAMPLE_DRIVER_DATA, to look at the screens.
enum DriverDocType { driversLicence, vehicleRegistration, insurance, roadworthy }

enum DocStatus { valid, expiring, expired }

@immutable
class DriverDoc {
  const DriverDoc(this.type, this.expiresOn, [this.serverStatus]);

  final DriverDocType type;
  final DateTime? expiresOn;

  /// What the server said (it counts days on the Accra date). Null only for sample data.
  final DocStatus? serverStatus;

  /// Expiring means under 30 days left. The server decides; the phone works it out only for sample data.
  DocStatus get status {
    final said = serverStatus;
    if (said != null) return said;
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

/// What the server says: the profile's documents and the app config's supervisor number. Null when it says nothing.
class ApiGaps implements DriverGaps {
  const ApiGaps(this.ref);

  final Ref ref;

  @override
  Future<List<DriverDoc>?> documents() async {
    final loaded = await ref.watch(profileProvider.future);
    final docs = loaded is ProfileLoaded ? loaded.profile.documents : null;
    if (docs == null) return null;
    return [
      for (final d in docs)
        DriverDoc(
          switch (d.type) {
            DriverDocumentKind.driversLicence => DriverDocType.driversLicence,
            DriverDocumentKind.vehicleRegistration => DriverDocType.vehicleRegistration,
            DriverDocumentKind.insurance => DriverDocType.insurance,
            DriverDocumentKind.roadworthy => DriverDocType.roadworthy,
          },
          d.expiresOn,
          switch (d.status) {
            DriverDocumentStatusStatusEnum.valid => DocStatus.valid,
            DriverDocumentStatusStatusEnum.expiring => DocStatus.expiring,
            DriverDocumentStatusStatusEnum.expired => DocStatus.expired,
          },
        ),
    ];
  }

  @override
  Future<String?> supervisorPhone() async {
    try {
      final phone = (await ref.read(clientProvider).api.getMetaApi().getAppConfig()).data?.supervisorPhone;
      return (phone == null || phone.isEmpty) ? null : phone;
    } catch (_) {
      return null;
    }
  }
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
  (ref) => const bool.fromEnvironment('SAMPLE_DRIVER_DATA') ? const SampleGaps() : ApiGaps(ref),
);

final driverDocsProvider = FutureProvider.autoDispose<List<DriverDoc>?>((ref) => ref.watch(driverGapsProvider).documents());

final supervisorPhoneProvider = FutureProvider.autoDispose<String?>((ref) => ref.watch(driverGapsProvider).supervisorPhone());
