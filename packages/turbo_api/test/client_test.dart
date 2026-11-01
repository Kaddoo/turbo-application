import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_api/turbo_api.dart';

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.respond);

  final ResponseBody Function(RequestOptions options, int call) respond;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? body,
      Future<void>? cancel) async {
    requests.add(options);
    return respond(options, requests.length);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(Object body, int status, {Map<String, List<String>>? headers}) =>
    ResponseBody.fromString(jsonEncode(body), status, headers: {
      Headers.contentTypeHeader: ['application/json'],
      ...?headers,
    });

TurboClient _client(_FakeAdapter adapter, {String? token, RefreshSession? refresh}) {
  final dio = Dio(BaseOptions(baseUrl: 'http://test'))..httpClientAdapter = adapter;
  return TurboClient(
    baseUrl: 'http://test',
    appVersion: 'ios/1.2.3',
    accessToken: () => token,
    refreshSession: refresh,
    dio: dio,
  );
}

const _config = {
  'minVersion': {'ios': '1.0.0', 'android': '1.0.0', 'web': '1.0.0'},
  'maintenance': {'active': false},
  'bookingsPaused': false,
};

void main() {
  test('sends X-App-Version and the bearer token', () async {
    final adapter = _FakeAdapter((_, _) => _json(_config, 200));
    await _client(adapter, token: 'abc').api.getMetaApi().getAppConfig();
    expect(adapter.requests.single.headers['X-App-Version'], 'ios/1.2.3');
    expect(adapter.requests.single.headers['Authorization'], 'Bearer abc');
  });

  test('parses a problem into a typed ApiProblem with retryAfter', () async {
    final adapter = _FakeAdapter((_, _) => _json(
          {'type': 'about:blank', 'title': 'Slow down', 'status': 429, 'code': 'otp_rate_limited'},
          429,
          headers: {'retry-after': ['30']},
        ));
    try {
      await _client(adapter).api.getMetaApi().getAppConfig();
      fail('expected a failure');
    } catch (e) {
      final problem = problemOf(e);
      expect(problem.code, 'otp_rate_limited');
      expect(problem.retryAfter, const Duration(seconds: 30));
      expect(problem.isRateLimited, isTrue);
    }
    expect(adapter.requests, hasLength(1), reason: '429 is never retried');
  });

  test('retries a GET on 5xx then succeeds', () async {
    final adapter = _FakeAdapter((_, call) =>
        call < 3 ? _json({'title': 'x'}, 503) : _json(_config, 200));
    final response = await _client(adapter).api.getMetaApi().getAppConfig();
    expect(response.data!.bookingsPaused, isFalse);
    expect(adapter.requests, hasLength(3));
  });

  test('a dropped connection becomes network_unavailable', () async {
    final adapter = _FakeAdapter((o, _) => throw DioException.connectionError(
        requestOptions: o, reason: 'offline'));
    try {
      await _client(adapter).api.getMetaApi().getAppConfig();
      fail('expected a failure');
    } catch (e) {
      expect(problemOf(e).code, ApiProblem.network);
    }
  });

  test('a 401 refreshes once and replays with the new token', () async {
    var token = 'old';
    var refreshes = 0;
    final adapter = _FakeAdapter((o, _) => o.headers['Authorization'] == 'Bearer new'
        ? _json(_config, 200)
        : _json({'title': 'x', 'code': 'unauthenticated'}, 401));
    final client = TurboClient(
      baseUrl: 'http://test',
      appVersion: 'ios/1.0.0',
      accessToken: () => token,
      refreshSession: () async {
        refreshes++;
        token = 'new';
        return true;
      },
      dio: Dio(BaseOptions(baseUrl: 'http://test'))..httpClientAdapter = adapter,
    );
    final response = await client.api.getMetaApi().getAppConfig();
    expect(response.statusCode, 200);
    expect(refreshes, 1);
    expect(adapter.requests, hasLength(2));
  });

  test('a failed refresh surfaces the 401 and does not loop', () async {
    var refreshes = 0;
    final adapter = _FakeAdapter((_, _) => _json({'title': 'x', 'code': 'unauthenticated'}, 401));
    try {
      await _client(adapter, token: 'old', refresh: () async {
        refreshes++;
        return false;
      }).api.getMetaApi().getAppConfig();
      fail('expected a failure');
    } catch (e) {
      expect(problemOf(e).code, 'unauthenticated');
    }
    expect(refreshes, 1);
    expect(adapter.requests, hasLength(1));
  });

  test('an idempotency key is stable for one intention and new for the next', () {
    final first = IdempotencyKey();
    expect(first.headers['Idempotency-Key'], first.value);
    expect(IdempotencyKey().value, isNot(first.value));
  });
}
