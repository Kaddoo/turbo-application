# turbo_api_generated.model.SupportTicket

## Load the model package
```dart
import 'package:turbo_api_generated/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | UUID (v7 recommended so ids sort by creation time). | 
**category** | **String** |  | 
**status** | **String** |  | 
**subject** | **String** |  | 
**rideId** | **String** | UUID (v7 recommended so ids sort by creation time). | [optional] 
**assignedToStaffId** | **String** | UUID (v7 recommended so ids sort by creation time). | [optional] 
**createdAt** | [**DateTime**](DateTime.md) |  | 
**updatedAt** | [**DateTime**](DateTime.md) |  | 
**messages** | [**List&lt;SupportMessage&gt;**](SupportMessage.md) | Included on the detail endpoint only. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


