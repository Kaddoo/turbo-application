import 'package:dio/dio.dart';

/// RFC 9457 problem details as the apps use them. Screens switch on [code].
class ApiProblem implements Exception {
  const ApiProblem({
    required this.code,
    required this.title,
    this.detail,
    this.status,
    this.retryAfter,
  });

  /// Stable machine code from the contract, such as `otp_invalid`.
  final String code;
  final String title;
  final String? detail;
  final int? status;
  final Duration? retryAfter;

  /// Codes the client invents when no problem body arrived.
  static const network = 'network_unavailable';
  static const unknown = 'unknown_error';

  bool get isRateLimited => status == 429;
  bool get isUpgradeRequired => code == 'upgrade_required';

  factory ApiProblem.fromDio(DioException e) {
    final response = e.response;
    if (response == null) {
      return const ApiProblem(code: network, title: 'No connection');
    }
    final status = response.statusCode;
    final data = response.data;
    final retry = _retryAfter(response.headers.value('retry-after'), data);
    if (data is Map && data['code'] is String) {
      return ApiProblem(
        code: data['code'] as String,
        title: (data['title'] as String?) ?? '',
        detail: data['detail'] as String?,
        status: status,
        retryAfter: retry,
      );
    }
    return ApiProblem(
      code: status == 429 ? 'rate_limited' : unknown,
      title: '',
      status: status,
      retryAfter: retry,
    );
  }

  static Duration? _retryAfter(String? header, Object? body) {
    final seconds = int.tryParse(header ?? '') ??
        (body is Map && body['retryAfterSeconds'] is int
            ? body['retryAfterSeconds'] as int
            : null);
    return seconds == null ? null : Duration(seconds: seconds);
  }

  @override
  String toString() => 'ApiProblem($code, status: $status)';
}
