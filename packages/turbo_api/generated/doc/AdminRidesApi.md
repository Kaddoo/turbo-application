# turbo_api_generated.api.AdminRidesApi

## Load the API package
```dart
import 'package:turbo_api_generated/api.dart';
```

All URIs are relative to *http://localhost:4010*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminCancelRide**](AdminRidesApi.md#admincancelride) | **POST** /admin/rides/{id}/cancel | Cancel a ride on the student&#39;s behalf
[**adminCompleteRide**](AdminRidesApi.md#admincompleteride) | **POST** /admin/rides/{id}/complete | Complete a stuck ride on the driver&#39;s behalf
[**getAdminRide**](AdminRidesApi.md#getadminride) | **GET** /admin/rides/{id} | Ride with full event timeline
[**getLiveRides**](AdminRidesApi.md#getliverides) | **GET** /admin/rides/live | Active rides and on-duty drivers for the live map
[**listAllRides**](AdminRidesApi.md#listallrides) | **GET** /admin/rides | All rides
[**reassignRide**](AdminRidesApi.md#reassignride) | **POST** /admin/rides/{id}/reassign | Manually reassign to a driver


# **adminCancelRide**
> AdminRideDetail adminCancelRide(id, adminCancelRequest)

Cancel a ride on the student's behalf

**Access:** admin:dispatcher.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminRidesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AdminCancelRequest adminCancelRequest = ; // AdminCancelRequest | 

try {
    final response = api.adminCancelRide(id, adminCancelRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminRidesApi->adminCancelRide: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminCancelRequest** | [**AdminCancelRequest**](AdminCancelRequest.md)|  | 

### Return type

[**AdminRideDetail**](AdminRideDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCompleteRide**
> AdminRideDetail adminCompleteRide(id, adminCompleteRequest)

Complete a stuck ride on the driver's behalf

**Access:** admin:dispatcher.  Only for a ride in `in_progress`. Charges the locked fare, writes a ride event with the staff member and reason, and adds the audit entry. Use when the driver cannot complete (dead phone, app crash). A cancellation with refund is still available through the cancel endpoint.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminRidesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AdminCompleteRequest adminCompleteRequest = ; // AdminCompleteRequest | 

try {
    final response = api.adminCompleteRide(id, adminCompleteRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminRidesApi->adminCompleteRide: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **adminCompleteRequest** | [**AdminCompleteRequest**](AdminCompleteRequest.md)|  | 

### Return type

[**AdminRideDetail**](AdminRideDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAdminRide**
> AdminRideDetail getAdminRide(id)

Ride with full event timeline

**Access:** admin:dispatcher.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminRidesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getAdminRide(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminRidesApi->getAdminRide: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**AdminRideDetail**](AdminRideDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getLiveRides**
> LiveRides getLiveRides()

Active rides and on-duty drivers for the live map

**Access:** admin:dispatcher.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminRidesApi();

try {
    final response = api.getLiveRides();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminRidesApi->getLiveRides: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**LiveRides**](LiveRides.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAllRides**
> AdminRideSummaryList listAllRides(status, studentId, driverId, from, to, cursor, limit, flag)

All rides

**Access:** admin:dispatcher.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminRidesApi();
final RideStatus status = ; // RideStatus | 
final String studentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String driverId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final DateTime from = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime to = 2013-10-20T19:20:30+01:00; // DateTime | 
final String cursor = cursor_example; // String | Opaque cursor from `page.nextCursor`.
final int limit = 56; // int | 
final RideFlag flag = ; // RideFlag | Only rides carrying this flag.

try {
    final response = api.listAllRides(status, studentId, driverId, from, to, cursor, limit, flag);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminRidesApi->listAllRides: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | [**RideStatus**](.md)|  | [optional] 
 **studentId** | **String**|  | [optional] 
 **driverId** | **String**|  | [optional] 
 **from** | **DateTime**|  | [optional] 
 **to** | **DateTime**|  | [optional] 
 **cursor** | **String**| Opaque cursor from `page.nextCursor`. | [optional] 
 **limit** | **int**|  | [optional] [default to 20]
 **flag** | [**RideFlag**](.md)| Only rides carrying this flag. | [optional] 

### Return type

[**AdminRideSummaryList**](AdminRideSummaryList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reassignRide**
> AdminRideDetail reassignRide(id, reassignRequest)

Manually reassign to a driver

**Access:** admin:dispatcher.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminRidesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final ReassignRequest reassignRequest = ; // ReassignRequest | 

try {
    final response = api.reassignRide(id, reassignRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminRidesApi->reassignRide: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **reassignRequest** | [**ReassignRequest**](ReassignRequest.md)|  | 

### Return type

[**AdminRideDetail**](AdminRideDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

