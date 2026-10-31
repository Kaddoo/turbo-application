import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';


/// tests for AdminStaffApi
void main() {
  final instance = TurboApiGenerated().getAdminStaffApi();

  group(AdminStaffApi, () {
    // Invite a staff user
    //
    // **Access:** admin:super_admin.
    //
    //Future<StaffUser> createStaff(StaffCreate staffCreate) async
    test('test createStaff', () async {
      // TODO
    });

    // Who did what, when
    //
    // **Access:** admin:super_admin.
    //
    //Future<AuditEntryList> listAuditLog({ String actorStaffId, String entityType, String entityId, String cursor, int limit }) async
    test('test listAuditLog', () async {
      // TODO
    });

    // Staff users
    //
    // **Access:** admin:super_admin.
    //
    //Future<StaffUserList> listStaff({ String cursor, int limit }) async
    test('test listStaff', () async {
      // TODO
    });

    // Send or resend the invite email
    //
    // **Access:** admin:super_admin.
    //
    //Future resendStaffInvite(String id) async
    test('test resendStaffInvite', () async {
      // TODO
    });

    // Sign a staff member out everywhere
    //
    // **Access:** admin:super_admin.  Revokes refresh tokens and access-token jtis for that user. Audit-logged.
    //
    //Future revokeStaffSessions(String id) async
    test('test revokeStaffSessions', () async {
      // TODO
    });

    // Change role or deactivate
    //
    // **Access:** admin:super_admin.
    //
    //Future<StaffUser> updateStaff(String id, StaffUpdate staffUpdate) async
    test('test updateStaff', () async {
      // TODO
    });

  });
}
