import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';


/// tests for MetaApi
void main() {
  final instance = TurboApiGenerated().getMetaApi();

  group(MetaApi, () {
    // Minimum versions, maintenance and pause state
    //
    // **Access:** Public.  Call on app start and on resume. Every other request should send `X-App-Version: <platform>/<semver>`; below the minimum, the API answers 426 with code `upgrade_required`.
    //
    //Future<AppConfig> getAppConfig() async
    test('test getAppConfig', () async {
      // TODO
    });

    // Liveness and version
    //
    // **Access:** Public.
    //
    //Future<Health> getHealth() async
    test('test getHealth', () async {
      // TODO
    });

    // Current terms and privacy versions
    //
    // **Access:** Public.
    //
    //Future<LegalVersions> getLegalVersions() async
    test('test getLegalVersions', () async {
      // TODO
    });

  });
}
