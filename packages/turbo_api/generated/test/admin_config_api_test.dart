import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';


/// tests for AdminConfigApi
void main() {
  final instance = TurboApiGenerated().getAdminConfigApi();

  group(AdminConfigApi, () {
    // Push an announcement
    //
    // **Access:** admin:dispatcher.  Sends a push (and shows in the app on next open). Use with `bookingsPaused` for weather or incidents.
    //
    //Future<Announcement> createAnnouncement(AnnouncementCreate announcementCreate) async
    test('test createAnnouncement', () async {
      // TODO
    });

    // Add a campus pickup point
    //
    // **Access:** admin:super_admin.
    //
    //Future<PickupPoint> createPickupPoint(PickupPointWrite pickupPointWrite) async
    test('test createPickupPoint', () async {
      // TODO
    });

    // Remove a pickup point (soft delete)
    //
    // **Access:** admin:super_admin.
    //
    //Future deletePickupPoint(String id) async
    test('test deletePickupPoint', () async {
      // TODO
    });

    // Operational settings
    //
    // **Access:** admin:super_admin.
    //
    //Future<Settings> getSettings() async
    test('test getSettings', () async {
      // TODO
    });

    // Replace the fare bands
    //
    // **Access:** admin:super_admin.  Applies to new quotes immediately. Existing quotes and active rides keep their fare.
    //
    //Future<FareBandSet> setFareBands(FareBandSet fareBandSet) async
    test('test setFareBands', () async {
      // TODO
    });

    // Replace the boundary polygon
    //
    // **Access:** admin:super_admin.
    //
    //Future<ServiceArea> setServiceArea(ServiceAreaWrite serviceAreaWrite) async
    test('test setServiceArea', () async {
      // TODO
    });

    // Update operational settings
    //
    // **Access:** admin:super_admin.
    //
    //Future<Settings> setSettings(Settings settings) async
    test('test setSettings', () async {
      // TODO
    });

    // Edit a pickup point
    //
    // **Access:** admin:super_admin.
    //
    //Future<PickupPoint> updatePickupPoint(String id, PickupPointWrite pickupPointWrite) async
    test('test updatePickupPoint', () async {
      // TODO
    });

  });
}
