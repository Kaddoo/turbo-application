# turbo_api_generated.api.StudentApi

## Load the API package
```dart
import 'package:turbo_api_generated/api.dart';
```

All URIs are relative to *http://localhost:4010*

Method | HTTP request | Description
------------- | ------------- | -------------
[**acceptTerms**](StudentApi.md#acceptterms) | **POST** /me/terms-acceptance | Accept a newer terms or privacy version
[**createSavedPlace**](StudentApi.md#createsavedplace) | **POST** /me/saved-places | Save a destination
[**createTrustedContact**](StudentApi.md#createtrustedcontact) | **POST** /me/trusted-contacts | Add a trusted contact
[**deleteSavedPlace**](StudentApi.md#deletesavedplace) | **DELETE** /me/saved-places/{id} | Remove a saved destination
[**deleteTrustedContact**](StudentApi.md#deletetrustedcontact) | **DELETE** /me/trusted-contacts/{id} | Remove a trusted contact
[**getMe**](StudentApi.md#getme) | **GET** /me | My profile
[**listSavedPlaces**](StudentApi.md#listsavedplaces) | **GET** /me/saved-places | My saved destinations
[**listSessions**](StudentApi.md#listsessions) | **GET** /me/sessions | My signed-in devices
[**listTrustedContacts**](StudentApi.md#listtrustedcontacts) | **GET** /me/trusted-contacts | My trusted contacts
[**requestDeletion**](StudentApi.md#requestdeletion) | **POST** /me/deletion-request | Start account and data deletion
[**revokeOtherSessions**](StudentApi.md#revokeothersessions) | **DELETE** /me/sessions | Sign out everywhere else
[**revokeSession**](StudentApi.md#revokesession) | **DELETE** /me/sessions/{id} | Sign out one device
[**updateMe**](StudentApi.md#updateme) | **PATCH** /me | Update my profile


# **acceptTerms**
> acceptTerms(termsAcceptance)

Accept a newer terms or privacy version

**Access:** student or driver. When versions change, protected endpoints return 403 `terms_not_accepted` until this is called. 403 `forbidden` for a token that is not a student. This call is exempt from the terms check, otherwise a user on old terms could never accept the new ones.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getStudentApi();
final TermsAcceptance termsAcceptance = ; // TermsAcceptance | 

try {
    api.acceptTerms(termsAcceptance);
} on DioException catch (e) {
    print('Exception when calling StudentApi->acceptTerms: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **termsAcceptance** | [**TermsAcceptance**](TermsAcceptance.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createSavedPlace**
> SavedPlace createSavedPlace(savedPlaceCreate)

Save a destination

**Access:** student.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getStudentApi();
final SavedPlaceCreate savedPlaceCreate = ; // SavedPlaceCreate | 

try {
    final response = api.createSavedPlace(savedPlaceCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling StudentApi->createSavedPlace: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **savedPlaceCreate** | [**SavedPlaceCreate**](SavedPlaceCreate.md)|  | 

### Return type

[**SavedPlace**](SavedPlace.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createTrustedContact**
> TrustedContact createTrustedContact(trustedContactCreate)

Add a trusted contact

**Access:** student.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getStudentApi();
final TrustedContactCreate trustedContactCreate = ; // TrustedContactCreate | 

try {
    final response = api.createTrustedContact(trustedContactCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling StudentApi->createTrustedContact: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **trustedContactCreate** | [**TrustedContactCreate**](TrustedContactCreate.md)|  | 

### Return type

[**TrustedContact**](TrustedContact.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteSavedPlace**
> deleteSavedPlace(id)

Remove a saved destination

**Access:** student.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getStudentApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.deleteSavedPlace(id);
} on DioException catch (e) {
    print('Exception when calling StudentApi->deleteSavedPlace: $e\n');
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

# **deleteTrustedContact**
> deleteTrustedContact(id)

Remove a trusted contact

**Access:** student.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getStudentApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.deleteTrustedContact(id);
} on DioException catch (e) {
    print('Exception when calling StudentApi->deleteTrustedContact: $e\n');
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

# **getMe**
> Student getMe()

My profile

**Access:** student.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getStudentApi();

try {
    final response = api.getMe();
    print(response);
} on DioException catch (e) {
    print('Exception when calling StudentApi->getMe: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**Student**](Student.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listSavedPlaces**
> SavedPlaceCollection listSavedPlaces()

My saved destinations

**Access:** student.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getStudentApi();

try {
    final response = api.listSavedPlaces();
    print(response);
} on DioException catch (e) {
    print('Exception when calling StudentApi->listSavedPlaces: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**SavedPlaceCollection**](SavedPlaceCollection.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listSessions**
> SessionList listSessions()

My signed-in devices

**Access:** student or driver. 403 `terms_not_accepted` until the current terms and privacy policy are accepted; 403 `forbidden` for a staff token.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getStudentApi();

try {
    final response = api.listSessions();
    print(response);
} on DioException catch (e) {
    print('Exception when calling StudentApi->listSessions: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**SessionList**](SessionList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listTrustedContacts**
> TrustedContactCollection listTrustedContacts()

My trusted contacts

**Access:** student.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getStudentApi();

try {
    final response = api.listTrustedContacts();
    print(response);
} on DioException catch (e) {
    print('Exception when calling StudentApi->listTrustedContacts: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**TrustedContactCollection**](TrustedContactCollection.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestDeletion**
> DeletionRequest requestDeletion()

Start account and data deletion

**Access:** student.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getStudentApi();

try {
    final response = api.requestDeletion();
    print(response);
} on DioException catch (e) {
    print('Exception when calling StudentApi->requestDeletion: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**DeletionRequest**](DeletionRequest.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **revokeOtherSessions**
> revokeOtherSessions()

Sign out everywhere else

**Access:** student or driver. Keeps the current session. 403 `terms_not_accepted` until the current terms and privacy policy are accepted; 403 `forbidden` for a staff token.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getStudentApi();

try {
    api.revokeOtherSessions();
} on DioException catch (e) {
    print('Exception when calling StudentApi->revokeOtherSessions: $e\n');
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

# **revokeSession**
> revokeSession(id)

Sign out one device

**Access:** student or driver. 403 `terms_not_accepted` until the current terms and privacy policy are accepted; 403 `forbidden` for a staff token.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getStudentApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.revokeSession(id);
} on DioException catch (e) {
    print('Exception when calling StudentApi->revokeSession: $e\n');
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

# **updateMe**
> Student updateMe(studentUpdate)

Update my profile

**Access:** student.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getStudentApi();
final StudentUpdate studentUpdate = ; // StudentUpdate | 

try {
    final response = api.updateMe(studentUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling StudentApi->updateMe: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **studentUpdate** | [**StudentUpdate**](StudentUpdate.md)|  | 

### Return type

[**Student**](Student.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

