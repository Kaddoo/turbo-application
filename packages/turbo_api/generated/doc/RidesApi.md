# turbo_api_generated.api.RidesApi

## Load the API package
```dart
import 'package:turbo_api_generated/api.dart';
```

All URIs are relative to *http://localhost:4010*

Method | HTTP request | Description
------------- | ------------- | -------------
[**cancelRide**](RidesApi.md#cancelride) | **POST** /rides/{id}/cancel | Cancel for free
[**confirmDestinationChange**](RidesApi.md#confirmdestinationchange) | **POST** /rides/{id}/destination-change/confirm | Accept the revised fare
[**createQuote**](RidesApi.md#createquote) | **POST** /rides/quote | Check eligibility, distance, fare and wallet
[**createRide**](RidesApi.md#createride) | **POST** /rides | Confirm a quote: hold funds and start finding a driver
[**getRide**](RidesApi.md#getride) | **GET** /rides/{id} | One of my rides
[**getRideReceipt**](RidesApi.md#getridereceipt) | **GET** /rides/{id}/receipt | Receipt for a completed or cancelled ride
[**getRideTracking**](RidesApi.md#getridetracking) | **GET** /rides/{id}/tracking | Driver location and ETA
[**listMyRides**](RidesApi.md#listmyrides) | **GET** /rides | My trip history
[**listRideMessages**](RidesApi.md#listridemessages) | **GET** /rides/{id}/messages | Quick messages on this ride
[**proposeDestinationChange**](RidesApi.md#proposedestinationchange) | **POST** /rides/{id}/destination-change | Get a revised fare for a new destination
[**rateRide**](RidesApi.md#rateride) | **POST** /rides/{id}/rating | Rate a completed ride
[**sendRideMessage**](RidesApi.md#sendridemessage) | **POST** /rides/{id}/messages | Send a quick message to the other party


# **cancelRide**
> Ride cancelRide(id, cancelRequest)

Cancel for free

**Access:** student.  Free at every stage until the trip starts, including after the driver arrives. Releases the hold, or refunds in full if already charged. 409 `ride_not_cancellable` once in_progress.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getRidesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final CancelRequest cancelRequest = ; // CancelRequest | 

try {
    final response = api.cancelRide(id, cancelRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RidesApi->cancelRide: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **cancelRequest** | [**CancelRequest**](CancelRequest.md)|  | 

### Return type

[**Ride**](Ride.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **confirmDestinationChange**
> Ride confirmDestinationChange(id, destinationChangeConfirm)

Accept the revised fare

**Access:** student. **Release:** v1.1 (do not build for v1).

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getRidesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final DestinationChangeConfirm destinationChangeConfirm = ; // DestinationChangeConfirm | 

try {
    final response = api.confirmDestinationChange(id, destinationChangeConfirm);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RidesApi->confirmDestinationChange: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **destinationChangeConfirm** | [**DestinationChangeConfirm**](DestinationChangeConfirm.md)|  | 

### Return type

[**Ride**](Ride.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createQuote**
> Quote createQuote(quoteRequest)

Check eligibility, distance, fare and wallet

**Access:** student.  Server is the only authority on eligibility and fare. Checks: verified student, no active ride, both points inside the boundary, road distance within the limit, drivers on duty. Ineligible answers are 200 with `eligible:false`.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getRidesApi();
final QuoteRequest quoteRequest = ; // QuoteRequest | 

try {
    final response = api.createQuote(quoteRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RidesApi->createQuote: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **quoteRequest** | [**QuoteRequest**](QuoteRequest.md)|  | 

### Return type

[**Quote**](Quote.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createRide**
> Ride createRide(idempotencyKey, rideCreate)

Confirm a quote: hold funds and start finding a driver

**Access:** student.  Errors: 409 `insufficient_balance`, `quote_expired`, `active_ride_exists`. Holds the fare in the wallet, then the assignment engine starts. Safe to retry with the same Idempotency-Key.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getRidesApi();
final String idempotencyKey = idempotencyKey_example; // String | Client generated UUID. Reuse it when retrying the same request.
final RideCreate rideCreate = ; // RideCreate | 

try {
    final response = api.createRide(idempotencyKey, rideCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RidesApi->createRide: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**| Client generated UUID. Reuse it when retrying the same request. | 
 **rideCreate** | [**RideCreate**](RideCreate.md)|  | 

### Return type

[**Ride**](Ride.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getRide**
> Ride getRide(id)

One of my rides

**Access:** student.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getRidesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getRide(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RidesApi->getRide: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**Ride**](Ride.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getRideReceipt**
> Receipt getRideReceipt(id)

Receipt for a completed or cancelled ride

**Access:** student.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getRidesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getRideReceipt(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RidesApi->getRideReceipt: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**Receipt**](Receipt.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getRideTracking**
> Tracking getRideTracking(id)

Driver location and ETA

**Access:** student.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getRidesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getRideTracking(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RidesApi->getRideTracking: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**Tracking**](Tracking.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listMyRides**
> RideList listMyRides(status, cursor, limit)

My trip history

**Access:** student.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getRidesApi();
final RideStatus status = ; // RideStatus | 
final String cursor = cursor_example; // String | Opaque cursor from `page.nextCursor`.
final int limit = 56; // int | 

try {
    final response = api.listMyRides(status, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RidesApi->listMyRides: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | [**RideStatus**](.md)|  | [optional] 
 **cursor** | **String**| Opaque cursor from `page.nextCursor`. | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**RideList**](RideList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listRideMessages**
> QuickMessageList listRideMessages(id)

Quick messages on this ride

**Access:** student or driver on this ride.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getRidesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.listRideMessages(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RidesApi->listRideMessages: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**QuickMessageList**](QuickMessageList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **proposeDestinationChange**
> Quote proposeDestinationChange(id, destinationChange)

Get a revised fare for a new destination

**Access:** student. **Release:** v1.1 (do not build for v1).  Proposed rule from the requirements, still to be confirmed by Turbo.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getRidesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final DestinationChange destinationChange = ; // DestinationChange | 

try {
    final response = api.proposeDestinationChange(id, destinationChange);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RidesApi->proposeDestinationChange: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **destinationChange** | [**DestinationChange**](DestinationChange.md)|  | 

### Return type

[**Quote**](Quote.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **rateRide**
> rateRide(id, ratingCreate)

Rate a completed ride

**Access:** student.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getRidesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final RatingCreate ratingCreate = ; // RatingCreate | 

try {
    api.rateRide(id, ratingCreate);
} on DioException catch (e) {
    print('Exception when calling RidesApi->rateRide: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **ratingCreate** | [**RatingCreate**](RatingCreate.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sendRideMessage**
> sendRideMessage(id, quickMessageSend)

Send a quick message to the other party

**Access:** student or driver on this ride.  Preset messages only. No phone numbers are shared (D17). Delivered by push.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getRidesApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final QuickMessageSend quickMessageSend = ; // QuickMessageSend | 

try {
    api.sendRideMessage(id, quickMessageSend);
} on DioException catch (e) {
    print('Exception when calling RidesApi->sendRideMessage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **quickMessageSend** | [**QuickMessageSend**](QuickMessageSend.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

