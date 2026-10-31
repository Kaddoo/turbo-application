# turbo_api_generated.model.DriverDetail

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
**email** | **String** |  | [optional] 
**status** | [**AccountStatus**](AccountStatus.md) |  | 
**dutyStatus** | **String** |  | 
**vehicle** | [**Vehicle**](Vehicle.md) |  | [optional] 
**currentRideId** | **String** | UUID (v7 recommended so ids sort by creation time). | [optional] 
**lastLocation** | [**DriverLocation**](DriverLocation.md) |  | [optional] 
**documents** | [**List&lt;DriverDocument&gt;**](DriverDocument.md) |  | [optional] 
**createdAt** | [**DateTime**](DateTime.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


