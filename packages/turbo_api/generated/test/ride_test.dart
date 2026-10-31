import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';

// tests for Ride
void main() {
  final Ride? instance = /* Ride(...) */ null;
  // TODO add properties to the entity

  group(Ride, () {
    // UUID (v7 recommended so ids sort by creation time).
    // String id
    test('to test the property `id`', () async {
      // TODO
    });

    // RideStatus status
    test('to test the property `status`', () async {
      // TODO
    });

    // Location pickup
    test('to test the property `pickup`', () async {
      // TODO
    });

    // Location dropoff
    test('to test the property `dropoff`', () async {
      // TODO
    });

    // int routeDistanceMeters
    test('to test the property `routeDistanceMeters`', () async {
      // TODO
    });

    // Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
    // int farePesewas
    test('to test the property `farePesewas`', () async {
      // TODO
    });

    // 4-digit start PIN. Returned only to the student who owns the ride, while status is assigned or driver_arrived.
    // String pin
    test('to test the property `pin`', () async {
      // TODO
    });

    // int pickupEtaSeconds
    test('to test the property `pickupEtaSeconds`', () async {
      // TODO
    });

    // DriverPublic driver
    test('to test the property `driver`', () async {
      // TODO
    });

    // VehiclePublic vehicle
    test('to test the property `vehicle`', () async {
      // TODO
    });

    // RidePayment payment
    test('to test the property `payment`', () async {
      // TODO
    });

    // Cancellation cancellation
    test('to test the property `cancellation`', () async {
      // TODO
    });

    // DateTime requestedAt
    test('to test the property `requestedAt`', () async {
      // TODO
    });

    // DateTime assignedAt
    test('to test the property `assignedAt`', () async {
      // TODO
    });

    // DateTime driverArrivedAt
    test('to test the property `driverArrivedAt`', () async {
      // TODO
    });

    // DateTime startedAt
    test('to test the property `startedAt`', () async {
      // TODO
    });

    // DateTime completedAt
    test('to test the property `completedAt`', () async {
      // TODO
    });

  });
}
