# turbo_api_generated.model.DriverRide

## Load the model package
```dart
import 'package:turbo_api_generated/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | UUID (v7 recommended so ids sort by creation time). | 
**status** | [**RideStatus**](RideStatus.md) |  | 
**pickup** | [**Location**](Location.md) |  | 
**dropoff** | [**Location**](Location.md) |  | 
**routeDistanceMeters** | **int** |  | 
**farePesewas** | **int** | What the student pays for this trip. Shown so the driver can see the price before acknowledging. | [optional] 
**pickupDistanceMeters** | **int** | Estimated road distance from the driver's last known position to the pickup. Null once the trip has started or if the driver has no recent position. | [optional] 
**pickupEtaSeconds** | **int** | Estimated time to reach the pickup. 0 once arrived, null once the trip has started. | [optional] 
**routeDurationSeconds** | **int** | Estimated duration of the trip itself. | [optional] 
**student** | [**DriverRideStudent**](DriverRideStudent.md) |  | 
**assignedAt** | [**DateTime**](DateTime.md) |  | 
**acknowledgedAt** | [**DateTime**](DateTime.md) |  | [optional] 
**noShowAvailableAt** | [**DateTime**](DateTime.md) | Time after which \"student not here\" can be used. Null until the driver has arrived. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


