# turbo_api_generated.api.ServiceAreaApi

## Load the API package
```dart
import 'package:turbo_api_generated/api.dart';
```

All URIs are relative to *http://localhost:4010*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getServiceArea**](ServiceAreaApi.md#getservicearea) | **GET** /service-area | Boundary, pickup points, trip limit and fare bands


# **getServiceArea**
> ServiceArea getServiceArea()

Boundary, pickup points, trip limit and fare bands

**Access:** Public.  Safe to cache for 5 minutes. Also used by the landing page.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getServiceAreaApi();

try {
    final response = api.getServiceArea();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ServiceAreaApi->getServiceArea: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ServiceArea**](ServiceArea.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

