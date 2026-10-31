import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:turbo_api/turbo_api.dart';

import '../env.dart';
import 'session.dart';
import 'token_store.dart';

final tokenStoreProvider = Provider<TokenStore>((_) => SecureTokenStore());

/// Platform key used by `/app-config` and the `X-App-Version` header.
String platformKey() {
  if (kIsWeb) return 'web';
  return defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android';
}

/// The installed version, such as `1.0.0`. Overridden in tests.
final appVersionProvider = FutureProvider<String>((_) async => (await PackageInfo.fromPlatform()).version);

/// In-memory access token. Lost on restart; a refresh brings it back.
final accessTokenProvider = NotifierProvider<AccessTokenHolder, String?>(AccessTokenHolder.new);

class AccessTokenHolder extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? token) => state = token;
}

final apiBaseUrlProvider = Provider<String>((_) => Env.apiBaseUrl);

final clientProvider = Provider<TurboClient>((ref) {
  final version = ref.watch(appVersionProvider).value ?? '0.0.0';
  return TurboClient(
    baseUrl: ref.watch(apiBaseUrlProvider),
    appVersion: '${platformKey()}/$version',
    accessToken: () => ref.read(accessTokenProvider),
    refreshSession: () => ref.read(sessionProvider.notifier).refresh(),
  );
});
