import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_app/src/features/home/location_service.dart';
import 'package:student_app/src/features/home/place_search.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';

import 'ride_test.dart' show ride, rideList;
import 'support/fake_server.dart';
import 'support/home_harness.dart';

void main() {
  group('home', () {
    testWidgets('lays out in dark mode and at 200% text without overflow', (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      addTearDown(tester.platformDispatcher.clearAllTestValues);
      await bootHome(tester, homeServer());
      expect(find.text('Where to?'), findsOneWidget);
      expect(tester.takeException(), isNull);
      final theme = Theme.of(tester.element(find.text('Where to?')));
      expect(theme.brightness, Brightness.dark);
    });

    testWidgets('shows the map with pickup points, the Where to bar, saved places and the wallet', (tester) async {
      final specs = await bootHome(tester, homeServer());
      expect(find.byKey(const Key('map')), findsOneWidget);
      expect(specs.last.pickupPoints.map((p) => p.name), ['Main gate', 'Hostel block']);
      expect(specs.last.showMyLocation, isTrue);
      expect(specs.last.center!.lat, 5.7405);
      expect(find.text('Where to?'), findsOneWidget);
      expect(find.text('Hostel'), findsOneWidget);
      expect(find.text('Wallet GH₵60.00'), findsOneWidget);
    });

    testWidgets('a wallet below the cheapest fare is flagged, with words not just colour', (tester) async {
      final server = homeServer()..on('GET /wallet', body: wallet(available: 600));
      await bootHome(tester, server);
      expect(find.text('Wallet GH₵6.00, low'), findsOneWidget);
    });

    testWidgets('bookings paused disables the bar and shows the server message', (tester) async {
      await bootHome(tester, homeServer(paused: true));
      expect(find.text('Back after exams.'), findsOneWidget);
      final bar = tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Where to?'));
      expect(bar.onPressed, isNull);
    });

    testWidgets('location denied explains why and offers a way forward', (tester) async {
      final location = FakeLocation(const UserLocation(LocationStatus.denied));
      await bootHome(tester, homeServer(), location: location);
      expect(find.text('Location is off'), findsOneWidget);
      expect(find.textContaining('nearest pickup point'), findsOneWidget);
      location.result = UserLocation(LocationStatus.granted, GeoPoint(lat: 5.74, lng: 0.066));
      await tester.tap(find.text('Allow location'));
      await tester.pumpAndSettle();
      expect(find.text('Location is off'), findsNothing);
    });

    testWidgets('permission blocked in Settings sends the person to Settings', (tester) async {
      final location = FakeLocation(const UserLocation(LocationStatus.deniedForever));
      await bootHome(tester, homeServer(), location: location);
      await tester.tap(find.text('Allow location'));
      await tester.pumpAndSettle();
      expect(location.settingsOpened, 1);
    });

    testWidgets('location services off says how to switch them on', (tester) async {
      await bootHome(tester, homeServer(), location: FakeLocation(const UserLocation(LocationStatus.servicesOff)));
      expect(find.textContaining('Switch on location'), findsOneWidget);
    });

    testWidgets('a failed load shows an error with Try again, then recovers', (tester) async {
      final server = homeServer()..on('GET /service-area', status: 503, body: problem('service_unavailable', 503));
      await bootHome(tester, server);
      expect(find.textContaining("couldn't load the map details"), findsOneWidget);
      server.on('GET /service-area', body: serviceArea());
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();
      expect(find.text('Where to?'), findsOneWidget);
    });

    testWidgets('no pickup points yet still lets the student book from their location', (tester) async {
      final server = homeServer()..on('GET /service-area', body: serviceArea(points: const []));
      await bootHome(tester, server);
      expect(find.text('Where to?'), findsOneWidget);
    });
  });

  group('destination', () {
    testWidgets('pickup defaults to the nearest official point and can be changed', (tester) async {
      await bootHome(tester, homeServer());
      await tester.tap(find.widgetWithText(FilledButton, 'Where to?'));
      await tester.pumpAndSettle();
      expect(find.text('Main gate'), findsOneWidget);
      await tester.tap(find.text('Main gate'));
      await tester.pumpAndSettle();
      // The pickup list opens above the drop-off places; choose from it.
      await tester.tap(find.widgetWithText(TurboListRow, 'Hostel block').first);
      await tester.pumpAndSettle();
      expect(find.text('Hostel block'), findsOneWidget);
      expect(find.widgetWithText(TurboListRow, 'Main gate'), findsOneWidget, reason: 'now offered as a drop-off');
    });

    testWidgets('Continue stays off until a drop-off is chosen, then asks for a price', (tester) async {
      final server = homeServer()..on('POST /rides/quote', body: quote());
      await bootHome(tester, server);
      await tester.tap(find.widgetWithText(FilledButton, 'Where to?'));
      await tester.pumpAndSettle();
      expect(tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Continue')).onPressed, isNull);
      expect(find.textContaining("isn't available"), findsNothing);
      expect(find.text('Campus and popular places'), findsOneWidget);

      await tester.tap(find.text('Hostel place'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
      await tester.pumpAndSettle();

      final body = bodyOf(server.calls('POST /rides/quote').single) as Map;
      expect(body['pickup']['label'], 'Main gate');
      expect(body['pickup']['pickupPointId'], pickupA['id']);
      expect(body['dropoff']['label'], 'Hostel place');
      expect(find.text('GH₵35.00'), findsOneWidget);
    });

    testWidgets('official points can be chosen as the drop-off, and the pickup is left out of the list', (tester) async {
      final server = homeServer()..on('POST /rides/quote', body: quote());
      await bootHome(tester, server);
      await tester.tap(find.widgetWithText(FilledButton, 'Where to?'));
      await tester.pumpAndSettle();
      // The pickup defaulted to Main gate; it is not offered as a drop-off.
      expect(find.widgetWithText(TurboListRow, 'Main gate'), findsNothing);
      await tester.tap(find.widgetWithText(TurboListRow, 'Hostel block'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
      await tester.pumpAndSettle();
      final body = bodyOf(server.calls('POST /rides/quote').single) as Map;
      expect(body['dropoff']['label'], 'Hostel block');
      expect(body['dropoff']['pickupPointId'], pickupB['id']);
    });

    testWidgets('a saved-place chip on home jumps straight to the destination screen', (tester) async {
      await bootHome(tester, homeServer());
      await tester.tap(find.text('Hostel'));
      await tester.pumpAndSettle();
      expect(find.text('Hostel place'), findsWidgets);
      expect(tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Continue')).onPressed, isNotNull);
    });

    testWidgets('search results can be chosen when place search is available', (tester) async {
      final search = FakeSearch(suggestions: const [PlaceSuggestion(id: 'p1', title: 'Ashaiman China Mall', subtitle: 'Ashaiman')]);
      await bootHome(tester, homeServer(), search: search);
      await tester.tap(find.widgetWithText(FilledButton, 'Where to?'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Ashaiman');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(search.queries, ['Ashaiman']);
      await tester.tap(find.text('Ashaiman China Mall'));
      await tester.pumpAndSettle();
      expect(find.text('Ashaiman China Mall'), findsOneWidget);
      expect(tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Continue')).onPressed, isNotNull);
    });
  });

  group('place search results', () {
    testWidgets('official pickup points show the pushpin and their landmark, in dark mode at 200% text', (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      addTearDown(tester.platformDispatcher.clearAllTestValues);
      final search = FakeSearch(suggestions: const [
        PlaceSuggestion(id: 'pp', title: 'Library', subtitle: 'Ground floor entrance', isPickupPoint: true),
        PlaceSuggestion(id: 'g', title: 'Ashaiman China Mall'),
      ]);
      await bootHome(tester, homeServer(), search: search, size: const Size(390, 2400));
      await tester.tap(find.widgetWithText(FilledButton, 'Where to?'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Lib');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(find.text('Ground floor entrance'), findsOneWidget);
      expect(find.text('Ashaiman China Mall'), findsOneWidget);
      // One result is an official point (pushpin); the other is a plain place.
      expect(find.descendant(of: find.byType(TurboListRow), matching: find.byType(TurboArtImage)), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('quote', () {
    Future<void> toQuote(WidgetTester tester, FakeServer server) async {
      await bootHome(tester, server);
      await tester.tap(find.text('Hostel'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
      await tester.pumpAndSettle();
    }

    testWidgets('eligible: the route on a map, fare in large type, fixed, wallet tiles, free cancellation', (tester) async {
      await toQuote(tester, homeServer()..on('POST /rides/quote', body: quote()));
      expect(find.byKey(const Key('map')), findsOneWidget);
      expect(find.text('GH₵35.00'), findsOneWidget);
      expect(find.text('Fixed fare'), findsOneWidget);
      expect(find.text("It won't change"), findsOneWidget);
      expect(find.text('9.4 km · about 13 min'), findsOneWidget);
      expect(find.text('Driver reaches you in about 4 min'), findsOneWidget);
      expect(find.text('Wallet'), findsOneWidget);
      expect(find.text('GH₵60.00'), findsOneWidget);
      expect(find.text('After this ride'), findsOneWidget);
      expect(find.text('GH₵25.00'), findsOneWidget);
      expect(find.text("Cancel for free until you're in the car."), findsOneWidget);
      expect(find.text('Book for GH₵35.00'), findsOneWidget);
    });

    testWidgets('short on funds shows the exact shortfall as the one action', (tester) async {
      await toQuote(tester, homeServer()..on('POST /rides/quote', body: quote(available: 2000)));
      expect(find.text('Short by'), findsOneWidget);
      expect(find.text('GH₵15.00'), findsOneWidget);
      expect(find.text('Top up with mobile money, then book this ride.'), findsOneWidget);
      expect(find.text('Top up GH₵15.00'), findsOneWidget);
      expect(find.textContaining('Book for'), findsNothing);
    });

    testWidgets('ineligible lists every reason the server gave and offers to change location', (tester) async {
      final body = quote(eligible: false, reasons: [
        {'code': 'route_too_long', 'message': 'This trip is over 18 km, which is the longest we do.'},
        {'code': 'no_drivers_on_duty', 'message': 'No drivers are available right now. Try again soon.'},
      ]);
      await toQuote(tester, homeServer()..on('POST /rides/quote', body: body));
      expect(find.text('We can\'t book this trip'), findsOneWidget);
      expect(find.text('This trip is over 18 km, which is the longest we do.'), findsOneWidget);
      expect(find.text('No drivers are available right now. Try again soon.'), findsOneWidget);
      await tester.tap(find.text('Change location'));
      await tester.pumpAndSettle();
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('a rate limit is explained with the wait, and retry works', (tester) async {
      final server = homeServer()
        ..on('POST /rides/quote', status: 429, body: problem('rate_limited', 429), headers: {'retry-after': '20'});
      await toQuote(tester, server);
      expect(find.textContaining('20 s'), findsOneWidget);
      server.on('POST /rides/quote', body: quote());
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();
      expect(find.text('GH₵35.00'), findsOneWidget);
    });

    testWidgets('a price that has expired is replaced without asking', (tester) async {
      var calls = 0;
      final server = homeServer()
        ..onCall('POST /rides/quote', (r) {
          calls++;
          return (
            status: 200,
            body: calls == 1 ? quote(expiresAt: '2000-01-01T00:00:00Z') : quote(fare: 2500),
            headers: <String, String>{},
          );
        });
      await toQuote(tester, server);
      await tester.pumpAndSettle();
      expect(calls, 2);
      expect(find.text('GH₵25.00'), findsOneWidget);
      expect(find.text('That price expired, so we got you a new one.'), findsOneWidget);
    });
  });

  group('home tiles and pickup tabs', () {
    FakeServer richHome() {
      final area = serviceArea()
        ..['operatingHours'] = [
          for (var d = 0; d < 7; d++) {'dayOfWeek': d, 'opensAt': '06:00', 'closesAt': '22:00'},
        ];
      final done = ride('completed')..['dropoff'] = {'point': {'lat': 5.75, 'lng': 0.07}, 'label': 'Library'};
      return homeServer()
        ..on('GET /service-area', body: area)
        ..on('GET /rides', body: rideList([done]));
    }

    testWidgets('closest point, ride hours and the last ride show as tiles', (tester) async {
      await bootHome(tester, richHome(), size: const Size(390, 2400));
      expect(find.text('Closest to you'), findsOneWidget);
      expect(find.textContaining(' m away'), findsOneWidget);
      expect(find.text('Ride hours'), findsOneWidget);
      expect(find.text('06:00 – 22:00'), findsOneWidget);
      expect(find.text('Last ride'), findsOneWidget);
      expect(find.text('Library'), findsOneWidget);
    });

    testWidgets('tiles with nothing to say are left out', (tester) async {
      await bootHome(tester, homeServer(), size: const Size(390, 2400));
      expect(find.text('Ride hours'), findsNothing);
      expect(find.text('Last ride'), findsNothing);
    });

    testWidgets('Choose point lists the pickup points and the chosen one is used', (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      addTearDown(tester.platformDispatcher.clearAllTestValues);
      await bootHome(tester, richHome(), size: const Size(390, 3600));
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Choose point'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(TurboChip, 'Hostel block'), findsOneWidget);
      await tester.ensureVisible(find.widgetWithText(TurboChip, 'Hostel block'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TurboChip, 'Hostel block'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Where to?'));
      await tester.pumpAndSettle();
      expect(find.text('Where to?'), findsOneWidget);
      // The destination screen opens with the chosen pickup.
      expect(find.text('Hostel block'), findsWidgets);
    });
  });
}
