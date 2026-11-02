# turbo_api_generated.model.TopupCreate

## Load the model package
```dart
import 'package:turbo_api_generated/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**amountPesewas** | **int** | Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500. | 
**channel** | **String** |  | 
**network** | [**MomoNetwork**](MomoNetwork.md) | The mobile money network. Leave it out to let the server work it out from the number; if it cannot, 422 `network_unknown` and the app asks \"Pay with\" and sends the choice. | [optional] 
**msisdn** | **String** | The number that approves the payment, E.164. Defaults to the number the student signed in with. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


