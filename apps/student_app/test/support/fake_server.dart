import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:student_app/src/core/providers.dart';
import 'package:student_app/src/core/session.dart';
import 'package:student_app/src/core/token_store.dart';
import 'package:turbo_api/turbo_api.dart';

/// Request bodies reach the adapter as JSON text; this decodes them.
Object? bodyOf(RequestOptions r) => r.data is String ? jsonDecode(r.data as String) : r.data;

typedef Handler = ({int status, Object? body, Map<String, String> headers}) Function(RequestOptions request);

/// An in-memory API for widget tests. Routes are `METHOD /path`.
class FakeServer implements HttpClientAdapter {
  final Map<String, Handler> routes = {};
  final List<RequestOptions> requests = [];

  void on(String route, {int status = 200, Object? body, Map<String, String> headers = const {}}) {
    routes[route] = (request) => (status: status, body: body, headers: headers);
  }

  void onCall(String route, Handler handler) => routes[route] = handler;

  Iterable<RequestOptions> calls(String route) =>
      requests.where((r) => '${r.method} ${r.path}' == route);

  Object? lastBody(String route) => bodyOf(calls(route).last);

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    requests.add(options);
    final handler = routes['${options.method} ${options.path}'];
    if (handler == null) {
      return ResponseBody.fromString(jsonEncode({'type': 'about:blank', 'title': 'no route', 'status': 404, 'code': 'not_found'}), 404,
          headers: {Headers.contentTypeHeader: ['application/json']});
    }
    final r = handler(options);
    return ResponseBody.fromString(jsonEncode(r.body), r.status, headers: {
      Headers.contentTypeHeader: ['application/json'],
      for (final e in r.headers.entries) e.key: [e.value],
    });
  }

  @override
  void close({bool force = false}) {}

  List<Override> overrides({String version = '1.0.0', MemoryTokenStore? store}) => [
        appVersionProvider.overrideWith((_) async => version),
        tokenStoreProvider.overrideWithValue(store ?? MemoryTokenStore()),
        clientProvider.overrideWith((ref) {
          return TurboClient(
            baseUrl: 'http://test',
            appVersion: 'ios/$version',
            accessToken: () => ref.read(accessTokenProvider),
            refreshSession: () => ref.read(sessionProvider.notifier).refresh(),
            dio: Dio(BaseOptions(baseUrl: 'http://test'))..httpClientAdapter = this,
          );
        }),
      ];
}

Map<String, Object?> appConfig({String ios = '1.0.0', bool maintenance = false, bool paused = false}) => {
      'minVersion': {'ios': ios, 'android': ios, 'web': ios},
      'maintenance': {'active': maintenance, if (maintenance) 'message': 'Back at noon.'},
      'bookingsPaused': paused,
    };

Map<String, Object?> problem(String code, int status, {String title = 'Problem'}) =>
    {'type': 'about:blank', 'title': title, 'status': status, 'code': code};

Map<String, Object?> tokens({String? refresh = 'refresh-1'}) => {
      'accessToken': 'access-1',
      'expiresInSeconds': 900,
      'refreshToken': ?refresh,
      'user': {'id': '0190a1b2-7c3d-7e4f-8a5b-6c7d8e9f0a1b', 'role': 'student', 'displayName': 'Ama'},
    };

Map<String, Object?> student({String verification = 'approved'}) => {
      'id': '0190a1b2-7c3d-7e4f-8a5b-6c7d8e9f0a1b',
      'phone': '+233241234567',
      'fullName': 'Ama Mensah',
      'accountStatus': 'active',
      'verificationStatus': verification,
      'createdAt': '2026-10-01T10:00:00Z',
      'termsAcceptedVersion': '1',
    };

const legal = {
  'termsVersion': '2026-10',
  'privacyVersion': '2026-10',
  'termsUrl': 'https://example.com/terms',
  'privacyUrl': 'https://example.com/privacy',
};
