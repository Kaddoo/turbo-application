import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';


/// tests for DriverApi
void main() {
  final instance = TurboApiGenerated().getDriverApi();

  group(DriverApi, () {
    // Confirm I have seen the assignment
    //
    // **Access:** driver.  If this is not called within driverAckTimeoutSeconds the engine reassigns the ride. Design addition to confirm with Turbo (decision D8). 409 `invalid_ride_state`: the ride is not in a state that allows this (for example it was cancelled or reassigned).
    //
    //Future<DriverRide> acknowledgeRide(String id) async
    test('test acknowledgeRide', () async {
      // TODO
    });

    // Complete the trip
    //
    // **Access:** driver.  Converts the held fare into a charge in the same database transaction. 409 `invalid_ride_state`: the ride is not in a state that allows this (for example it was cancelled or reassigned).
    //
    //Future<DriverRide> completeRide(String id, TripLocation tripLocation) async
    test('test completeRide', () async {
      // TODO
    });

    // Report that I cannot take this ride
    //
    // **Access:** driver.  The engine reassigns, excluding this driver for this ride. Allowed until the trip has started. 409 `invalid_ride_state`: the ride is not in a state that allows this (for example it was cancelled or reassigned).
    //
    //Future declineRide(String id, DeclineRequest declineRequest) async
    test('test declineRide', () async {
      // TODO
    });

    // My active assignment
    //
    // **Access:** driver.  Also the fallback when a push notification is missed.
    //
    //Future<DriverRide> getCurrentDriverRide() async
    test('test getCurrentDriverRide', () async {
      // TODO
    });

    // My profile and vehicle
    //
    // **Access:** driver.
    //
    //Future<DriverProfile> getDriverProfile() async
    test('test getDriverProfile', () async {
      // TODO
    });

    // My trip history
    //
    // **Access:** driver.
    //
    //Future<DriverRideList> listDriverRides({ String cursor, int limit }) async
    test('test listDriverRides', () async {
      // TODO
    });

    // My attendance
    //
    // **Access:** driver.
    //
    //Future<AttendanceRecordList> listMyAttendance({ DateTime from, DateTime to, String cursor, int limit }) async
    test('test listMyAttendance', () async {
      // TODO
    });

    // My salary payment history
    //
    // **Access:** driver.
    //
    //Future<SalaryPaymentList> listMySalaryPayments({ String cursor, int limit }) async
    test('test listMySalaryPayments', () async {
      // TODO
    });

    // My shifts
    //
    // **Access:** driver.
    //
    //Future<ShiftList> listMyShifts({ DateTime from, DateTime to, String cursor, int limit }) async
    test('test listMyShifts', () async {
      // TODO
    });

    // Mark arrival at pickup
    //
    // **Access:** driver. 409 `invalid_ride_state`: the ride is not in a state that allows this (for example it was cancelled or reassigned).
    //
    //Future<DriverRide> markArrived(String id, TripLocation tripLocation) async
    test('test markArrived', () async {
      // TODO
    });

    // Send location points
    //
    // **Access:** driver.  Send every 5 seconds while on duty (batch up to 20 points when the connection was lost).
    //
    //Future pushLocation(LocationBatch locationBatch) async
    test('test pushLocation', () async {
      // TODO
    });

    // Student not here
    //
    // **Access:** driver.  Only after the driver has arrived and `noShowWaitSeconds` have passed (409 `no_show_too_early` otherwise). Cancels the ride with reason `rider_no_show`; the hold is released and no fee applies. The count shows on the student's record for staff. 409 `invalid_ride_state`: the driver has not marked arrival. 409 `no_show_too_early`: the wait time has not passed yet.
    //
    //Future<DriverRide> reportRiderNoShow(String id) async
    test('test reportRiderNoShow', () async {
      // TODO
    });

    // Go on or off duty
    //
    // **Access:** driver.  409 `driver_has_active_ride` when going off duty with an active ride. Duty events also feed attendance.  Going on duty returns 409 `document_expired` when the driver's licence, the vehicle insurance or the roadworthy certificate has expired.
    //
    //Future<DriverProfile> setDuty(DutyUpdate dutyUpdate) async
    test('test setDuty', () async {
      // TODO
    });

    // Start the trip with the student PIN
    //
    // **Access:** driver.  Wrong PIN: 400 `invalid_pin`. Five wrong attempts lock the start for this driver: 409 `pin_locked` until an admin intervenes. 409 `invalid_ride_state`: the driver has not marked arrival at the pickup yet.
    //
    //Future<DriverRide> startRide(String id, StartRequest startRequest) async
    test('test startRide', () async {
      // TODO
    });

  });
}
