//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:dio/dio.dart';
import 'package:turbo_api_generated/src/auth/api_key_auth.dart';
import 'package:turbo_api_generated/src/auth/basic_auth.dart';
import 'package:turbo_api_generated/src/auth/bearer_auth.dart';
import 'package:turbo_api_generated/src/auth/oauth.dart';
import 'package:turbo_api_generated/src/api/admin_api.dart';
import 'package:turbo_api_generated/src/api/admin_config_api.dart';
import 'package:turbo_api_generated/src/api/admin_drivers_api.dart';
import 'package:turbo_api_generated/src/api/admin_finance_api.dart';
import 'package:turbo_api_generated/src/api/admin_rides_api.dart';
import 'package:turbo_api_generated/src/api/admin_salary_api.dart';
import 'package:turbo_api_generated/src/api/admin_staff_api.dart';
import 'package:turbo_api_generated/src/api/admin_students_api.dart';
import 'package:turbo_api_generated/src/api/admin_support_api.dart';
import 'package:turbo_api_generated/src/api/admin_verification_api.dart';
import 'package:turbo_api_generated/src/api/auth_api.dart';
import 'package:turbo_api_generated/src/api/driver_api.dart';
import 'package:turbo_api_generated/src/api/meta_api.dart';
import 'package:turbo_api_generated/src/api/rides_api.dart';
import 'package:turbo_api_generated/src/api/safety_api.dart';
import 'package:turbo_api_generated/src/api/service_area_api.dart';
import 'package:turbo_api_generated/src/api/student_api.dart';
import 'package:turbo_api_generated/src/api/support_api.dart';
import 'package:turbo_api_generated/src/api/uploads_api.dart';
import 'package:turbo_api_generated/src/api/verification_api.dart';
import 'package:turbo_api_generated/src/api/wallet_api.dart';

class TurboApiGenerated {
  static const String basePath = r'http://localhost:4010';

  final Dio dio;
  TurboApiGenerated({
    Dio? dio,
    String? basePathOverride,
    List<Interceptor>? interceptors,
  })  : 
        this.dio = dio ??
            Dio(BaseOptions(
              baseUrl: basePathOverride ?? basePath,
              connectTimeout: const Duration(milliseconds: 5000),
              receiveTimeout: const Duration(milliseconds: 3000),
            )) {
    if (interceptors == null) {
      this.dio.interceptors.addAll([
        OAuthInterceptor(),
        BasicAuthInterceptor(),
        BearerAuthInterceptor(),
        ApiKeyAuthInterceptor(),
      ]);
    } else {
      this.dio.interceptors.addAll(interceptors);
    }
  }

  void setOAuthToken(String name, String token) {
    if (this.dio.interceptors.any((i) => i is OAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is OAuthInterceptor) as OAuthInterceptor).tokens[name] = token;
    }
  }

  /// Removes the OAuth token associated with the given [name].
  ///
  /// If no [OAuthInterceptor] is registered or no token exists for the given
  /// [name], this method has no effect.
  void removeOAuthToken(String name) {
    if (this.dio.interceptors.any((i) => i is OAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is OAuthInterceptor) as OAuthInterceptor).tokens.remove(name);
    }
  }

  void setBearerAuth(String name, String token) {
    if (this.dio.interceptors.any((i) => i is BearerAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BearerAuthInterceptor) as BearerAuthInterceptor).tokens[name] = token;
    }
  }

  /// Removes the bearer authentication token associated with the given [name].
  ///
  /// If no [BearerAuthInterceptor] is registered or no token exists for the
  /// given [name], this method has no effect.
  void removeBearerAuth(String name) {
    if (this.dio.interceptors.any((i) => i is BearerAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BearerAuthInterceptor) as BearerAuthInterceptor).tokens.remove(name);
    }
  }

  void setBasicAuth(String name, String username, String password) {
    if (this.dio.interceptors.any((i) => i is BasicAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BasicAuthInterceptor) as BasicAuthInterceptor).authInfo[name] = BasicAuthInfo(username, password);
    }
  }

  /// Removes the basic authentication credentials associated with the given [name].
  ///
  /// If no [BasicAuthInterceptor] is registered or no credentials exist for the
  /// given [name], this method has no effect.
  void removeBasicAuth(String name) {
    if (this.dio.interceptors.any((i) => i is BasicAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BasicAuthInterceptor) as BasicAuthInterceptor).authInfo.remove(name);
    }
  }

  void setApiKey(String name, String apiKey) {
    if (this.dio.interceptors.any((i) => i is ApiKeyAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((element) => element is ApiKeyAuthInterceptor) as ApiKeyAuthInterceptor).apiKeys[name] = apiKey;
    }
  }

  /// Removes the API key associated with the given [name].
  ///
  /// If no [ApiKeyAuthInterceptor] is registered or no API key exists for the
  /// given [name], this method has no effect.
  void removeApiKey(String name) {
    if (this.dio.interceptors.any((i) => i is ApiKeyAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((element) => element is ApiKeyAuthInterceptor) as ApiKeyAuthInterceptor).apiKeys.remove(name);
    }
  }

  /// Get AdminApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminApi getAdminApi() {
    return AdminApi(dio);
  }

  /// Get AdminConfigApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminConfigApi getAdminConfigApi() {
    return AdminConfigApi(dio);
  }

  /// Get AdminDriversApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminDriversApi getAdminDriversApi() {
    return AdminDriversApi(dio);
  }

  /// Get AdminFinanceApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminFinanceApi getAdminFinanceApi() {
    return AdminFinanceApi(dio);
  }

  /// Get AdminRidesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminRidesApi getAdminRidesApi() {
    return AdminRidesApi(dio);
  }

  /// Get AdminSalaryApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminSalaryApi getAdminSalaryApi() {
    return AdminSalaryApi(dio);
  }

  /// Get AdminStaffApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminStaffApi getAdminStaffApi() {
    return AdminStaffApi(dio);
  }

  /// Get AdminStudentsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminStudentsApi getAdminStudentsApi() {
    return AdminStudentsApi(dio);
  }

  /// Get AdminSupportApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminSupportApi getAdminSupportApi() {
    return AdminSupportApi(dio);
  }

  /// Get AdminVerificationApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminVerificationApi getAdminVerificationApi() {
    return AdminVerificationApi(dio);
  }

  /// Get AuthApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AuthApi getAuthApi() {
    return AuthApi(dio);
  }

  /// Get DriverApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DriverApi getDriverApi() {
    return DriverApi(dio);
  }

  /// Get MetaApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  MetaApi getMetaApi() {
    return MetaApi(dio);
  }

  /// Get RidesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  RidesApi getRidesApi() {
    return RidesApi(dio);
  }

  /// Get SafetyApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  SafetyApi getSafetyApi() {
    return SafetyApi(dio);
  }

  /// Get ServiceAreaApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ServiceAreaApi getServiceAreaApi() {
    return ServiceAreaApi(dio);
  }

  /// Get StudentApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  StudentApi getStudentApi() {
    return StudentApi(dio);
  }

  /// Get SupportApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  SupportApi getSupportApi() {
    return SupportApi(dio);
  }

  /// Get UploadsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  UploadsApi getUploadsApi() {
    return UploadsApi(dio);
  }

  /// Get VerificationApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  VerificationApi getVerificationApi() {
    return VerificationApi(dio);
  }

  /// Get WalletApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  WalletApi getWalletApi() {
    return WalletApi(dio);
  }
}
