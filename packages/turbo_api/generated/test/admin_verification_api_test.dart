import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';


/// tests for AdminVerificationApi
void main() {
  final instance = TurboApiGenerated().getAdminVerificationApi();

  group(AdminVerificationApi, () {
    // Claim a submission for review
    //
    // **Access:** admin:verifier.  15-minute lock so two reviewers do not decide the same submission. 409 `verification_claimed` if someone else holds it. Deciding releases it.
    //
    //Future<VerificationSummary> claimVerification(String id) async
    test('test claimVerification', () async {
      // TODO
    });

    // Approve, reject or request resubmission
    //
    // **Access:** admin:verifier.  Notifies the student by push and SMS. Immutable decision record. 409 `verification_claimed`: another reviewer holds this submission. Other 409s use the generic `conflict`.
    //
    //Future<VerificationDetail> decideVerification(String id, VerificationDecision verificationDecision) async
    test('test decideVerification', () async {
      // TODO
    });

    // Submission with signed document URLs
    //
    // **Access:** admin:verifier.  Document URLs are short-lived and every call is written to the audit log.
    //
    //Future<VerificationDetail> getVerification(String id) async
    test('test getVerification', () async {
      // TODO
    });

    // Verification queue
    //
    // **Access:** admin:verifier.
    //
    //Future<VerificationSummaryList> listVerifications({ VerificationStatus status, String cursor, int limit }) async
    test('test listVerifications', () async {
      // TODO
    });

  });
}
