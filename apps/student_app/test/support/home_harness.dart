import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_app/src/app.dart';
import 'package:student_app/src/core/token_store.dart';
import 'package:student_app/src/features/home/location_service.dart';
import 'package:student_app/src/features/home/map_view.dart';
import 'package:student_app/src/features/home/place_search.dart';
import 'package:turbo_api/turbo_api.dart';

import 'fake_server.dart';

class FakeLocation implements LocationService {
  FakeLocation(this.result);

  UserLocation result;
  int asked = 0;
  int settingsOpened = 0;

  @override
  Future<LocationStatus> status() async => result.status;

  @override
  Future<UserLocation> current({bool ask = true}) async {
    if (ask) asked++;
    return result;
  }

  @override
  Future<void> openSettings() async => settingsOpened++;
}

class FakeSearch implements PlaceSearch {
  FakeSearch({this.available = true, this.suggestions = const []});

  @override
  final bool available;
  final List<PlaceSuggestion> suggestions;
  final queries = <String>[];

  @override
  Future<List<PlaceSuggestion>> search(String query, {List<double>? bounds}) async {
    queries.add(query);
    return suggestions;
  }

  @override
  Future<Location> resolve(PlaceSuggestion s) async =>
      Location(point: GeoPoint(lat: 5.80, lng: 0.05), label: s.title);

  @override
  void newSession() {}
}

const pickupA = {'id': '0190a1b2-0000-7e4f-8a5b-0000000000a1', 'name': 'Main gate', 'point': {'lat': 5.7400, 'lng': 0.0660}, 'isActive': true};
const pickupB = {'id': '0190a1b2-0000-7e4f-8a5b-0000000000b2', 'name': 'Hostel block', 'point': {'lat': 5.7500, 'lng': 0.0700}, 'isActive': true};

Map<String, Object?> serviceArea({List<Object?> points = const [pickupA, pickupB]}) => {
      'version': 1,
      'boundary': null,
      'pickupPoints': points,
      'maxTripDistanceMeters': 18000,
      'fareBands': [
        {'upToMeters': 3000, 'farePesewas': 1800},
        {'upToMeters': 6000, 'farePesewas': 2500},
      ],
      'operatingHours': null,
    };

Map<String, Object?> wallet({int available = 6000}) =>
    {'balancePesewas': available, 'reservedPesewas': 0, 'availablePesewas': available, 'currency': 'GHS'};

Map<String, Object?> savedPlace(String label) => {
      'id': '0190a1b2-0000-7e4f-8a5b-0000000000c3',
      'label': label,
      'location': {'point': {'lat': 5.76, 'lng': 0.08}, 'label': '$label place'},
    };

Map<String, Object?> quote({
  bool eligible = true,
  int fare = 3500,
  int available = 6000,
  List<Map<String, Object?>> reasons = const [],
  String? expiresAt,
}) =>
    {
      'eligible': eligible,
      'quoteId': eligible ? '0190a1b2-0000-7e4f-8a5b-0000000000d4' : null,
      'reasons': reasons,
      'routeDistanceMeters': eligible ? 9400 : null,
      'routeDurationSeconds': eligible ? 780 : null,
      'farePesewas': eligible ? fare : null,
      'pickupEtaSeconds': eligible ? 240 : null,
      'expiresAt': expiresAt ?? '2099-01-01T00:00:00Z',
      'wallet': {
        'availablePesewas': available,
        'sufficient': available >= fare,
        'shortfallPesewas': available >= fare ? 0 : fare - available,
      },
    };

FakeServer homeServer({bool paused = false}) => FakeServer()
  ..on('GET /app-config', body: {...appConfig(paused: paused), if (paused) 'pauseMessage': 'Back after exams.'})
  ..on('GET /legal', body: legal)
  ..on('POST /auth/refresh', body: tokens(refresh: 'refresh-2'))
  ..on('GET /me', body: student())
  ..on('GET /service-area', body: serviceArea())
  ..on('GET /wallet', body: wallet())
  ..on('GET /me/saved-places', body: {'data': [savedPlace('Hostel')]});

Future<List<MapSpec>> bootHome(
  WidgetTester tester,
  FakeServer server, {
  FakeLocation? location,
  FakeSearch? search,
  Size size = const Size(390, 900),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final specs = <MapSpec>[];
  await tester.pumpWidget(
    ProviderScope(
      retry: (_, _) => null,
      overrides: [
        ...server.overrides(store: MemoryTokenStore('refresh-1')),
        locationServiceProvider.overrideWithValue(location ?? FakeLocation(UserLocation(LocationStatus.granted, GeoPoint(lat: 5.7405, lng: 0.0662)))),
        placeSearchProvider.overrideWithValue(search ?? FakeSearch(available: false)),
        mapBuilderProvider.overrideWithValue((context, spec) {
          specs.add(spec);
          return const SizedBox.expand(key: Key('map'));
        }),
      ],
      child: const App(),
    ),
  );
  await tester.pumpAndSettle();
  return specs;
}
