# turbo_api_generated.api.StudentApi

## Load the API package
```dart
import 'package:turbo_api_generated/api.dart';
```

All URIs are relative to *http://localhost:4010*

Method | HTTP request | Description
------------- | ------------- | -------------
[**acceptTerms**](StudentApi.md#acceptterms) | **POST** /me/terms-acceptance | Accept a newer terms or privacy version
[**autocompletePlaces**](StudentApi.md#autocompleteplaces) | **GET** /places/autocomplete | Search for a place inside the service area
[**createSavedPlace**](StudentApi.md#createsavedplace) | **POST** /me/saved-places | Save a destination
[**createTrustedContact**](StudentApi.md#createtrustedcontact) | **POST** /me/trusted-contacts | Add a trusted contact
[**deleteSavedPlace**](StudentApi.md#deletesavedplace) | **DELETE** /me/saved-places/{id} | Remove a saved destination
[**deleteTrustedContact**](StudentApi.md#deletetrustedcontact) | **DELETE** /me/trusted-contacts/{id} | Remove a trusted contact
[**getMe**](StudentApi.md#getme) | **GET** /me | My profile
[**getNotificationSettings**](StudentApi.md#getnotificationsettings) | **GET** /me/notification-settings | My notification choices
[**getPlace**](StudentApi.md#getplace) | **GET** /places/{placeId} | The point and label for a chosen suggestion
[**listSavedPlaces**](StudentApi.md#listsavedplaces) | **GET** /me/saved-places | My saved destinations
[**listSessions**](StudentApi.md#listsessions) | **GET** /me/sessions | My signed-in devices
[**listTrustedContacts**](StudentApi.md#listtrustedcontacts) | **GET** /me/trusted-contacts | My trusted contacts
[**requestDeletion**](StudentApi.md#requestdeletion) | **POST** /me/deletion-request | Start account and data deletion
[**revokeOtherSessions**](StudentApi.md#revokeothersessions) | **DELETE** /me/sessions | Sign out everywhere else
[**revokeSession**](StudentApi.md#revokesession) | **DELETE** /me/sessions/{id} | Sign out one device
[**updateMe**](StudentApi.md#updateme) | **PATCH** /me | Update my profile
[**updateNotificationSettings**](StudentApi.md#updatenotificationsettings) | **PUT** /me/notification-settings | Change my notification choices


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

# **autocompletePlaces**
> PlaceMatchList autocompletePlaces(q, sessionToken)

Search for a place inside the service area

**Access:** student.  Official pickup points that match come first, then places from the map provider, all limited to the service area. The map provider key stays on the server. Pass the same `sessionToken` for one search (typing) and the `GET /places/{placeId}` that follows it, and a new one for the next search. An empty or one-letter `q` returns an empty list.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getStudentApi();
final String q = q_example; // String | 
final String sessionToken = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.autocompletePlaces(q, sessionToken);
    print(response);
} on DioException catch (e) {
    print('Exception when calling StudentApi->autocompletePlaces: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**|  | 
 **sessionToken** | **String**|  | [optional] 

### Return type

[**PlaceMatchList**](PlaceMatchList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

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

# **getNotificationSettings**
> NotificationSettings getNotificationSettings()

My notification choices

**Access:** student.  Ride and wallet messages are always sent; these are the optional ones. Until the student has chosen, `newsAndOffers` is false and `tips` is true.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getStudentApi();

try {
    final response = api.getNotificationSettings();
    print(response);
} on DioException catch (e) {
    print('Exception when calling StudentApi->getNotificationSettings: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**NotificationSettings**](NotificationSettings.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPlace**
> Location getPlace(placeId, sessionToken)

The point and label for a chosen suggestion

**Access:** student.  404 when the id is unknown or the place is outside the service area.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getStudentApi();
final String placeId = placeId_example; // String | 
final String sessionToken = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getPlace(placeId, sessionToken);
    print(response);
} on DioException catch (e) {
    print('Exception when calling StudentApi->getPlace: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **placeId** | **String**|  | 
 **sessionToken** | **String**|  | [optional] 

### Return type

[**Location**](Location.md)

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

# **updateNotificationSettings**
> NotificationSettings updateNotificationSettings(notificationSettings)

Change my notification choices

**Access:** student. Replaces both choices.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getStudentApi();
final NotificationSettings notificationSettings = ; // NotificationSettings | 

try {
    final response = api.updateNotificationSettings(notificationSettings);
    print(response);
} on DioException catch (e) {
    print('Exception when calling StudentApi->updateNotificationSettings: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **notificationSettings** | [**NotificationSettings**](NotificationSettings.md)|  | 

### Return type

[**NotificationSettings**](NotificationSettings.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

