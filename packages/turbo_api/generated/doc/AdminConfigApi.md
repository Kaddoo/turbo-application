# turbo_api_generated.api.AdminConfigApi

## Load the API package
```dart
import 'package:turbo_api_generated/api.dart';
```

All URIs are relative to *http://localhost:4010*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createAnnouncement**](AdminConfigApi.md#createannouncement) | **POST** /admin/announcements | Push an announcement
[**createPickupPoint**](AdminConfigApi.md#createpickuppoint) | **POST** /admin/pickup-points | Add a campus pickup point
[**deletePickupPoint**](AdminConfigApi.md#deletepickuppoint) | **DELETE** /admin/pickup-points/{id} | Remove a pickup point (soft delete)
[**getSettings**](AdminConfigApi.md#getsettings) | **GET** /admin/settings | Operational settings
[**setFareBands**](AdminConfigApi.md#setfarebands) | **PUT** /admin/fare-bands | Replace the fare bands
[**setServiceArea**](AdminConfigApi.md#setservicearea) | **PUT** /admin/service-area | Replace the boundary polygon
[**setSettings**](AdminConfigApi.md#setsettings) | **PUT** /admin/settings | Update operational settings
[**updatePickupPoint**](AdminConfigApi.md#updatepickuppoint) | **PATCH** /admin/pickup-points/{id} | Edit a pickup point


# **createAnnouncement**
> Announcement createAnnouncement(announcementCreate)

Push an announcement

**Access:** admin:dispatcher.  Sends a push (and shows in the app on next open). Use with `bookingsPaused` for weather or incidents.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminConfigApi();
final AnnouncementCreate announcementCreate = ; // AnnouncementCreate | 

try {
    final response = api.createAnnouncement(announcementCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminConfigApi->createAnnouncement: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **announcementCreate** | [**AnnouncementCreate**](AnnouncementCreate.md)|  | 

### Return type

[**Announcement**](Announcement.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createPickupPoint**
> PickupPoint createPickupPoint(pickupPointWrite)

Add a campus pickup point

**Access:** admin:super_admin.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminConfigApi();
final PickupPointWrite pickupPointWrite = ; // PickupPointWrite | 

try {
    final response = api.createPickupPoint(pickupPointWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminConfigApi->createPickupPoint: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pickupPointWrite** | [**PickupPointWrite**](PickupPointWrite.md)|  | 

### Return type

[**PickupPoint**](PickupPoint.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deletePickupPoint**
> deletePickupPoint(id)

Remove a pickup point (soft delete)

**Access:** admin:super_admin.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminConfigApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.deletePickupPoint(id);
} on DioException catch (e) {
    print('Exception when calling AdminConfigApi->deletePickupPoint: $e\n');
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

# **getSettings**
> Settings getSettings()

Operational settings

**Access:** admin:super_admin.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminConfigApi();

try {
    final response = api.getSettings();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminConfigApi->getSettings: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**Settings**](Settings.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **setFareBands**
> FareBandSet setFareBands(fareBandSet)

Replace the fare bands

**Access:** admin:super_admin.  Applies to new quotes immediately. Existing quotes and active rides keep their fare.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminConfigApi();
final FareBandSet fareBandSet = ; // FareBandSet | 

try {
    final response = api.setFareBands(fareBandSet);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminConfigApi->setFareBands: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fareBandSet** | [**FareBandSet**](FareBandSet.md)|  | 

### Return type

[**FareBandSet**](FareBandSet.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **setServiceArea**
> ServiceArea setServiceArea(serviceAreaWrite)

Replace the boundary polygon

**Access:** admin:super_admin.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminConfigApi();
final ServiceAreaWrite serviceAreaWrite = ; // ServiceAreaWrite | 

try {
    final response = api.setServiceArea(serviceAreaWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminConfigApi->setServiceArea: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **serviceAreaWrite** | [**ServiceAreaWrite**](ServiceAreaWrite.md)|  | 

### Return type

[**ServiceArea**](ServiceArea.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **setSettings**
> Settings setSettings(settings)

Update operational settings

**Access:** admin:super_admin.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminConfigApi();
final Settings settings = ; // Settings | 

try {
    final response = api.setSettings(settings);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminConfigApi->setSettings: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **settings** | [**Settings**](Settings.md)|  | 

### Return type

[**Settings**](Settings.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updatePickupPoint**
> PickupPoint updatePickupPoint(id, pickupPointWrite)

Edit a pickup point

**Access:** admin:super_admin.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminConfigApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final PickupPointWrite pickupPointWrite = ; // PickupPointWrite | 

try {
    final response = api.updatePickupPoint(id, pickupPointWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminConfigApi->updatePickupPoint: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **pickupPointWrite** | [**PickupPointWrite**](PickupPointWrite.md)|  | 

### Return type

[**PickupPoint**](PickupPoint.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

