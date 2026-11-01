# turbo_api_generated.api.AdminStudentsApi

## Load the API package
```dart
import 'package:turbo_api_generated/api.dart';
```

All URIs are relative to *http://localhost:4010*

Method | HTTP request | Description
------------- | ------------- | -------------
[**changeStudentPhone**](AdminStudentsApi.md#changestudentphone) | **PUT** /admin/students/{id}/phone | Change a student&#39;s phone number
[**getStudent**](AdminStudentsApi.md#getstudent) | **GET** /admin/students/{id} | Student detail
[**listStudents**](AdminStudentsApi.md#liststudents) | **GET** /admin/students | Search students
[**revokeStudentSessions**](AdminStudentsApi.md#revokestudentsessions) | **DELETE** /admin/students/{id}/sessions | Sign a student out everywhere
[**updateStudentStatus**](AdminStudentsApi.md#updatestudentstatus) | **PATCH** /admin/students/{id} | Suspend or reactivate


# **changeStudentPhone**
> Student changeStudentPhone(id, phoneChange)

Change a student's phone number

**Access:** admin:verifier.  Only after re-checking the Ghana Card against the account, with a support ticket as evidence. Revokes all sessions, sends an SMS to the old number, audit-logged. The wallet is unaffected. 409 `duplicate_phone`: that number belongs to another account.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminStudentsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final PhoneChange phoneChange = ; // PhoneChange | 

try {
    final response = api.changeStudentPhone(id, phoneChange);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminStudentsApi->changeStudentPhone: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **phoneChange** | [**PhoneChange**](PhoneChange.md)|  | 

### Return type

[**Student**](Student.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getStudent**
> StudentDetail getStudent(id)

Student detail

**Access:** admin:verifier.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminStudentsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getStudent(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminStudentsApi->getStudent: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**StudentDetail**](StudentDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listStudents**
> StudentSummaryList listStudents(q, verificationStatus, accountStatus, cursor, limit)

Search students

**Access:** admin:verifier.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminStudentsApi();
final String q = q_example; // String | Name or phone
final VerificationStatus verificationStatus = ; // VerificationStatus | 
final AccountStatus accountStatus = ; // AccountStatus | 
final String cursor = cursor_example; // String | Opaque cursor from `page.nextCursor`.
final int limit = 56; // int | 

try {
    final response = api.listStudents(q, verificationStatus, accountStatus, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminStudentsApi->listStudents: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**| Name or phone | [optional] 
 **verificationStatus** | [**VerificationStatus**](.md)|  | [optional] 
 **accountStatus** | [**AccountStatus**](.md)|  | [optional] 
 **cursor** | **String**| Opaque cursor from `page.nextCursor`. | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**StudentSummaryList**](StudentSummaryList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **revokeStudentSessions**
> revokeStudentSessions(id)

Sign a student out everywhere

**Access:** admin:support. For a lost phone. Audit-logged.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminStudentsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.revokeStudentSessions(id);
} on DioException catch (e) {
    print('Exception when calling AdminStudentsApi->revokeStudentSessions: $e\n');
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

# **updateStudentStatus**
> StudentDetail updateStudentStatus(id, accountStatusUpdate)

Suspend or reactivate

**Access:** admin:verifier.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminStudentsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AccountStatusUpdate accountStatusUpdate = ; // AccountStatusUpdate | 

try {
    final response = api.updateStudentStatus(id, accountStatusUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminStudentsApi->updateStudentStatus: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **accountStatusUpdate** | [**AccountStatusUpdate**](AccountStatusUpdate.md)|  | 

### Return type

[**StudentDetail**](StudentDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

