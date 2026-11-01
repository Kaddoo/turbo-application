import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';


/// tests for AdminSalaryApi
void main() {
  final instance = TurboApiGenerated().getAdminSalaryApi();

  group(AdminSalaryApi, () {
    // Correct hours with a mandatory reason
    //
    // **Access:** admin:hr.  Original values are kept in the audit log.
    //
    //Future<AttendanceRecord> correctAttendance(String id, AttendanceCorrection attendanceCorrection) async
    test('test correctAttendance', () async {
      // TODO
    });

    // Schedule a shift
    //
    // **Access:** admin:hr. 409 `shift_overlap`: the driver already has a shift at that time.
    //
    //Future<Shift> createShift(ShiftCreate shiftCreate) async
    test('test createShift', () async {
      // TODO
    });

    // Cancel a shift (soft delete)
    //
    // **Access:** admin:hr.
    //
    //Future deleteShift(String id) async
    test('test deleteShift', () async {
      // TODO
    });

    // Driver salary settings
    //
    // **Access:** admin:hr.
    //
    //Future<SalaryProfile> getSalaryProfile(String id) async
    test('test getSalaryProfile', () async {
      // TODO
    });

    // Attendance records
    //
    // **Access:** admin:hr.
    //
    //Future<AttendanceRecordList> listAttendance({ String driverId, DateTime from, DateTime to, String cursor, int limit }) async
    test('test listAttendance', () async {
      // TODO
    });

    // Recorded salary payments
    //
    // **Access:** admin:hr.
    //
    //Future<SalaryPaymentList> listSalaryPayments({ String driverId, String cursor, int limit }) async
    test('test listSalaryPayments', () async {
      // TODO
    });

    // Shifts
    //
    // **Access:** admin:hr.
    //
    //Future<ShiftList> listShifts({ String driverId, DateTime from, DateTime to, String cursor, int limit }) async
    test('test listShifts', () async {
      // TODO
    });

    // Record a salary payment made outside the system
    //
    // **Access:** admin:hr.
    //
    //Future<SalaryPayment> recordSalaryPayment(String idempotencyKey, SalaryPaymentCreate salaryPaymentCreate) async
    test('test recordSalaryPayment', () async {
      // TODO
    });

    // Set salary and pay period
    //
    // **Access:** admin:hr.
    //
    //Future<SalaryProfile> setSalaryProfile(String id, SalaryProfileWrite salaryProfileWrite) async
    test('test setSalaryProfile', () async {
      // TODO
    });

  });
}
