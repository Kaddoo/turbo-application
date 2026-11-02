import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';

// tests for DriverDocumentStatus
void main() {
  final DriverDocumentStatus? instance = /* DriverDocumentStatus(...) */ null;
  // TODO add properties to the entity

  group(DriverDocumentStatus, () {
    // DriverDocumentKind type
    test('to test the property `type`', () async {
      // TODO
    });

    // DateTime expiresOn
    test('to test the property `expiresOn`', () async {
      // TODO
    });

    // Whole days from today (Africa/Accra) to `expiresOn`, negative once expired. Null when the document has no expiry.
    // int daysLeft
    test('to test the property `daysLeft`', () async {
      // TODO
    });

    // `expiring` is under 30 days left; `expired` is past `expiresOn`. Computed by the server so the phone clock does not matter.
    // String status
    test('to test the property `status`', () async {
      // TODO
    });

  });
}
