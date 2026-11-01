# turbo_api_generated.api.AdminApi

## Load the API package
```dart
import 'package:turbo_api_generated/api.dart';
```

All URIs are relative to *http://localhost:4010*

Method | HTTP request | Description
------------- | ------------- | -------------
[**changeStaffPassword**](AdminApi.md#changestaffpassword) | **POST** /admin/me/password | Change my password
[**getStaffMe**](AdminApi.md#getstaffme) | **GET** /admin/me | My staff profile


# **changeStaffPassword**
> changeStaffPassword(passwordChange)

Change my password

**Access:** Any staff user.  Needs the current password and a fresh TOTP code. Revokes other sessions.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminApi();
final PasswordChange passwordChange = ; // PasswordChange | 

try {
    api.changeStaffPassword(passwordChange);
} on DioException catch (e) {
    print('Exception when calling AdminApi->changeStaffPassword: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **passwordChange** | [**PasswordChange**](PasswordChange.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getStaffMe**
> StaffUser getStaffMe()

My staff profile

**Access:** admin:any. Finance and super admin also receive `adjustmentApprovalThresholdPesewas`: the amount above which a wallet adjustment needs a second approver. Other roles do not.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminApi();

try {
    final response = api.getStaffMe();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->getStaffMe: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**StaffUser**](StaffUser.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

