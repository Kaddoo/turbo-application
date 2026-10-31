# turbo_api_generated.api.SupportApi

## Load the API package
```dart
import 'package:turbo_api_generated/api.dart';
```

All URIs are relative to *http://localhost:4010*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createSupportTicket**](SupportApi.md#createsupportticket) | **POST** /support/tickets | Report an issue or ask for help
[**getMySupportTicket**](SupportApi.md#getmysupportticket) | **GET** /support/tickets/{id} | One ticket with its messages
[**listMySupportTickets**](SupportApi.md#listmysupporttickets) | **GET** /support/tickets | My tickets
[**replyToSupportTicket**](SupportApi.md#replytosupportticket) | **POST** /support/tickets/{id}/messages | Reply on a ticket


# **createSupportTicket**
> SupportTicket createSupportTicket(supportTicketCreate)

Report an issue or ask for help

**Access:** student, driver.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getSupportApi();
final SupportTicketCreate supportTicketCreate = ; // SupportTicketCreate | 

try {
    final response = api.createSupportTicket(supportTicketCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SupportApi->createSupportTicket: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **supportTicketCreate** | [**SupportTicketCreate**](SupportTicketCreate.md)|  | 

### Return type

[**SupportTicket**](SupportTicket.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMySupportTicket**
> SupportTicket getMySupportTicket(id)

One ticket with its messages

**Access:** student, driver.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getSupportApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getMySupportTicket(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SupportApi->getMySupportTicket: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**SupportTicket**](SupportTicket.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listMySupportTickets**
> SupportTicketList listMySupportTickets(cursor, limit)

My tickets

**Access:** student, driver.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getSupportApi();
final String cursor = cursor_example; // String | Opaque cursor from `page.nextCursor`.
final int limit = 56; // int | 

try {
    final response = api.listMySupportTickets(cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SupportApi->listMySupportTickets: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque cursor from `page.nextCursor`. | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**SupportTicketList**](SupportTicketList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **replyToSupportTicket**
> SupportMessage replyToSupportTicket(id, supportMessageCreate)

Reply on a ticket

**Access:** student, driver.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getSupportApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final SupportMessageCreate supportMessageCreate = ; // SupportMessageCreate | 

try {
    final response = api.replyToSupportTicket(id, supportMessageCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SupportApi->replyToSupportTicket: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **supportMessageCreate** | [**SupportMessageCreate**](SupportMessageCreate.md)|  | 

### Return type

[**SupportMessage**](SupportMessage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

