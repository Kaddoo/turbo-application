/// Build-time settings from `--dart-define`. No secrets live here.
abstract final class Env {
  static const apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:4010');
  static const appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'dev');
}
