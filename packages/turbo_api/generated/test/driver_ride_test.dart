import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';

// tests for DriverRide
void main() {
  final DriverRide? instance = /* DriverRide(...) */ null;
  // TODO add properties to the entity

  group(DriverRide, () {
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

    // The road from pickup to drop-off as a Google encoded polyline (precision 5), computed by the server from the same Routes call that gives the distance. Null when no road route is known (the apps then draw the two points only). Never needs a Maps key in the app.
    // String routePolyline
    test('to test the property `routePolyline`', () async {
      // TODO
    });

    // What the student pays for this trip. Shown so the driver can see the price before acknowledging.
    // int farePesewas
    test('to test the property `farePesewas`', () async {
      // TODO
    });

    // Estimated road distance from the driver's last known position to the pickup. Null once the trip has started or if the driver has no recent position.
    // int pickupDistanceMeters
    test('to test the property `pickupDistanceMeters`', () async {
      // TODO
    });

    // Estimated time to reach the pickup. 0 once arrived, null once the trip has started.
    // int pickupEtaSeconds
    test('to test the property `pickupEtaSeconds`', () async {
      // TODO
    });

    // Estimated duration of the trip itself.
    // int routeDurationSeconds
    test('to test the property `routeDurationSeconds`', () async {
      // TODO
    });

    // DriverRideStudent student
    test('to test the property `student`', () async {
      // TODO
    });

    // DateTime assignedAt
    test('to test the property `assignedAt`', () async {
      // TODO
    });

    // DateTime acknowledgedAt
    test('to test the property `acknowledgedAt`', () async {
      // TODO
    });

    // Time after which \"student not here\" can be used. Null until the driver has arrived.
    // DateTime noShowAvailableAt
    test('to test the property `noShowAvailableAt`', () async {
      // TODO
    });

    // DateTime arrivedAt
    test('to test the property `arrivedAt`', () async {
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

    // DateTime cancelledAt
    test('to test the property `cancelledAt`', () async {
      // TODO
    });

    // Who cancelled (as `Cancellation.by`). Null unless the ride is cancelled.
    // String cancelledBy
    test('to test the property `cancelledBy`', () async {
      // TODO
    });

    // Why (as `Cancellation.reasonCode`). Null unless the ride is cancelled. The free-text note is not sent to drivers.
    // String cancelReasonCode
    test('to test the property `cancelReasonCode`', () async {
      // TODO
    });

  });
}
