# turbo_api_generated.api.SafetyApi

## Load the API package
```dart
import 'package:turbo_api_generated/api.dart';
```

All URIs are relative to *http://localhost:4010*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getPublicTripShare**](SafetyApi.md#getpublictripshare) | **GET** /public/trip-shares/{token} | Live trip view for a trusted contact
[**raiseSos**](SafetyApi.md#raisesos) | **POST** /safety/sos | Emergency alert to staff
[**shareRide**](SafetyApi.md#shareride) | **POST** /rides/{id}/share | Share live trip with trusted contacts


# **getPublicTripShare**
> PublicTripShare getPublicTripShare(token)

Live trip view for a trusted contact

**Access:** Public.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getSafetyApi();
final String token = token_example; // String | 

try {
    final response = api.getPublicTripShare(token);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SafetyApi->getPublicTripShare: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **token** | **String**|  | 

### Return type

[**PublicTripShare**](PublicTripShare.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **raiseSos**
> Incident raiseSos(sosRequest)

Emergency alert to staff

**Access:** student, driver.  Creates a high-priority incident, pushes to all on-call staff and shows on the dashboard. Needs a named responder before launch (see docs/06-risks.md).

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getSafetyApi();
final SosRequest sosRequest = ; // SosRequest | 

try {
    final response = api.raiseSos(sosRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SafetyApi->raiseSos: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **sosRequest** | [**SosRequest**](SosRequest.md)|  | 

### Return type

[**Incident**](Incident.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **shareRide**
> TripShare shareRide(id, shareCreate)

Share live trip with trusted contacts

**Access:** student.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getSafetyApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final ShareCreate shareCreate = ; // ShareCreate | 

try {
    final response = api.shareRide(id, shareCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SafetyApi->shareRide: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **shareCreate** | [**ShareCreate**](ShareCreate.md)|  | 

### Return type

[**TripShare**](TripShare.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

