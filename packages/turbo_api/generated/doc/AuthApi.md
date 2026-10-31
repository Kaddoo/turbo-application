# turbo_api_generated.api.AuthApi

## Load the API package
```dart
import 'package:turbo_api_generated/api.dart';
```

All URIs are relative to *http://localhost:4010*

Method | HTTP request | Description
------------- | ------------- | -------------
[**acceptStaffInvite**](AuthApi.md#acceptstaffinvite) | **POST** /auth/admin/invite/accept | Set a password from an invite link
[**adminLogin**](AuthApi.md#adminlogin) | **POST** /auth/admin/login | Staff login with email and password
[**confirmStaffMfa**](AuthApi.md#confirmstaffmfa) | **POST** /auth/admin/mfa/confirm | Confirm MFA enrolment and sign in
[**forgotStaffPassword**](AuthApi.md#forgotstaffpassword) | **POST** /auth/admin/password/forgot | Request a password reset email
[**logout**](AuthApi.md#logout) | **POST** /auth/logout | Revoke the current session
[**refreshTokens**](AuthApi.md#refreshtokens) | **POST** /auth/refresh | Rotate the refresh token and get a new access token
[**registerDevice**](AuthApi.md#registerdevice) | **POST** /devices | Register or update a push token
[**requestOtp**](AuthApi.md#requestotp) | **POST** /auth/otp/request | Send a one-time code by SMS
[**resetStaffPassword**](AuthApi.md#resetstaffpassword) | **POST** /auth/admin/password/reset | Set a new password from a reset link
[**unregisterDevice**](AuthApi.md#unregisterdevice) | **DELETE** /devices/{deviceId} | Remove a push token (call on logout)
[**verifyOtp**](AuthApi.md#verifyotp) | **POST** /auth/otp/verify | Exchange a code for tokens


# **acceptStaffInvite**
> MfaEnrollment acceptStaffInvite(inviteAccept)

Set a password from an invite link

**Access:** Public.  The invite email carries a single-use token valid for 72 hours. Returns the MFA enrolment to scan. Login stays closed until MFA is confirmed.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAuthApi();
final InviteAccept inviteAccept = ; // InviteAccept | 

try {
    final response = api.acceptStaffInvite(inviteAccept);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->acceptStaffInvite: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inviteAccept** | [**InviteAccept**](InviteAccept.md)|  | 

### Return type

[**MfaEnrollment**](MfaEnrollment.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminLogin**
> AuthTokens adminLogin(adminLogin)

Staff login with email and password

**Access:** Public.  All staff must have MFA. Returns 401 `mfa_required` when `totpCode` is missing or wrong. Five failed attempts lock the account for 15 minutes (429 `account_locked`). An account that has not finished its invite cannot log in.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAuthApi();
final AdminLogin adminLogin = ; // AdminLogin | 

try {
    final response = api.adminLogin(adminLogin);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->adminLogin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adminLogin** | [**AdminLogin**](AdminLogin.md)|  | 

### Return type

[**AuthTokens**](AuthTokens.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **confirmStaffMfa**
> AuthTokens confirmStaffMfa(mfaConfirm)

Confirm MFA enrolment and sign in

**Access:** Public (enrolment token).  First valid TOTP code finishes enrolment and returns tokens.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAuthApi();
final MfaConfirm mfaConfirm = ; // MfaConfirm | 

try {
    final response = api.confirmStaffMfa(mfaConfirm);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->confirmStaffMfa: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **mfaConfirm** | [**MfaConfirm**](MfaConfirm.md)|  | 

### Return type

[**AuthTokens**](AuthTokens.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **forgotStaffPassword**
> forgotStaffPassword(passwordForgot)

Request a password reset email

**Access:** Public.  Always 202, whether or not the email exists (no enumeration).

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAuthApi();
final PasswordForgot passwordForgot = ; // PasswordForgot | 

try {
    api.forgotStaffPassword(passwordForgot);
} on DioException catch (e) {
    print('Exception when calling AuthApi->forgotStaffPassword: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **passwordForgot** | [**PasswordForgot**](PasswordForgot.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **logout**
> logout()

Revoke the current session

**Access:** any.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAuthApi();

try {
    api.logout();
} on DioException catch (e) {
    print('Exception when calling AuthApi->logout: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **refreshTokens**
> AuthTokens refreshTokens(refreshRequest)

Rotate the refresh token and get a new access token

**Access:** Public.  Mobile clients send `refreshToken` in the body. Web clients send the httpOnly cookie and an empty body. Refresh tokens rotate on every call; reuse of an old one revokes the whole session.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAuthApi();
final RefreshRequest refreshRequest = ; // RefreshRequest | 

try {
    final response = api.refreshTokens(refreshRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->refreshTokens: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refreshRequest** | [**RefreshRequest**](RefreshRequest.md)|  | [optional] 

### Return type

[**AuthTokens**](AuthTokens.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **registerDevice**
> registerDevice(deviceRegistration)

Register or update a push token

**Access:** any.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAuthApi();
final DeviceRegistration deviceRegistration = ; // DeviceRegistration | 

try {
    api.registerDevice(deviceRegistration);
} on DioException catch (e) {
    print('Exception when calling AuthApi->registerDevice: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deviceRegistration** | [**DeviceRegistration**](DeviceRegistration.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestOtp**
> OtpChallenge requestOtp(otpRequest)

Send a one-time code by SMS

**Access:** Public.  Only +233 numbers are accepted. Limits apply per phone number, per IP and per device. When the daily SMS ceiling (`smsDailyLimit`) is hit, returns 503 `sms_budget_exceeded` and staff are alerted.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAuthApi();
final OtpRequest otpRequest = ; // OtpRequest | 

try {
    final response = api.requestOtp(otpRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->requestOtp: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **otpRequest** | [**OtpRequest**](OtpRequest.md)|  | 

### Return type

[**OtpChallenge**](OtpChallenge.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resetStaffPassword**
> resetStaffPassword(passwordReset)

Set a new password from a reset link

**Access:** Public.  Single-use token valid for 1 hour. Revokes every session of that staff user. MFA is still required at next login.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAuthApi();
final PasswordReset passwordReset = ; // PasswordReset | 

try {
    api.resetStaffPassword(passwordReset);
} on DioException catch (e) {
    print('Exception when calling AuthApi->resetStaffPassword: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **passwordReset** | [**PasswordReset**](PasswordReset.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **unregisterDevice**
> unregisterDevice(deviceId)

Remove a push token (call on logout)

**Access:** any.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAuthApi();
final String deviceId = deviceId_example; // String | 

try {
    api.unregisterDevice(deviceId);
} on DioException catch (e) {
    print('Exception when calling AuthApi->unregisterDevice: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deviceId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **verifyOtp**
> AuthTokens verifyOtp(otpVerify)

Exchange a code for tokens

**Access:** Public.  Creates the student or driver account on first successful verification. Drivers must already exist (created by an admin); an unknown driver number returns 403.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAuthApi();
final OtpVerify otpVerify = ; // OtpVerify | 

try {
    final response = api.verifyOtp(otpVerify);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->verifyOtp: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **otpVerify** | [**OtpVerify**](OtpVerify.md)|  | 

### Return type

[**AuthTokens**](AuthTokens.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

