# turbo_api_generated.api.AdminSupportApi

## Load the API package
```dart
import 'package:turbo_api_generated/api.dart';
```

All URIs are relative to *http://localhost:4010*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getAdminSupportTicket**](AdminSupportApi.md#getadminsupportticket) | **GET** /admin/support/tickets/{id} | Ticket with messages and internal notes
[**listAllSupportTickets**](AdminSupportApi.md#listallsupporttickets) | **GET** /admin/support/tickets | All tickets
[**listIncidents**](AdminSupportApi.md#listincidents) | **GET** /admin/incidents | SOS and safety incidents
[**replyAsStaff**](AdminSupportApi.md#replyasstaff) | **POST** /admin/support/tickets/{id}/messages | Reply or add an internal note
[**updateIncident**](AdminSupportApi.md#updateincident) | **PATCH** /admin/incidents/{id} | Acknowledge or resolve an incident
[**updateSupportTicket**](AdminSupportApi.md#updatesupportticket) | **PATCH** /admin/support/tickets/{id} | Change status or assignee


# **getAdminSupportTicket**
> SupportTicket getAdminSupportTicket(id)

Ticket with messages and internal notes

**Access:** admin:support.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminSupportApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getAdminSupportTicket(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminSupportApi->getAdminSupportTicket: $e\n');
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

# **listAllSupportTickets**
> SupportTicketList listAllSupportTickets(status, category, cursor, limit)

All tickets

**Access:** admin:support.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminSupportApi();
final String status = status_example; // String | 
final String category = category_example; // String | 
final String cursor = cursor_example; // String | Opaque cursor from `page.nextCursor`.
final int limit = 56; // int | 

try {
    final response = api.listAllSupportTickets(status, category, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminSupportApi->listAllSupportTickets: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] 
 **category** | **String**|  | [optional] 
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

# **listIncidents**
> IncidentList listIncidents(status, cursor, limit)

SOS and safety incidents

**Access:** admin:support.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminSupportApi();
final String status = status_example; // String | 
final String cursor = cursor_example; // String | Opaque cursor from `page.nextCursor`.
final int limit = 56; // int | 

try {
    final response = api.listIncidents(status, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminSupportApi->listIncidents: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] 
 **cursor** | **String**| Opaque cursor from `page.nextCursor`. | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**IncidentList**](IncidentList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **replyAsStaff**
> SupportMessage replyAsStaff(id, supportMessageCreate)

Reply or add an internal note

**Access:** admin:support.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminSupportApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final SupportMessageCreate supportMessageCreate = ; // SupportMessageCreate | 

try {
    final response = api.replyAsStaff(id, supportMessageCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminSupportApi->replyAsStaff: $e\n');
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

# **updateIncident**
> Incident updateIncident(id, incidentUpdate)

Acknowledge or resolve an incident

**Access:** admin:support. 409 `incident_state_invalid`: the incident is already resolved, or is not open when acknowledging.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminSupportApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final IncidentUpdate incidentUpdate = ; // IncidentUpdate | 

try {
    final response = api.updateIncident(id, incidentUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminSupportApi->updateIncident: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **incidentUpdate** | [**IncidentUpdate**](IncidentUpdate.md)|  | 

### Return type

[**Incident**](Incident.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateSupportTicket**
> SupportTicket updateSupportTicket(id, ticketUpdate)

Change status or assignee

**Access:** admin:support.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminSupportApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final TicketUpdate ticketUpdate = ; // TicketUpdate | 

try {
    final response = api.updateSupportTicket(id, ticketUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminSupportApi->updateSupportTicket: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **ticketUpdate** | [**TicketUpdate**](TicketUpdate.md)|  | 

### Return type

[**SupportTicket**](SupportTicket.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

