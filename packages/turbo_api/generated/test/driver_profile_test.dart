import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';

// tests for DriverProfile
void main() {
  final DriverProfile? instance = /* DriverProfile(...) */ null;
  // TODO add properties to the entity

  group(DriverProfile, () {
    // UUID (v7 recommended so ids sort by creation time).
    // String id
    test('to test the property `id`', () async {
      // TODO
    });

    // String fullName
    test('to test the property `fullName`', () async {
      // TODO
    });

    // String phone
    test('to test the property `phone`', () async {
      // TODO
    });

    // String photoUrl
    test('to test the property `photoUrl`', () async {
      // TODO
    });

    // AccountStatus status
    test('to test the property `status`', () async {
      // TODO
    });

    // String dutyStatus
    test('to test the property `dutyStatus`', () async {
      // TODO
    });

    // Vehicle vehicle
    test('to test the property `vehicle`', () async {
      // TODO
    });

    // UUID (v7 recommended so ids sort by creation time).
    // String currentRideId
    test('to test the property `currentRideId`', () async {
      // TODO
    });

    // The documents that decide whether the driver may go on duty, one per type (the one that expires last). A type with no document uploaded is left out. The driver never needs the file, so no upload id or URL is sent.
    // List<DriverDocumentStatus> documents
    test('to test the property `documents`', () async {
      // TODO
    });

  });
}
