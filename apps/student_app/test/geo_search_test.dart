import 'dart:convert';

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

  group('Google place search', () {
    test('sends the key and the service-area box, and reads suggestions', () async {
      final server = FakeServer()
        ..on('POST https://places.googleapis.com/v1/places:autocomplete', body: {
          'suggestions': [
            {
              'placePrediction': {
                'placeId': 'abc',
                'text': {'text': 'Ashaiman China Mall, Ashaiman'},
                'structuredFormat': {
                  'mainText': {'text': 'Ashaiman China Mall'},
                  'secondaryText': {'text': 'Ashaiman'},
                },
              },
            },
            {'queryPrediction': {}},
          ],
        });
      final search = GooglePlaceSearch(apiKey: 'k', bundleId: 'gh.turbo.student', dio: Dio()..httpClientAdapter = server);
      final found = await search.search('Ashaiman', bounds: [5.7, 0.05, 5.8, 0.1]);
      expect(found.single.title, 'Ashaiman China Mall');
      expect(found.single.subtitle, 'Ashaiman');
      final request = server.requests.single;
      expect(request.headers['X-Goog-Api-Key'], 'k');
      expect(request.headers['X-Ios-Bundle-Identifier'], 'gh.turbo.student');
      final body = jsonDecode(request.data is String ? request.data as String : jsonEncode(request.data)) as Map;
      expect(body['locationRestriction']['rectangle']['low'], {'latitude': 5.7, 'longitude': 0.05});
      expect(body['regionCode'], 'GH');
    });

    test('resolving a suggestion returns its point and label', () async {
      final server = FakeServer()
        ..on('GET https://places.googleapis.com/v1/places/abc', body: {
          'location': {'latitude': 5.79, 'longitude': 0.07},
        });
      final search = GooglePlaceSearch(apiKey: 'k', bundleId: 'gh.turbo.student', dio: Dio()..httpClientAdapter = server);
      final place = await search.resolve(const PlaceSuggestion(id: 'abc', title: 'Ashaiman China Mall'));
      expect(place.label, 'Ashaiman China Mall');
      expect(place.point.lat, 5.79);
      expect(server.requests.single.headers['X-Goog-FieldMask'], 'location,displayName');
    });

    test('without a key, search is off', () {
      expect(GooglePlaceSearch(apiKey: '', bundleId: 'x').available, isFalse);
      expect(const DisabledPlaceSearch().available, isFalse);
    });
  });
}
