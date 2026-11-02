import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';

// tests for Settings
void main() {
  final Settings? instance = /* Settings(...) */ null;
  // TODO add properties to the entity

  group(Settings, () {
    // The home-screen notice (see AppConfig). Null clears it.
    // HomeNoticeInput announcement
    test('to test the property `announcement`', () async {
      // TODO
    });

    // int maxTripDistanceMeters (default value: 18000)
    test('to test the property `maxTripDistanceMeters`', () async {
      // TODO
    });

    // int quoteTtlSeconds (default value: 300)
    test('to test the property `quoteTtlSeconds`', () async {
      // TODO
    });

    // int driverAckTimeoutSeconds (default value: 45)
    test('to test the property `driverAckTimeoutSeconds`', () async {
      // TODO
    });

    // int noDriverTimeoutSeconds (default value: 300)
    test('to test the property `noDriverTimeoutSeconds`', () async {
      // TODO
    });

    // Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
    // int minTopupPesewas
    test('to test the property `minTopupPesewas`', () async {
      // TODO
    });

    // Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
    // int maxTopupPesewas
    test('to test the property `maxTopupPesewas`', () async {
      // TODO
    });

    // List<OperatingWindow> operatingHours
    test('to test the property `operatingHours`', () async {
      // TODO
    });

    // int driverSilenceSeconds (default value: 180)
    test('to test the property `driverSilenceSeconds`', () async {
      // TODO
    });

    // int noShowWaitSeconds (default value: 300)
    test('to test the property `noShowWaitSeconds`', () async {
      // TODO
    });

    // int quoteLimitPerMinute (default value: 10)
    test('to test the property `quoteLimitPerMinute`', () async {
      // TODO
    });

    // int smsDailyLimit (default value: 500)
    test('to test the property `smsDailyLimit`', () async {
      // TODO
    });

    // int adjustmentApprovalThresholdPesewas (default value: 5000)
    test('to test the property `adjustmentApprovalThresholdPesewas`', () async {
      // TODO
    });

    // int locationRetentionDays (default value: 90)
    test('to test the property `locationRetentionDays`', () async {
      // TODO
    });

    // When true, quotes return ineligible with code bookings_paused and the message below. Rides already underway continue.
    // bool bookingsPaused (default value: false)
    test('to test the property `bookingsPaused`', () async {
      // TODO
    });

    // String pauseMessage
    test('to test the property `pauseMessage`', () async {
      // TODO
    });

  });
}
