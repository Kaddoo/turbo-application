import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';

// tests for VerificationSubmission
void main() {
  final VerificationSubmission? instance = /* VerificationSubmission(...) */ null;
  // TODO add properties to the entity

  group(VerificationSubmission, () {
    // As printed on the Ghana Card.
    // String fullName
    test('to test the property `fullName`', () async {
      // TODO
    });

    // String studentIdNumber
    test('to test the property `studentIdNumber`', () async {
      // TODO
    });

    // UUID (v7 recommended so ids sort by creation time).
    // String ghanaCardFrontUploadId
    test('to test the property `ghanaCardFrontUploadId`', () async {
      // TODO
    });

    // UUID (v7 recommended so ids sort by creation time).
    // String ghanaCardBackUploadId
    test('to test the property `ghanaCardBackUploadId`', () async {
      // TODO
    });

    // UUID (v7 recommended so ids sort by creation time).
    // String studentIdUploadId
    test('to test the property `studentIdUploadId`', () async {
      // TODO
    });

    // Stored encrypted. One card, one account: a duplicate returns 409 duplicate_identity.
    // String ghanaCardNumber
    test('to test the property `ghanaCardNumber`', () async {
      // TODO
    });

    // UUID (v7 recommended so ids sort by creation time).
    // String selfieUploadId
    test('to test the property `selfieUploadId`', () async {
      // TODO
    });

  });
}
