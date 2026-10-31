import 'dart:async';

import 'package:dio/dio.dart';

import 'api_problem.dart';

typedef AccessTokenReader = FutureOr<String?> Function();

/// Adds `X-App-Version: <platform>/<semver>` and the bearer token to every call.
class HeadersInterceptor extends Interceptor {
  HeadersInterceptor({required this.appVersion, this.accessToken});

  final String appVersion;
  final AccessTokenReader? accessToken;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['X-App-Version'] = appVersion;
    final token = await accessToken?.call();
    if (token != null && !options.headers.containsKey('Authorization')) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

/// Retries safe reads a couple of times on a dropped connection or a 5xx.
/// Writes are never retried here: the caller retries with the same
/// [IdempotencyKey]. A 429 is never retried; it surfaces with `retryAfter`.
class RetryInterceptor extends Interceptor {
  RetryInterceptor(this.dio, {this.maxRetries = 2, this.baseDelay = const Duration(milliseconds: 400)});

  final Dio dio;
  final int maxRetries;
  final Duration baseDelay;

  static const _attemptKey = 'turbo_retry_attempt';

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final request = err.requestOptions;
    final attempt = (request.extra[_attemptKey] as int?) ?? 0;
    final status = err.response?.statusCode;
    final transient = err.response == null
        ? err.type != DioExceptionType.cancel &&
            err.type != DioExceptionType.badCertificate
        : status != null && status >= 500;
    if (request.method != 'GET' || !transient || attempt >= maxRetries) {
      return handler.next(err);
    }
    await Future<void>.delayed(baseDelay * (1 << attempt));
    request.extra[_attemptKey] = attempt + 1;
    try {
      handler.resolve(await dio.fetch<dynamic>(request));
    } on DioException catch (e) {
      handler.next(e);
    }
  }
}

/// Turns failures into [ApiProblem] so callers never see raw Dio errors.
class ProblemInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err.copyWith(error: ApiProblem.fromDio(err)));
  }
}

/// Reads the problem off a caught error.
ApiProblem problemOf(Object error) {
  if (error is ApiProblem) return error;
  if (error is DioException) {
    final inner = error.error;
    return inner is ApiProblem ? inner : ApiProblem.fromDio(error);
  }
  return const ApiProblem(code: ApiProblem.unknown, title: '');
}
