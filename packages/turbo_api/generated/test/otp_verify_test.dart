import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';

// tests for OtpVerify
void main() {
  final OtpVerify? instance = /* OtpVerify(...) */ null;
  // TODO add properties to the entity

  group(OtpVerify, () {
    // String phone
    test('to test the property `phone`', () async {
      // TODO
    });

    // String code
    test('to test the property `code`', () async {
      // TODO
    });

    // String role
    test('to test the property `role`', () async {
      // TODO
    });

    // mobile: refresh token returned in the body. web: refresh token set as an httpOnly cookie and omitted from the body.
    // String clientType
    test('to test the property `clientType`', () async {
      // TODO
    });

    // Required on first login (terms_not_accepted if missing). Stored with time and client.
    // String acceptedTermsVersion
    test('to test the property `acceptedTermsVersion`', () async {
      // TODO
    });

    // String acceptedPrivacyVersion
    test('to test the property `acceptedPrivacyVersion`', () async {
      // TODO
    });

  });
}
