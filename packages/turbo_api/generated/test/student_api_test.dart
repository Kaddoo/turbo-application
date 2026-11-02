import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';


/// tests for StudentApi
void main() {
  final instance = TurboApiGenerated().getStudentApi();

  group(StudentApi, () {
    // Accept a newer terms or privacy version
    //
    // **Access:** student or driver. When versions change, protected endpoints return 403 `terms_not_accepted` until this is called. 403 `forbidden` for a token that is not a student. This call is exempt from the terms check, otherwise a user on old terms could never accept the new ones.
    //
    //Future acceptTerms(TermsAcceptance termsAcceptance) async
    test('test acceptTerms', () async {
      // TODO
    });

    // Search for a place inside the service area
    //
    // **Access:** student.  Official pickup points that match come first, then places from the map provider, all limited to the service area. The map provider key stays on the server. Pass the same `sessionToken` for one search (typing) and the `GET /places/{placeId}` that follows it, and a new one for the next search. An empty or one-letter `q` returns an empty list.
    //
    //Future<PlaceMatchList> autocompletePlaces(String q, { String sessionToken }) async
    test('test autocompletePlaces', () async {
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

    // My notification choices
    //
    // **Access:** student.  Ride and wallet messages are always sent; these are the optional ones. Until the student has chosen, `newsAndOffers` is false and `tips` is true.
    //
    //Future<NotificationSettings> getNotificationSettings() async
    test('test getNotificationSettings', () async {
      // TODO
    });

    // The point and label for a chosen suggestion
    //
    // **Access:** student.  404 when the id is unknown or the place is outside the service area.
    //
    //Future<Location> getPlace(String placeId, { String sessionToken }) async
    test('test getPlace', () async {
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
    // **Access:** student or driver. 403 `terms_not_accepted` until the current terms and privacy policy are accepted; 403 `forbidden` for a staff token.
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
    // **Access:** student or driver. Keeps the current session. 403 `terms_not_accepted` until the current terms and privacy policy are accepted; 403 `forbidden` for a staff token.
    //
    //Future revokeOtherSessions() async
    test('test revokeOtherSessions', () async {
      // TODO
    });

    // Sign out one device
    //
    // **Access:** student or driver. 403 `terms_not_accepted` until the current terms and privacy policy are accepted; 403 `forbidden` for a staff token.
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

    // Change my notification choices
    //
    // **Access:** student. Replaces both choices.
    //
    //Future<NotificationSettings> updateNotificationSettings(NotificationSettings notificationSettings) async
    test('test updateNotificationSettings', () async {
      // TODO
    });

  });
}
