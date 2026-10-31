import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';


/// tests for RidesApi
void main() {
  final instance = TurboApiGenerated().getRidesApi();

  group(RidesApi, () {
    // Cancel for free
    //
    // **Access:** student.  Free at every stage until the trip starts, including after the driver arrives. Releases the hold, or refunds in full if already charged. 409 `ride_not_cancellable` once in_progress.
    //
    //Future<Ride> cancelRide(String id, CancelRequest cancelRequest) async
    test('test cancelRide', () async {
      // TODO
    });

    // Accept the revised fare
    //
    // **Access:** student. **Release:** v1.1 (do not build for v1).
    //
    //Future<Ride> confirmDestinationChange(String id, DestinationChangeConfirm destinationChangeConfirm) async
    test('test confirmDestinationChange', () async {
      // TODO
    });

    // Check eligibility, distance, fare and wallet
    //
    // **Access:** student.  Server is the only authority on eligibility and fare. Checks: verified student, no active ride, both points inside the boundary, road distance within the limit, drivers on duty. Ineligible answers are 200 with `eligible:false`.
    //
    //Future<Quote> createQuote(QuoteRequest quoteRequest) async
    test('test createQuote', () async {
      // TODO
    });

    // Confirm a quote: hold funds and start finding a driver
    //
    // **Access:** student.  Errors: 409 `insufficient_balance`, `quote_expired`, `active_ride_exists`. Holds the fare in the wallet, then the assignment engine starts. Safe to retry with the same Idempotency-Key.
    //
    //Future<Ride> createRide(String idempotencyKey, RideCreate rideCreate) async
    test('test createRide', () async {
      // TODO
    });

    // One of my rides
    //
    // **Access:** student.
    //
    //Future<Ride> getRide(String id) async
    test('test getRide', () async {
      // TODO
    });

    // Receipt for a completed or cancelled ride
    //
    // **Access:** student.
    //
    //Future<Receipt> getRideReceipt(String id) async
    test('test getRideReceipt', () async {
      // TODO
    });

    // Driver location and ETA
    //
    // **Access:** student.
    //
    //Future<Tracking> getRideTracking(String id) async
    test('test getRideTracking', () async {
      // TODO
    });

    // My trip history
    //
    // **Access:** student.
    //
    //Future<RideList> listMyRides({ RideStatus status, String cursor, int limit }) async
    test('test listMyRides', () async {
      // TODO
    });

    // Quick messages on this ride
    //
    // **Access:** student or driver on this ride.
    //
    //Future<QuickMessageList> listRideMessages(String id) async
    test('test listRideMessages', () async {
      // TODO
    });

    // Get a revised fare for a new destination
    //
    // **Access:** student. **Release:** v1.1 (do not build for v1).  Proposed rule from the requirements, still to be confirmed by Turbo.
    //
    //Future<Quote> proposeDestinationChange(String id, DestinationChange destinationChange) async
    test('test proposeDestinationChange', () async {
      // TODO
    });

    // Rate a completed ride
    //
    // **Access:** student.
    //
    //Future rateRide(String id, RatingCreate ratingCreate) async
    test('test rateRide', () async {
      // TODO
    });

    // Send a quick message to the other party
    //
    // **Access:** student or driver on this ride.  Preset messages only. No phone numbers are shared (D17). Delivered by push.
    //
    //Future sendRideMessage(String id, QuickMessageSend quickMessageSend) async
    test('test sendRideMessage', () async {
      // TODO
    });

  });
}
