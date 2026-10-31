import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';


/// tests for AdminApi
void main() {
  final instance = TurboApiGenerated().getAdminApi();

  group(AdminApi, () {
    // Change my password
    //
    // **Access:** Any staff user.  Needs the current password and a fresh TOTP code. Revokes other sessions.
    //
    //Future changeStaffPassword(PasswordChange passwordChange) async
    test('test changeStaffPassword', () async {
      // TODO
    });

    // My staff profile
    //
    // **Access:** admin:any.
    //
    //Future<StaffUser> getStaffMe() async
    test('test getStaffMe', () async {
      // TODO
    });

  });
}
