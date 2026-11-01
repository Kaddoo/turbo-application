# turbo_api_generated.api.AdminDriversApi

## Load the API package
```dart
import 'package:turbo_api_generated/api.dart';
```

All URIs are relative to *http://localhost:4010*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addDriverDocument**](AdminDriversApi.md#adddriverdocument) | **POST** /admin/drivers/{id}/documents | Attach a driver document
[**createDriver**](AdminDriversApi.md#createdriver) | **POST** /admin/drivers | Create a driver and invite them by SMS
[**createVehicle**](AdminDriversApi.md#createvehicle) | **POST** /admin/vehicles | Add a vehicle
[**getDriver**](AdminDriversApi.md#getdriver) | **GET** /admin/drivers/{id} | Driver detail
[**listDrivers**](AdminDriversApi.md#listdrivers) | **GET** /admin/drivers | Drivers
[**listExpiringDocuments**](AdminDriversApi.md#listexpiringdocuments) | **GET** /admin/driver-documents/expiring | Documents expiring soon or already expired
[**listVehicles**](AdminDriversApi.md#listvehicles) | **GET** /admin/vehicles | Vehicles
[**updateDriver**](AdminDriversApi.md#updatedriver) | **PATCH** /admin/drivers/{id} | Edit, suspend or assign vehicle
[**updateVehicle**](AdminDriversApi.md#updatevehicle) | **PATCH** /admin/vehicles/{id} | Edit a vehicle


# **addDriverDocument**
> DriverDocument addDriverDocument(id, driverDocumentCreate)

Attach a driver document

**Access:** admin:hr.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminDriversApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final DriverDocumentCreate driverDocumentCreate = ; // DriverDocumentCreate | 

try {
    final response = api.addDriverDocument(id, driverDocumentCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminDriversApi->addDriverDocument: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **driverDocumentCreate** | [**DriverDocumentCreate**](DriverDocumentCreate.md)|  | 

### Return type

[**DriverDocument**](DriverDocument.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createDriver**
> DriverDetail createDriver(idempotencyKey, driverCreate)

Create a driver and invite them by SMS

**Access:** admin:hr. Send an `Idempotency-Key` (required). A retry with the same key and body returns the first answer and does nothing twice; the same key with a different body is 409 `idempotency_key_reused`. 409 `duplicate_phone`: that number is already registered. 409 `vehicle_already_assigned`: that vehicle already belongs to another driver.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminDriversApi();
final String idempotencyKey = idempotencyKey_example; // String | Client generated UUID. Reuse it when retrying the same request.
final DriverCreate driverCreate = ; // DriverCreate | 

try {
    final response = api.createDriver(idempotencyKey, driverCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminDriversApi->createDriver: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**| Client generated UUID. Reuse it when retrying the same request. | 
 **driverCreate** | [**DriverCreate**](DriverCreate.md)|  | 

### Return type

[**DriverDetail**](DriverDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createVehicle**
> Vehicle createVehicle(vehicleWrite)

Add a vehicle

**Access:** admin:hr. Plates are compared after uppercasing and removing every character that is not a letter or digit, so `GR-4821-24`, `gr 4821 24` and `GR482124` are one plate. A retired vehicle still counts: the plate belongs to a physical vehicle, so reactivate that vehicle instead of adding it again. 409 `duplicate_plate`; its `detail` says whether the match is active, in maintenance or retired.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminDriversApi();
final VehicleWrite vehicleWrite = ; // VehicleWrite | 

try {
    final response = api.createVehicle(vehicleWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminDriversApi->createVehicle: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **vehicleWrite** | [**VehicleWrite**](VehicleWrite.md)|  | 

### Return type

[**Vehicle**](Vehicle.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getDriver**
> DriverDetail getDriver(id)

Driver detail

**Access:** admin:hr.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminDriversApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getDriver(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminDriversApi->getDriver: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**DriverDetail**](DriverDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listDrivers**
> DriverDetailList listDrivers(status, dutyStatus, cursor, limit)

Drivers

**Access:** admin:hr.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminDriversApi();
final AccountStatus status = ; // AccountStatus | 
final String dutyStatus = dutyStatus_example; // String | 
final String cursor = cursor_example; // String | Opaque cursor from `page.nextCursor`.
final int limit = 56; // int | 

try {
    final response = api.listDrivers(status, dutyStatus, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminDriversApi->listDrivers: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | [**AccountStatus**](.md)|  | [optional] 
 **dutyStatus** | **String**|  | [optional] 
 **cursor** | **String**| Opaque cursor from `page.nextCursor`. | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**DriverDetailList**](DriverDetailList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listExpiringDocuments**
> DriverDocumentExpiryList listExpiringDocuments(withinDays)

Documents expiring soon or already expired

**Access:** admin:hr.  Staff are also warned 30 days ahead by notification.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminDriversApi();
final int withinDays = 56; // int | 

try {
    final response = api.listExpiringDocuments(withinDays);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminDriversApi->listExpiringDocuments: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **withinDays** | **int**|  | [optional] [default to 30]

### Return type

[**DriverDocumentExpiryList**](DriverDocumentExpiryList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listVehicles**
> VehicleList listVehicles(cursor, limit)

Vehicles

**Access:** admin:hr.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminDriversApi();
final String cursor = cursor_example; // String | Opaque cursor from `page.nextCursor`.
final int limit = 56; // int | 

try {
    final response = api.listVehicles(cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminDriversApi->listVehicles: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque cursor from `page.nextCursor`. | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**VehicleList**](VehicleList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateDriver**
> DriverDetail updateDriver(id, driverUpdate)

Edit, suspend or assign vehicle

**Access:** admin:hr. 409 `vehicle_already_assigned`: that vehicle already belongs to another driver.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminDriversApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final DriverUpdate driverUpdate = ; // DriverUpdate | 

try {
    final response = api.updateDriver(id, driverUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminDriversApi->updateDriver: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **driverUpdate** | [**DriverUpdate**](DriverUpdate.md)|  | 

### Return type

[**DriverDetail**](DriverDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateVehicle**
> Vehicle updateVehicle(id, vehicleWrite)

Edit a vehicle

**Access:** admin:hr. Plates are compared after uppercasing and removing every character that is not a letter or digit, so `GR-4821-24`, `gr 4821 24` and `GR482124` are one plate. A retired vehicle still counts: the plate belongs to a physical vehicle, so reactivate that vehicle instead of adding it again. 409 `duplicate_plate`; its `detail` says whether the match is active, in maintenance or retired.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminDriversApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final VehicleWrite vehicleWrite = ; // VehicleWrite | 

try {
    final response = api.updateVehicle(id, vehicleWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminDriversApi->updateVehicle: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **vehicleWrite** | [**VehicleWrite**](VehicleWrite.md)|  | 

### Return type

[**Vehicle**](Vehicle.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

