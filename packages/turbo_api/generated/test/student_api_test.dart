import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';


/// tests for StudentApi
void main() {
  final instance = TurboApiGenerated().getStudentApi();

  group(StudentApi, () {
    // Accept a newer terms or privacy version
    //
    // **Access:** student or driver. When versions change, protected endpoints return 403 `terms_not_accepted` until this is called.
    //
    //Future acceptTerms(TermsAcceptance termsAcceptance) async
    test('test acceptTerms', () async {
      // TODO
    });

    // Save a destination
    //
    // **Access:** student.
    //
    //Future<SavedPlace> createSavedPlace(SavedPlaceCreate savedPlaceCreate) async
    test('test createSavedPlace', () async {
      // TODO
    });

    // Add a trusted contact
    //
    // **Access:** student.
    //
    //Future<TrustedContact> createTrustedContact(TrustedContactCreate trustedContactCreate) async
    test('test createTrustedContact', () async {
      // TODO
    });

    // Remove a saved destination
    //
    // **Access:** student.
    //
    //Future deleteSavedPlace(String id) async
    test('test deleteSavedPlace', () async {
      // TODO
    });

    // Remove a trusted contact
    //
    // **Access:** student.
    //
    //Future deleteTrustedContact(String id) async
    test('test deleteTrustedContact', () async {
      // TODO
    });

    // My profile
    //
    // **Access:** student.
    //
    //Future<Student> getMe() async
    test('test getMe', () async {
      // TODO
    });

    // My saved destinations
    //
    // **Access:** student.
    //
    //Future<SavedPlaceCollection> listSavedPlaces() async
    test('test listSavedPlaces', () async {
      // TODO
    });

    // My signed-in devices
    //
    // **Access:** student or driver.
    //
    //Future<SessionList> listSessions() async
    test('test listSessions', () async {
      // TODO
    });

    // My trusted contacts
    //
    // **Access:** student.
    //
    //Future<TrustedContactCollection> listTrustedContacts() async
    test('test listTrustedContacts', () async {
      // TODO
    });

    // Start account and data deletion
    //
    // **Access:** student.
    //
    //Future<DeletionRequest> requestDeletion() async
    test('test requestDeletion', () async {
      // TODO
    });

    // Sign out everywhere else
    //
    // **Access:** student or driver. Keeps the current session.
    //
    //Future revokeOtherSessions() async
    test('test revokeOtherSessions', () async {
      // TODO
    });

    // Sign out one device
    //
    // **Access:** student or driver.
    //
    //Future revokeSession(String id) async
    test('test revokeSession', () async {
      // TODO
    });

    // Update my profile
    //
    // **Access:** student.
    //
    //Future<Student> updateMe(StudentUpdate studentUpdate) async
    test('test updateMe', () async {
      // TODO
    });

  });
}
