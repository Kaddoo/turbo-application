# turbo_api_generated.model.Quote

## Load the model package
```dart
import 'package:turbo_api_generated/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**eligible** | **bool** |  | 
**quoteId** | **String** | Null when eligible is false. | [optional] 
**reasons** | [**List&lt;IneligibilityReason&gt;**](IneligibilityReason.md) |  | 
**routeDistanceMeters** | **int** |  | [optional] 
**routeDurationSeconds** | **int** |  | [optional] 
**routePolyline** | **String** | The road from pickup to drop-off as a Google encoded polyline (precision 5), computed by the server from the same Routes call that gives the distance. Null when no road route is known (the apps then draw the two points only). Never needs a Maps key in the app. | [optional] 
**farePesewas** | **int** | Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500. | [optional] 
**pickupEtaSeconds** | **int** |  | [optional] 
**expiresAt** | [**DateTime**](DateTime.md) |  | [optional] 
**wallet** | [**QuoteWallet**](QuoteWallet.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


