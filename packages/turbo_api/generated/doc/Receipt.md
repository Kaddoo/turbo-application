# turbo_api_generated.model.Receipt

## Load the model package
```dart
import 'package:turbo_api_generated/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**rideId** | **String** | UUID (v7 recommended so ids sort by creation time). | 
**receiptNumber** | **String** |  | 
**issuedAt** | [**DateTime**](DateTime.md) |  | 
**pickup** | [**Location**](Location.md) |  | [optional] 
**dropoff** | [**Location**](Location.md) |  | [optional] 
**routeDistanceMeters** | **int** |  | [optional] 
**driverFirstName** | **String** |  | [optional] 
**vehiclePlate** | **String** |  | [optional] 
**lines** | [**List&lt;ReceiptLine&gt;**](ReceiptLine.md) |  | 
**totalPesewas** | **int** | Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


