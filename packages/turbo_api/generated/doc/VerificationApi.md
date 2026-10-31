# turbo_api_generated.api.VerificationApi

## Load the API package
```dart
import 'package:turbo_api_generated/api.dart';
```

All URIs are relative to *http://localhost:4010*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getMyVerification**](VerificationApi.md#getmyverification) | **GET** /me/verification | My verification status
[**submitVerification**](VerificationApi.md#submitverification) | **POST** /me/verification | Submit or resubmit Ghana Card and student ID


# **getMyVerification**
> VerificationState getMyVerification()

My verification status

**Access:** student.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getVerificationApi();

try {
    final response = api.getMyVerification();
    print(response);
} on DioException catch (e) {
    print('Exception when calling VerificationApi->getMyVerification: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**VerificationState**](VerificationState.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **submitVerification**
> VerificationState submitVerification(verificationSubmission)

Submit or resubmit Ghana Card and student ID

**Access:** student.  409 `verification_not_resubmittable` when status is pending, approved or rejected.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getVerificationApi();
final VerificationSubmission verificationSubmission = ; // VerificationSubmission | 

try {
    final response = api.submitVerification(verificationSubmission);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VerificationApi->submitVerification: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **verificationSubmission** | [**VerificationSubmission**](VerificationSubmission.md)|  | 

### Return type

[**VerificationState**](VerificationState.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

