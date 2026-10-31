import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';


/// tests for AdminRidesApi
void main() {
  final instance = TurboApiGenerated().getAdminRidesApi();

  group(AdminRidesApi, () {
    // Cancel a ride on the student's behalf
    //
    // **Access:** admin:dispatcher.
    //
    //Future<AdminRideDetail> adminCancelRide(String id, AdminCancelRequest adminCancelRequest) async
    test('test adminCancelRide', () async {
      // TODO
    });

    // Complete a stuck ride on the driver's behalf
    //
    // **Access:** admin:dispatcher.  Only for a ride in `in_progress`. Charges the locked fare, writes a ride event with the staff member and reason, and adds the audit entry. Use when the driver cannot complete (dead phone, app crash). A cancellation with refund is still available through the cancel endpoint.
    //
    //Future<AdminRideDetail> adminCompleteRide(String id, AdminCompleteRequest adminCompleteRequest) async
    test('test adminCompleteRide', () async {
      // TODO
    });

    // Ride with full event timeline
    //
    // **Access:** admin:dispatcher.
    //
    //Future<AdminRideDetail> getAdminRide(String id) async
    test('test getAdminRide', () async {
      // TODO
    });

    // Active rides and on-duty drivers for the live map
    //
    // **Access:** admin:dispatcher.
    //
    //Future<LiveRides> getLiveRides() async
    test('test getLiveRides', () async {
      // TODO
    });

    // All rides
    //
    // **Access:** admin:dispatcher.
    //
    //Future<AdminRideSummaryList> listAllRides({ RideStatus status, String studentId, String driverId, DateTime from, DateTime to, String cursor, int limit, RideFlag flag }) async
    test('test listAllRides', () async {
      // TODO
    });

    // Manually reassign to a driver
    //
    // **Access:** admin:dispatcher.
    //
    //Future<AdminRideDetail> reassignRide(String id, ReassignRequest reassignRequest) async
    test('test reassignRide', () async {
      // TODO
    });

  });
}
