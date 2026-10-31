import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';


/// tests for ServiceAreaApi
void main() {
  final instance = TurboApiGenerated().getServiceAreaApi();

  group(ServiceAreaApi, () {
    // Boundary, pickup points, trip limit and fare bands
    //
    // **Access:** Public.  Safe to cache for 5 minutes. Also used by the landing page.
    //
    //Future<ServiceArea> getServiceArea() async
    test('test getServiceArea', () async {
      // TODO
    });

  });
}
