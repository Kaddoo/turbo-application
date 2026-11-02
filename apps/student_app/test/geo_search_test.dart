import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_app/src/features/home/geo.dart';
import 'package:student_app/src/features/home/place_search.dart';
import 'package:turbo_api/turbo_api.dart';

import 'support/fake_server.dart';

PickupPoint point(String id, double lat, double lng, {bool active = true}) => PickupPoint.fromJson({
      'id': '0190a1b2-0000-7e4f-8a5b-00000000000$id',
      'name': 'P$id',
      'point': {'lat': lat, 'lng': lng},
      'isActive': active,
    });

void main() {
  group('geo', () {
    test('distance is about right', () {
      // 0.01 degrees of latitude is roughly 1.11 km.
      expect(distanceMeters(5.0, 0.0, 5.01, 0.0), closeTo(1112, 5));
      expect(distanceMeters(5.0, 0.0, 5.0, 0.0), 0);
    });

    test('nearest pickup point ignores inactive ones', () {
      final near = point('1', 5.7401, 0.066, active: false);
      final far = point('2', 5.75, 0.07);
      expect(nearestPickupPoint([near, far], 5.74, 0.066)!.name, 'P2');
      expect(nearestPickupPoint(const [], 5.74, 0.066), isNull);
    });

    test('bounding box from a GeoJSON polygon uses [lng, lat] order', () {
      final polygon = GeoJsonPolygon.fromJson({
        'type': 'Polygon',
        'coordinates': [
          [
            [0.05, 5.70],
            [0.10, 5.70],
            [0.10, 5.80],
            [0.05, 5.80],
            [0.05, 5.70],
          ],
        ],
      });
      expect(boundingBox(polygon), [5.70, 0.05, 5.80, 0.10]);
      expect(boundingBox(null), isNull);
    });
  });

  group('API place search', () {
    ApiPlaceSearch searchOver(FakeServer server) => ApiPlaceSearch(TurboClient(
          baseUrl: 'http://test',
          appVersion: 'ios/1.0.0',
          accessToken: () => null,
          dio: Dio(BaseOptions(baseUrl: 'http://test'))..httpClientAdapter = server,
        ));

    test('asks the server, with one session token, and reads the matches (pickup points first)', () async {
      final server = FakeServer()
        ..on('GET /places/autocomplete', body: {
          'items': [
            {'placeId': 'pp-1', 'label': 'Main gate', 'landmark': 'By the security post', 'isPickupPoint': true},
            {'placeId': 'g-2', 'label': 'Ashaiman China Mall', 'landmark': null, 'isPickupPoint': false},
          ],
        });
      final search = searchOver(server);
      final found = await search.search('Ash');
      expect(found.map((f) => f.title), ['Main gate', 'Ashaiman China Mall']);
      expect(found.first.isPickupPoint, isTrue);
      expect(found.first.subtitle, 'By the security post');
      expect(found.last.isPickupPoint, isFalse);
      final request = server.requests.single;
      expect(request.queryParameters['q'], 'Ash');
      expect(request.queryParameters['sessionToken'], isNotEmpty);
      // No map provider key and no box leave the phone: the server limits the results.
      expect(request.headers.containsKey('X-Goog-Api-Key'), isFalse);
    });

    test('resolving a match returns its point and label, then starts a new session', () async {
      final server = FakeServer()
        ..on('GET /places/g-2', body: {'point': {'lat': 5.79, 'lng': 0.07}, 'label': 'Ashaiman China Mall'})
        ..on('GET /places/autocomplete', body: {'items': []});
      final search = searchOver(server);
      await search.search('Ash');
      final token = server.requests.last.queryParameters['sessionToken'];
      final place = await search.resolve(const PlaceSuggestion(id: 'g-2', title: 'Ashaiman China Mall'));
      expect(place.label, 'Ashaiman China Mall');
      expect(place.point.lat, 5.79);
      expect(server.requests.last.queryParameters['sessionToken'], token, reason: 'the pick uses the typing session');
      await search.search('Lib');
      expect(server.requests.last.queryParameters['sessionToken'], isNot(token), reason: 'the next search is a new session');
    });

    test('a failure is a problem the screen can show', () async {
      final server = FakeServer()..on('GET /places/autocomplete', status: 503, body: problem('internal', 503));
      expect(searchOver(server).search('Ash'), throwsA(isA<ApiProblem>()));
    });

    test('search is always offered; only the disabled stand-in says no', () {
      expect(searchOver(FakeServer()).available, isTrue);
      expect(const DisabledPlaceSearch().available, isFalse);
    });
  });
}
