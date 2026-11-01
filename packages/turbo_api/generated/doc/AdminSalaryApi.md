# turbo_api_generated.api.AdminSalaryApi

## Load the API package
```dart
import 'package:turbo_api_generated/api.dart';
```

All URIs are relative to *http://localhost:4010*

Method | HTTP request | Description
------------- | ------------- | -------------
[**correctAttendance**](AdminSalaryApi.md#correctattendance) | **PATCH** /admin/attendance/{id} | Correct hours with a mandatory reason
[**createShift**](AdminSalaryApi.md#createshift) | **POST** /admin/shifts | Schedule a shift
[**deleteShift**](AdminSalaryApi.md#deleteshift) | **DELETE** /admin/shifts/{id} | Cancel a shift (soft delete)
[**getSalaryProfile**](AdminSalaryApi.md#getsalaryprofile) | **GET** /admin/drivers/{id}/salary-profile | Driver salary settings
[**listAttendance**](AdminSalaryApi.md#listattendance) | **GET** /admin/attendance | Attendance records
[**listSalaryPayments**](AdminSalaryApi.md#listsalarypayments) | **GET** /admin/salary-payments | Recorded salary payments
[**listShifts**](AdminSalaryApi.md#listshifts) | **GET** /admin/shifts | Shifts
[**recordSalaryPayment**](AdminSalaryApi.md#recordsalarypayment) | **POST** /admin/salary-payments | Record a salary payment made outside the system
[**setSalaryProfile**](AdminSalaryApi.md#setsalaryprofile) | **PUT** /admin/drivers/{id}/salary-profile | Set salary and pay period


# **correctAttendance**
> AttendanceRecord correctAttendance(id, attendanceCorrection)

Correct hours with a mandatory reason

**Access:** admin:hr.  Original values are kept in the audit log.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminSalaryApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AttendanceCorrection attendanceCorrection = ; // AttendanceCorrection | 

try {
    final response = api.correctAttendance(id, attendanceCorrection);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminSalaryApi->correctAttendance: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **attendanceCorrection** | [**AttendanceCorrection**](AttendanceCorrection.md)|  | 

### Return type

[**AttendanceRecord**](AttendanceRecord.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createShift**
> Shift createShift(shiftCreate)

Schedule a shift

**Access:** admin:hr. 409 `shift_overlap`: the driver already has a shift at that time.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminSalaryApi();
final ShiftCreate shiftCreate = ; // ShiftCreate | 

try {
    final response = api.createShift(shiftCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminSalaryApi->createShift: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **shiftCreate** | [**ShiftCreate**](ShiftCreate.md)|  | 

### Return type

[**Shift**](Shift.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteShift**
> deleteShift(id)

Cancel a shift (soft delete)

**Access:** admin:hr.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminSalaryApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.deleteShift(id);
} on DioException catch (e) {
    print('Exception when calling AdminSalaryApi->deleteShift: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getSalaryProfile**
> SalaryProfile getSalaryProfile(id)

Driver salary settings

**Access:** admin:hr.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminSalaryApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getSalaryProfile(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminSalaryApi->getSalaryProfile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**SalaryProfile**](SalaryProfile.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAttendance**
> AttendanceRecordList listAttendance(driverId, from, to, cursor, limit)

Attendance records

**Access:** admin:hr.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminSalaryApi();
final String driverId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final DateTime from = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime to = 2013-10-20T19:20:30+01:00; // DateTime | 
final String cursor = cursor_example; // String | Opaque cursor from `page.nextCursor`.
final int limit = 56; // int | 

try {
    final response = api.listAttendance(driverId, from, to, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminSalaryApi->listAttendance: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **driverId** | **String**|  | [optional] 
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

# **listSalaryPayments**
> SalaryPaymentList listSalaryPayments(driverId, cursor, limit)

Recorded salary payments

**Access:** admin:hr.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminSalaryApi();
final String driverId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String cursor = cursor_example; // String | Opaque cursor from `page.nextCursor`.
final int limit = 56; // int | 

try {
    final response = api.listSalaryPayments(driverId, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminSalaryApi->listSalaryPayments: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **driverId** | **String**|  | [optional] 
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

# **listShifts**
> ShiftList listShifts(driverId, from, to, cursor, limit)

Shifts

**Access:** admin:hr.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminSalaryApi();
final String driverId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final DateTime from = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime to = 2013-10-20T19:20:30+01:00; // DateTime | 
final String cursor = cursor_example; // String | Opaque cursor from `page.nextCursor`.
final int limit = 56; // int | 

try {
    final response = api.listShifts(driverId, from, to, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminSalaryApi->listShifts: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **driverId** | **String**|  | [optional] 
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

# **recordSalaryPayment**
> SalaryPayment recordSalaryPayment(idempotencyKey, salaryPaymentCreate)

Record a salary payment made outside the system

**Access:** admin:hr.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminSalaryApi();
final String idempotencyKey = idempotencyKey_example; // String | Client generated UUID. Reuse it when retrying the same request.
final SalaryPaymentCreate salaryPaymentCreate = ; // SalaryPaymentCreate | 

try {
    final response = api.recordSalaryPayment(idempotencyKey, salaryPaymentCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminSalaryApi->recordSalaryPayment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**| Client generated UUID. Reuse it when retrying the same request. | 
 **salaryPaymentCreate** | [**SalaryPaymentCreate**](SalaryPaymentCreate.md)|  | 

### Return type

[**SalaryPayment**](SalaryPayment.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **setSalaryProfile**
> SalaryProfile setSalaryProfile(id, salaryProfileWrite)

Set salary and pay period

**Access:** admin:hr.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminSalaryApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final SalaryProfileWrite salaryProfileWrite = ; // SalaryProfileWrite | 

try {
    final response = api.setSalaryProfile(id, salaryProfileWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminSalaryApi->setSalaryProfile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **salaryProfileWrite** | [**SalaryProfileWrite**](SalaryProfileWrite.md)|  | 

### Return type

[**SalaryProfile**](SalaryProfile.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

