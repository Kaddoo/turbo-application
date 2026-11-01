import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';


/// tests for AdminStudentsApi
void main() {
  final instance = TurboApiGenerated().getAdminStudentsApi();

  group(AdminStudentsApi, () {
    // Change a student's phone number
    //
    // **Access:** admin:verifier.  Only after re-checking the Ghana Card against the account, with a support ticket as evidence. Revokes all sessions, sends an SMS to the old number, audit-logged. The wallet is unaffected. 409 `duplicate_phone`: that number belongs to another account.
    //
    //Future<Student> changeStudentPhone(String id, PhoneChange phoneChange) async
    test('test changeStudentPhone', () async {
      // TODO
    });

    // Student detail
    //
    // **Access:** admin:verifier. Verifiers (and super admins) get the full record. Support gets a reduced view: the same record without the student ID number, so they can find and help a student without seeing more than that. Every reduced view is written to the audit log (`student.view_reduced`).
    //
    //Future<StudentDetail> getStudent(String id) async
    test('test getStudent', () async {
      // TODO
    });

    // Search students
    //
    // **Access:** admin:verifier.
    //
    //Future<StudentSummaryList> listStudents({ String q, VerificationStatus verificationStatus, AccountStatus accountStatus, String cursor, int limit }) async
    test('test listStudents', () async {
      // TODO
    });

    // Sign a student out everywhere
    //
    // **Access:** admin:support. For a lost phone. Audit-logged.
    //
    //Future revokeStudentSessions(String id) async
    test('test revokeStudentSessions', () async {
      // TODO
    });

    // Suspend or reactivate
    //
    // **Access:** admin:verifier.
    //
    //Future<StudentDetail> updateStudentStatus(String id, AccountStatusUpdate accountStatusUpdate) async
    test('test updateStudentStatus', () async {
      // TODO
    });

  });
}
