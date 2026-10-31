# turbo_api_generated.model.SalaryPayment

## Load the model package
```dart
import 'package:turbo_api_generated/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | UUID (v7 recommended so ids sort by creation time). | 
**driverId** | **String** | UUID (v7 recommended so ids sort by creation time). | 
**periodStart** | [**DateTime**](DateTime.md) |  | 
**periodEnd** | [**DateTime**](DateTime.md) |  | 
**amountPesewas** | **int** | Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500. | 
**method** | **String** |  | 
**reference** | **String** |  | [optional] 
**paidAt** | [**DateTime**](DateTime.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


