import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:uuid/uuid.dart';

import 'geo.dart';

class PlaceSuggestion {
  const PlaceSuggestion({required this.id, required this.title, this.subtitle});

  final String id;
  final String title;
  final String? subtitle;
}

/// Finds drop-off places. Until the contract has a search endpoint (see
/// CONTRACT_REQUESTS.md, CR-2) this talks to Google Places directly with a
/// restricted key supplied at build time.
abstract class PlaceSearch {
  bool get available;

  /// Suggestions inside the service area for [query].
  Future<List<PlaceSuggestion>> search(String query, {List<double>? bounds});

  /// The point and label for a chosen suggestion.
  Future<Location> resolve(PlaceSuggestion suggestion);

  /// Starts a new billing session. Call when the person starts typing anew.
  void newSession();
}

class DisabledPlaceSearch implements PlaceSearch {
  const DisabledPlaceSearch();

  @override
  bool get available => false;

  @override
  Future<List<PlaceSuggestion>> search(String query, {List<double>? bounds}) async => const [];

  @override
  Future<Location> resolve(PlaceSuggestion suggestion) => throw UnsupportedError('Place search is off');

  @override
  void newSession() {}
}

class GooglePlaceSearch implements PlaceSearch {
  GooglePlaceSearch({required this.apiKey, required this.bundleId, Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(connectTimeout: const Duration(seconds: 8)));

  final String apiKey;
  final String bundleId;
  final Dio _dio;
  String _session = const Uuid().v4();

  @override
  bool get available => apiKey.isNotEmpty;

  @override
  void newSession() => _session = const Uuid().v4();

  Options get _options => Options(headers: {
        'X-Goog-Api-Key': apiKey,
        'X-Ios-Bundle-Identifier': bundleId,
      });

  @override
  Future<List<PlaceSuggestion>> search(String query, {List<double>? bounds}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      'https://places.googleapis.com/v1/places:autocomplete',
      options: _options,
      data: {
        'input': query,
        'sessionToken': _session,
        'languageCode': 'en',
        'regionCode': 'GH',
        if (bounds != null)
          'locationRestriction': {
            'rectangle': {
              'low': {'latitude': bounds[0], 'longitude': bounds[1]},
              'high': {'latitude': bounds[2], 'longitude': bounds[3]},
            },
          },
      },
    );
    final suggestions = (response.data?['suggestions'] as List?) ?? const [];
    return [
      for (final s in suggestions)
        if ((s as Map)['placePrediction'] is Map)
          PlaceSuggestion(
            id: s['placePrediction']['placeId'] as String,
            title: (s['placePrediction']['structuredFormat']?['mainText']?['text'] ??
                s['placePrediction']['text']?['text'] ??
                '') as String,
            subtitle: s['placePrediction']['structuredFormat']?['secondaryText']?['text'] as String?,
          ),
    ];
  }

  @override
  Future<Location> resolve(PlaceSuggestion suggestion) async {
    final response = await _dio.get<Map<String, dynamic>>(
      'https://places.googleapis.com/v1/places/${suggestion.id}',
      queryParameters: {'sessionToken': _session},
      options: _options.copyWith(headers: {
        ..._options.headers!,
        'X-Goog-FieldMask': 'location,displayName',
      }),
    );
    final loc = response.data!['location'] as Map;
    newSession(); // a details call ends the billing session
    return Location(
      point: GeoPoint(lat: (loc['latitude'] as num).toDouble(), lng: (loc['longitude'] as num).toDouble()),
      label: suggestion.title,
    );
  }
}

/// Wired from `--dart-define=PLACES_API_KEY=...`. Empty means search is off.
final placeSearchProvider = Provider<PlaceSearch>((_) {
  const key = String.fromEnvironment('PLACES_API_KEY');
  return key.isEmpty ? const DisabledPlaceSearch() : GooglePlaceSearch(apiKey: key, bundleId: 'gh.turbo.student');
});

/// Re-export so screens can bound searches without importing geo.dart.
List<double>? searchBounds(GeoJsonPolygon? boundary) => boundingBox(boundary);
