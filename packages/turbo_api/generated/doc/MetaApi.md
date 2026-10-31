# turbo_api_generated.api.MetaApi

## Load the API package
```dart
import 'package:turbo_api_generated/api.dart';
```

All URIs are relative to *http://localhost:4010*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getAppConfig**](MetaApi.md#getappconfig) | **GET** /app-config | Minimum versions, maintenance and pause state
[**getHealth**](MetaApi.md#gethealth) | **GET** /health | Liveness and version
[**getLegalVersions**](MetaApi.md#getlegalversions) | **GET** /legal | Current terms and privacy versions


# **getAppConfig**
> AppConfig getAppConfig()

Minimum versions, maintenance and pause state

**Access:** Public.  Call on app start and on resume. Every other request should send `X-App-Version: <platform>/<semver>`; below the minimum, the API answers 426 with code `upgrade_required`.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getMetaApi();

try {
    final response = api.getAppConfig();
    print(response);
} on DioException catch (e) {
    print('Exception when calling MetaApi->getAppConfig: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AppConfig**](AppConfig.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getHealth**
> Health getHealth()

Liveness and version

**Access:** Public.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getMetaApi();

try {
    final response = api.getHealth();
    print(response);
} on DioException catch (e) {
    print('Exception when calling MetaApi->getHealth: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**Health**](Health.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getLegalVersions**
> LegalVersions getLegalVersions()

Current terms and privacy versions

**Access:** Public.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getMetaApi();

try {
    final response = api.getLegalVersions();
    print(response);
} on DioException catch (e) {
    print('Exception when calling MetaApi->getLegalVersions: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**LegalVersions**](LegalVersions.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

