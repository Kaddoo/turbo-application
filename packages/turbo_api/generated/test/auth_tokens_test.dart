import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';

// tests for AuthTokens
void main() {
  final AuthTokens? instance = /* AuthTokens(...) */ null;
  // TODO add properties to the entity

  group(AuthTokens, () {
    // JWT, 15 minutes.
    // String accessToken
    test('to test the property `accessToken`', () async {
      // TODO
    });

    // int expiresInSeconds
    test('to test the property `expiresInSeconds`', () async {
      // TODO
    });

    // Present for clientType=mobile only. Rotated on every refresh.
    // String refreshToken
    test('to test the property `refreshToken`', () async {
      // TODO
    });

    // SessionUser user
    test('to test the property `user`', () async {
      // TODO
    });

  });
}
