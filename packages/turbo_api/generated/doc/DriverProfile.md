# turbo_api_generated.model.DriverProfile

## Load the model package
```dart
import 'package:turbo_api_generated/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | UUID (v7 recommended so ids sort by creation time). | 
**fullName** | **String** |  | 
**phone** | **String** |  | 
**photoUrl** | **String** |  | [optional] 
**status** | [**AccountStatus**](AccountStatus.md) |  | 
**dutyStatus** | **String** |  | 
**vehicle** | [**Vehicle**](Vehicle.md) |  | [optional] 
**currentRideId** | **String** | UUID (v7 recommended so ids sort by creation time). | [optional] 
**documents** | [**List&lt;DriverDocumentStatus&gt;**](DriverDocumentStatus.md) | The documents that decide whether the driver may go on duty, one per type (the one that expires last). A type with no document uploaded is left out. The driver never needs the file, so no upload id or URL is sent. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


