# turbo_api_generated.model.AdminRideSummary

## Load the model package
```dart
import 'package:turbo_api_generated/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | UUID (v7 recommended so ids sort by creation time). | 
**status** | [**RideStatus**](RideStatus.md) |  | 
**studentId** | **String** | UUID (v7 recommended so ids sort by creation time). | 
**studentName** | **String** |  | [optional] 
**driverId** | **String** | UUID (v7 recommended so ids sort by creation time). | [optional] 
**driverName** | **String** |  | [optional] 
**routeDistanceMeters** | **int** |  | 
**farePesewas** | **int** | Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500. | 
**requestedAt** | [**DateTime**](DateTime.md) |  | 
**flags** | [**List&lt;RideFlag&gt;**](RideFlag.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


