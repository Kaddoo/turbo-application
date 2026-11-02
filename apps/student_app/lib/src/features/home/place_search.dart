import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:uuid/uuid.dart';

import '../../core/providers.dart';
import 'geo.dart';

class PlaceSuggestion {
  const PlaceSuggestion({required this.id, required this.title, this.subtitle, this.isPickupPoint = false});

  final String id;
  final String title;
  final String? subtitle;

  /// An official campus pickup point, which the server lists before other places.
  final bool isPickupPoint;
}

/// Finds drop-off places.
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

/// Place search through the API (`GET /places/autocomplete`, `GET /places/{id}`).
/// Official pickup points come first, then places inside the service area; the
/// map provider's key stays on the server, so the app carries none.
class ApiPlaceSearch implements PlaceSearch {
  ApiPlaceSearch(this._client);

  final TurboClient _client;
  String _session = const Uuid().v4();

  /// The server decides what to return, so search is always offered.
  @override
  bool get available => true;

  @override
  void newSession() => _session = const Uuid().v4();

  @override
  Future<List<PlaceSuggestion>> search(String query, {List<double>? bounds}) async {
    // The server already limits results to the service area, so [bounds] is not sent.
    try {
      final response = await _client.api.getStudentApi().autocompletePlaces(q: query, sessionToken: _session);
      return [
        for (final m in response.data!.items)
          PlaceSuggestion(id: m.placeId, title: m.label, subtitle: m.landmark, isPickupPoint: m.isPickupPoint),
      ];
    } catch (e) {
      throw problemOf(e);
    }
  }

  @override
  Future<Location> resolve(PlaceSuggestion suggestion) async {
    try {
      final response = await _client.api.getStudentApi().getPlace(placeId: suggestion.id, sessionToken: _session);
      newSession(); // choosing a place ends the search session
      return response.data!;
    } catch (e) {
      throw problemOf(e);
    }
  }
}

final placeSearchProvider = Provider<PlaceSearch>((ref) => ApiPlaceSearch(ref.watch(clientProvider)));

/// Re-export so screens can bound searches without importing geo.dart.
List<double>? searchBounds(GeoJsonPolygon? boundary) => boundingBox(boundary);
