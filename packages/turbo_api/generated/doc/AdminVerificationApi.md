# turbo_api_generated.api.AdminVerificationApi

## Load the API package
```dart
import 'package:turbo_api_generated/api.dart';
```

All URIs are relative to *http://localhost:4010*

Method | HTTP request | Description
------------- | ------------- | -------------
[**claimVerification**](AdminVerificationApi.md#claimverification) | **POST** /admin/verifications/{id}/claim | Claim a submission for review
[**decideVerification**](AdminVerificationApi.md#decideverification) | **POST** /admin/verifications/{id}/decision | Approve, reject or request resubmission
[**getVerification**](AdminVerificationApi.md#getverification) | **GET** /admin/verifications/{id} | Submission with signed document URLs
[**listVerifications**](AdminVerificationApi.md#listverifications) | **GET** /admin/verifications | Verification queue


# **claimVerification**
> VerificationSummary claimVerification(id)

Claim a submission for review

**Access:** admin:verifier.  15-minute lock so two reviewers do not decide the same submission. 409 `verification_claimed` if someone else holds it. Deciding releases it.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminVerificationApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.claimVerification(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminVerificationApi->claimVerification: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**VerificationSummary**](VerificationSummary.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **decideVerification**
> VerificationDetail decideVerification(id, verificationDecision)

Approve, reject or request resubmission

**Access:** admin:verifier.  Notifies the student by push and SMS. Immutable decision record.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminVerificationApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final VerificationDecision verificationDecision = ; // VerificationDecision | 

try {
    final response = api.decideVerification(id, verificationDecision);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminVerificationApi->decideVerification: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **verificationDecision** | [**VerificationDecision**](VerificationDecision.md)|  | 

### Return type

[**VerificationDetail**](VerificationDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVerification**
> VerificationDetail getVerification(id)

Submission with signed document URLs

**Access:** admin:verifier.  Document URLs are short-lived and every call is written to the audit log.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminVerificationApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getVerification(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminVerificationApi->getVerification: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**VerificationDetail**](VerificationDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listVerifications**
> VerificationSummaryList listVerifications(status, cursor, limit)

Verification queue

**Access:** admin:verifier.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminVerificationApi();
final VerificationStatus status = ; // VerificationStatus | 
final String cursor = cursor_example; // String | Opaque cursor from `page.nextCursor`.
final int limit = 56; // int | 

try {
    final response = api.listVerifications(status, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminVerificationApi->listVerifications: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | [**VerificationStatus**](.md)|  | [optional] 
 **cursor** | **String**| Opaque cursor from `page.nextCursor`. | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**VerificationSummaryList**](VerificationSummaryList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

