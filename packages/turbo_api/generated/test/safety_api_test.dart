import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';


/// tests for SafetyApi
void main() {
  final instance = TurboApiGenerated().getSafetyApi();

  group(SafetyApi, () {
    // Live trip view for a trusted contact
    //
    // **Access:** Public.
    //
    //Future<PublicTripShare> getPublicTripShare(String token) async
    test('test getPublicTripShare', () async {
      // TODO
    });

    // Emergency alert to staff
    //
    // **Access:** student, driver.  Creates a high-priority incident, pushes to all on-call staff and shows on the dashboard. Needs a named responder before launch (see docs/06-risks.md).
    //
    //Future<Incident> raiseSos(SosRequest sosRequest) async
    test('test raiseSos', () async {
      // TODO
    });

    // Share live trip with trusted contacts
    //
    // **Access:** student.
    //
    //Future<TripShare> shareRide(String id, ShareCreate shareCreate) async
    test('test shareRide', () async {
      // TODO
    });

  });
}
