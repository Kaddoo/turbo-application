import 'package:dio/dio.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';

import 'interceptors.dart';

/// The generated client with the app rules applied: version header, bearer
/// token, safe-read retries and typed problems.
class TurboClient {
  TurboClient({
    required String baseUrl,
    required String appVersion,
    AccessTokenReader? accessToken,
    Dio? dio,
  }) : dio = dio ??
            Dio(BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 15),
            )) {
    this.dio.interceptors.addAll([
      HeadersInterceptor(appVersion: appVersion, accessToken: accessToken),
      RetryInterceptor(this.dio),
      ProblemInterceptor(),
    ]);
    api = TurboApiGenerated(dio: this.dio, interceptors: const []);
  }

  final Dio dio;
  late final TurboApiGenerated api;
}
