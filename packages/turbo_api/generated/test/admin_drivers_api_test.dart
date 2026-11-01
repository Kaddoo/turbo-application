import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';


/// tests for AdminDriversApi
void main() {
  final instance = TurboApiGenerated().getAdminDriversApi();

  group(AdminDriversApi, () {
    // Attach a driver document
    //
    // **Access:** admin:hr.
    //
    //Future<DriverDocument> addDriverDocument(String id, DriverDocumentCreate driverDocumentCreate) async
    test('test addDriverDocument', () async {
      // TODO
    });

    // Create a driver and invite them by SMS
    //
    // **Access:** admin:hr. Send an `Idempotency-Key` (required). A retry with the same key and body returns the first answer and does nothing twice; the same key with a different body is 409 `idempotency_key_reused`. 409 `duplicate_phone`: that number is already registered. 409 `vehicle_already_assigned`: that vehicle already belongs to another driver.
    //
    //Future<DriverDetail> createDriver(String idempotencyKey, DriverCreate driverCreate) async
    test('test createDriver', () async {
      // TODO
    });

    // Add a vehicle
    //
    // **Access:** admin:hr. Plates are compared after uppercasing and removing every character that is not a letter or digit, so `GR-4821-24`, `gr 4821 24` and `GR482124` are one plate. A retired vehicle still counts: the plate belongs to a physical vehicle, so reactivate that vehicle instead of adding it again. 409 `duplicate_plate`; its `detail` says whether the match is active, in maintenance or retired.
    //
    //Future<Vehicle> createVehicle(VehicleWrite vehicleWrite) async
    test('test createVehicle', () async {
      // TODO
    });

    // Driver detail
    //
    // **Access:** admin:hr.
    //
    //Future<DriverDetail> getDriver(String id) async
    test('test getDriver', () async {
      // TODO
    });

    // Drivers
    //
    // **Access:** admin:hr.
    //
    //Future<DriverDetailList> listDrivers({ AccountStatus status, String dutyStatus, String cursor, int limit }) async
    test('test listDrivers', () async {
      // TODO
    });

    // Documents expiring soon or already expired
    //
    // **Access:** admin:hr.  Staff are also warned 30 days ahead by notification.
    //
    //Future<DriverDocumentExpiryList> listExpiringDocuments({ int withinDays }) async
    test('test listExpiringDocuments', () async {
      // TODO
    });

    // Vehicles
    //
    // **Access:** admin:hr.
    //
    //Future<VehicleList> listVehicles({ String cursor, int limit }) async
    test('test listVehicles', () async {
      // TODO
    });

    // Edit, suspend or assign vehicle
    //
    // **Access:** admin:hr. 409 `vehicle_already_assigned`: that vehicle already belongs to another driver.
    //
    //Future<DriverDetail> updateDriver(String id, DriverUpdate driverUpdate) async
    test('test updateDriver', () async {
      // TODO
    });

    // Edit a vehicle
    //
    // **Access:** admin:hr. Plates are compared after uppercasing and removing every character that is not a letter or digit, so `GR-4821-24`, `gr 4821 24` and `GR482124` are one plate. A retired vehicle still counts: the plate belongs to a physical vehicle, so reactivate that vehicle instead of adding it again. 409 `duplicate_plate`; its `detail` says whether the match is active, in maintenance or retired.
    //
    //Future<Vehicle> updateVehicle(String id, VehicleWrite vehicleWrite) async
    test('test updateVehicle', () async {
      // TODO
    });

  });
}
