// Gate for group 1: the generated client reads /app-config from the Prism mock.
// Start the mock first: `npm run mock` at the repo root.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_api/turbo_api.dart';

void main() {
  const base = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:4010');

  test('getAppConfig answers through the generated client', () async {
    try {
      await (await HttpClient().getUrl(Uri.parse(base))).close();
    } on SocketException {
      fail('Mock not running at $base. Run `npm run mock` first.');
    }
    final client = TurboClient(baseUrl: base, appVersion: 'ios/0.0.1');
    final response = await client.api.getMetaApi().getAppConfig();
    expect(response.statusCode, 200);
    expect(response.data, isNotNull);
    expect(response.data!.maintenance, isNotNull);
  });
}
