# turbo_api_generated.api.AdminStaffApi

## Load the API package
```dart
import 'package:turbo_api_generated/api.dart';
```

All URIs are relative to *http://localhost:4010*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createStaff**](AdminStaffApi.md#createstaff) | **POST** /admin/staff | Invite a staff user
[**listAuditLog**](AdminStaffApi.md#listauditlog) | **GET** /admin/audit-log | Who did what, when
[**listStaff**](AdminStaffApi.md#liststaff) | **GET** /admin/staff | Staff users
[**resendStaffInvite**](AdminStaffApi.md#resendstaffinvite) | **POST** /admin/staff/{id}/invite | Send or resend the invite email
[**revokeStaffSessions**](AdminStaffApi.md#revokestaffsessions) | **DELETE** /admin/staff/{id}/sessions | Sign a staff member out everywhere
[**updateStaff**](AdminStaffApi.md#updatestaff) | **PATCH** /admin/staff/{id} | Change role or deactivate


# **createStaff**
> StaffUser createStaff(staffCreate)

Invite a staff user

**Access:** admin:super_admin.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminStaffApi();
final StaffCreate staffCreate = ; // StaffCreate | 

try {
    final response = api.createStaff(staffCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminStaffApi->createStaff: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **staffCreate** | [**StaffCreate**](StaffCreate.md)|  | 

### Return type

[**StaffUser**](StaffUser.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAuditLog**
> AuditEntryList listAuditLog(actorStaffId, entityType, entityId, cursor, limit)

Who did what, when

**Access:** admin:super_admin.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminStaffApi();
final String actorStaffId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String entityType = entityType_example; // String | 
final String entityId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String cursor = cursor_example; // String | Opaque cursor from `page.nextCursor`.
final int limit = 56; // int | 

try {
    final response = api.listAuditLog(actorStaffId, entityType, entityId, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminStaffApi->listAuditLog: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **actorStaffId** | **String**|  | [optional] 
 **entityType** | **String**|  | [optional] 
 **entityId** | **String**|  | [optional] 
 **cursor** | **String**| Opaque cursor from `page.nextCursor`. | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**AuditEntryList**](AuditEntryList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listStaff**
> StaffUserList listStaff(cursor, limit)

Staff users

**Access:** admin:super_admin.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminStaffApi();
final String cursor = cursor_example; // String | Opaque cursor from `page.nextCursor`.
final int limit = 56; // int | 

try {
    final response = api.listStaff(cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminStaffApi->listStaff: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque cursor from `page.nextCursor`. | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**StaffUserList**](StaffUserList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resendStaffInvite**
> resendStaffInvite(id)

Send or resend the invite email

**Access:** admin:super_admin.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminStaffApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.resendStaffInvite(id);
} on DioException catch (e) {
    print('Exception when calling AdminStaffApi->resendStaffInvite: $e\n');
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

# **revokeStaffSessions**
> revokeStaffSessions(id)

Sign a staff member out everywhere

**Access:** admin:super_admin.  Revokes refresh tokens and access-token jtis for that user. Audit-logged.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminStaffApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.revokeStaffSessions(id);
} on DioException catch (e) {
    print('Exception when calling AdminStaffApi->revokeStaffSessions: $e\n');
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

# **updateStaff**
> StaffUser updateStaff(id, staffUpdate)

Change role or deactivate

**Access:** admin:super_admin.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminStaffApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final StaffUpdate staffUpdate = ; // StaffUpdate | 

try {
    final response = api.updateStaff(id, staffUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminStaffApi->updateStaff: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **staffUpdate** | [**StaffUpdate**](StaffUpdate.md)|  | 

### Return type

[**StaffUser**](StaffUser.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

