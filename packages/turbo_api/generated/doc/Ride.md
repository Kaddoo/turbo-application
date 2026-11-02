# turbo_api_generated.model.Ride

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
**routePolyline** | **String** | The road from pickup to drop-off as a Google encoded polyline (precision 5), computed by the server from the same Routes call that gives the distance. Null when no road route is known (the apps then draw the two points only). Never needs a Maps key in the app. | [optional] 
**farePesewas** | **int** | Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500. | 
**pin** | **String** | 4-digit start PIN. Returned only to the student who owns the ride, while status is assigned or driver_arrived. | [optional] 
**pickupEtaSeconds** | **int** |  | [optional] 
**driver** | [**DriverPublic**](DriverPublic.md) |  | [optional] 
**vehicle** | [**VehiclePublic**](VehiclePublic.md) |  | [optional] 
**payment** | [**RidePayment**](RidePayment.md) |  | 
**cancellation** | [**Cancellation**](Cancellation.md) |  | [optional] 
**requestedAt** | [**DateTime**](DateTime.md) |  | 
**assignedAt** | [**DateTime**](DateTime.md) |  | [optional] 
**driverArrivedAt** | [**DateTime**](DateTime.md) |  | [optional] 
**startedAt** | [**DateTime**](DateTime.md) |  | [optional] 
**completedAt** | [**DateTime**](DateTime.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


