import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';


/// tests for VerificationApi
void main() {
  final instance = TurboApiGenerated().getVerificationApi();

  group(VerificationApi, () {
    // My verification status
    //
    // **Access:** student.
    //
    //Future<VerificationState> getMyVerification() async
    test('test getMyVerification', () async {
      // TODO
    });

    // Submit or resubmit Ghana Card and student ID
    //
    // **Access:** student.  409 `verification_not_resubmittable` when status is pending, approved or rejected.
    //
    //Future<VerificationState> submitVerification(VerificationSubmission verificationSubmission) async
    test('test submitVerification', () async {
      // TODO
    });

  });
}
