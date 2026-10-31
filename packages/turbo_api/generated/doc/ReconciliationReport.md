# turbo_api_generated.model.ReconciliationReport

## Load the model package
```dart
import 'package:turbo_api_generated/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | UUID (v7 recommended so ids sort by creation time). | 
**periodFrom** | [**DateTime**](DateTime.md) |  | 
**periodTo** | [**DateTime**](DateTime.md) |  | 
**matchedCount** | **int** |  | 
**providerTotalPesewas** | **int** | Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500. | 
**ourTotalPesewas** | **int** | Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500. | 
**exceptions** | [**List&lt;ReconciliationItem&gt;**](ReconciliationItem.md) |  | 
**createdAt** | [**DateTime**](DateTime.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


