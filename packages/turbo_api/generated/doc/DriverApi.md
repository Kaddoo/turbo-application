# turbo_api_generated.api.DriverApi

## Load the API package
```dart
import 'package:turbo_api_generated/api.dart';
```

All URIs are relative to *http://localhost:4010*

Method | HTTP request | Description
------------- | ------------- | -------------
[**acknowledgeRide**](DriverApi.md#acknowledgeride) | **POST** /driver/rides/{id}/ack | Confirm I have seen the assignment
[**completeRide**](DriverApi.md#completeride) | **POST** /driver/rides/{id}/complete | Complete the trip
[**declineRide**](DriverApi.md#declineride) | **POST** /driver/rides/{id}/decline | Report that I cannot take this ride
[**getCurrentDriverRide**](DriverApi.md#getcurrentdriverride) | **GET** /driver/rides/current | My active assignment
[**getDriverProfile**](DriverApi.md#getdriverprofile) | **GET** /driver/profile | My profile and vehicle
[**listDriverRides**](DriverApi.md#listdriverrides) | **GET** /driver/rides | My trip history
[**listMyAttendance**](DriverApi.md#listmyattendance) | **GET** /driver/attendance | My attendance
[**listMySalaryPayments**](DriverApi.md#listmysalarypayments) | **GET** /driver/salary-payments | My salary payment history
[**listMyShifts**](DriverApi.md#listmyshifts) | **GET** /driver/shifts | My shifts
[**markArrived**](DriverApi.md#markarrived) | **POST** /driver/rides/{id}/arrived | Mark arrival at pickup
[**pushLocation**](DriverApi.md#pushlocation) | **PUT** /driver/location | Send location points
[**reportRiderNoShow**](DriverApi.md#reportridernoshow) | **POST** /driver/rides/{id}/no-show | Student not here
[**setDuty**](DriverApi.md#setduty) | **PUT** /driver/duty | Go on or off duty
[**startRide**](DriverApi.md#startride) | **POST** /driver/rides/{id}/start | Start the trip with the student PIN


# **acknowledgeRide**
> DriverRide acknowledgeRide(id)

Confirm I have seen the assignment

**Access:** driver.  If this is not called within driverAckTimeoutSeconds the engine reassigns the ride. Design addition to confirm with Turbo (decision D8).

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getDriverApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.acknowledgeRide(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DriverApi->acknowledgeRide: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**DriverRide**](DriverRide.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **completeRide**
> DriverRide completeRide(id, tripLocation)

Complete the trip

**Access:** driver.  Converts the held fare into a charge in the same database transaction.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getDriverApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final TripLocation tripLocation = ; // TripLocation | 

try {
    final response = api.completeRide(id, tripLocation);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DriverApi->completeRide: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **tripLocation** | [**TripLocation**](TripLocation.md)|  | 

### Return type

[**DriverRide**](DriverRide.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **declineRide**
> declineRide(id, declineRequest)

Report that I cannot take this ride

**Access:** driver.  The engine reassigns, excluding this driver for this ride. Allowed until the trip has started.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getDriverApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final DeclineRequest declineRequest = ; // DeclineRequest | 

try {
    api.declineRide(id, declineRequest);
} on DioException catch (e) {
    print('Exception when calling DriverApi->declineRide: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **declineRequest** | [**DeclineRequest**](DeclineRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCurrentDriverRide**
> DriverRide getCurrentDriverRide()

My active assignment

**Access:** driver.  Also the fallback when a push notification is missed.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getDriverApi();

try {
    final response = api.getCurrentDriverRide();
    print(response);
} on DioException catch (e) {
    print('Exception when calling DriverApi->getCurrentDriverRide: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**DriverRide**](DriverRide.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getDriverProfile**
> DriverProfile getDriverProfile()

My profile and vehicle

**Access:** driver.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getDriverApi();

try {
    final response = api.getDriverProfile();
    print(response);
} on DioException catch (e) {
    print('Exception when calling DriverApi->getDriverProfile: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**DriverProfile**](DriverProfile.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listDriverRides**
> DriverRideList listDriverRides(cursor, limit)

My trip history

**Access:** driver.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getDriverApi();
final String cursor = cursor_example; // String | Opaque cursor from `page.nextCursor`.
final int limit = 56; // int | 

try {
    final response = api.listDriverRides(cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DriverApi->listDriverRides: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque cursor from `page.nextCursor`. | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**DriverRideList**](DriverRideList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listMyAttendance**
> AttendanceRecordList listMyAttendance(from, to, cursor, limit)

My attendance

**Access:** driver.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getDriverApi();
final DateTime from = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime to = 2013-10-20T19:20:30+01:00; // DateTime | 
final String cursor = cursor_example; // String | Opaque cursor from `page.nextCursor`.
final int limit = 56; // int | 

try {
    final response = api.listMyAttendance(from, to, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DriverApi->listMyAttendance: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **DateTime**|  | [optional] 
 **to** | **DateTime**|  | [optional] 
 **cursor** | **String**| Opaque cursor from `page.nextCursor`. | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**AttendanceRecordList**](AttendanceRecordList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listMySalaryPayments**
> SalaryPaymentList listMySalaryPayments(cursor, limit)

My salary payment history

**Access:** driver.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getDriverApi();
final String cursor = cursor_example; // String | Opaque cursor from `page.nextCursor`.
final int limit = 56; // int | 

try {
    final response = api.listMySalaryPayments(cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DriverApi->listMySalaryPayments: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque cursor from `page.nextCursor`. | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**SalaryPaymentList**](SalaryPaymentList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listMyShifts**
> ShiftList listMyShifts(from, to, cursor, limit)

My shifts

**Access:** driver.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getDriverApi();
final DateTime from = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime to = 2013-10-20T19:20:30+01:00; // DateTime | 
final String cursor = cursor_example; // String | Opaque cursor from `page.nextCursor`.
final int limit = 56; // int | 

try {
    final response = api.listMyShifts(from, to, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DriverApi->listMyShifts: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **DateTime**|  | [optional] 
 **to** | **DateTime**|  | [optional] 
 **cursor** | **String**| Opaque cursor from `page.nextCursor`. | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**ShiftList**](ShiftList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **markArrived**
> DriverRide markArrived(id, tripLocation)

Mark arrival at pickup

**Access:** driver.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getDriverApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final TripLocation tripLocation = ; // TripLocation | 

try {
    final response = api.markArrived(id, tripLocation);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DriverApi->markArrived: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **tripLocation** | [**TripLocation**](TripLocation.md)|  | 

### Return type

[**DriverRide**](DriverRide.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **pushLocation**
> pushLocation(locationBatch)

Send location points

**Access:** driver.  Send every 5 seconds while on duty (batch up to 20 points when the connection was lost).

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getDriverApi();
final LocationBatch locationBatch = ; // LocationBatch | 

try {
    api.pushLocation(locationBatch);
} on DioException catch (e) {
    print('Exception when calling DriverApi->pushLocation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **locationBatch** | [**LocationBatch**](LocationBatch.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reportRiderNoShow**
> DriverRide reportRiderNoShow(id)

Student not here

**Access:** driver.  Only after the driver has arrived and `noShowWaitSeconds` have passed (409 `no_show_too_early` otherwise). Cancels the ride with reason `rider_no_show`; the hold is released and no fee applies. The count shows on the student's record for staff.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getDriverApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.reportRiderNoShow(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DriverApi->reportRiderNoShow: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**DriverRide**](DriverRide.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **setDuty**
> DriverProfile setDuty(dutyUpdate)

Go on or off duty

**Access:** driver.  409 `driver_has_active_ride` when going off duty with an active ride. Duty events also feed attendance.  Going on duty returns 409 `document_expired` when the driver's licence, the vehicle insurance or the roadworthy certificate has expired.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getDriverApi();
final DutyUpdate dutyUpdate = ; // DutyUpdate | 

try {
    final response = api.setDuty(dutyUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DriverApi->setDuty: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dutyUpdate** | [**DutyUpdate**](DutyUpdate.md)|  | 

### Return type

[**DriverProfile**](DriverProfile.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **startRide**
> DriverRide startRide(id, startRequest)

Start the trip with the student PIN

**Access:** driver.  Wrong PIN: 400 `invalid_pin`. Five wrong attempts lock the start for this driver: 409 `pin_locked` until an admin intervenes.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getDriverApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final StartRequest startRequest = ; // StartRequest | 

try {
    final response = api.startRide(id, startRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DriverApi->startRide: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **startRequest** | [**StartRequest**](StartRequest.md)|  | 

### Return type

[**DriverRide**](DriverRide.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

