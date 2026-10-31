# turbo_api_generated.model.AttendanceRecord

## Load the model package
```dart
import 'package:turbo_api_generated/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | UUID (v7 recommended so ids sort by creation time). | 
**driverId** | **String** | UUID (v7 recommended so ids sort by creation time). | 
**shiftId** | **String** | UUID (v7 recommended so ids sort by creation time). | [optional] 
**date** | [**DateTime**](DateTime.md) |  | 
**clockInAt** | [**DateTime**](DateTime.md) |  | [optional] 
**clockOutAt** | [**DateTime**](DateTime.md) |  | [optional] 
**minutesWorked** | **int** |  | 
**status** | **String** |  | 
**correctionNote** | **String** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


