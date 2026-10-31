# turbo_api_generated.model.Topup

## Load the model package
```dart
import 'package:turbo_api_generated/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | UUID (v7 recommended so ids sort by creation time). | 
**studentId** | **String** | UUID (v7 recommended so ids sort by creation time). | [optional] 
**status** | **String** |  | 
**amountPesewas** | **int** | Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500. | 
**channel** | **String** |  | 
**reference** | **String** |  | 
**checkout** | [**TopupCheckout**](TopupCheckout.md) |  | [optional] 
**createdAt** | [**DateTime**](DateTime.md) |  | 
**completedAt** | [**DateTime**](DateTime.md) |  | [optional] 
**amountReceivedPesewas** | **int** | What the provider says it collected. Credit is always this amount. | [optional] 
**validation** | **String** | Payaza amount_validation, lower-cased. | [optional] 
**flagged** | **bool** | True when validation is not exact, or the provider reversed it, or a reconciliation run found a mismatch. | [optional] 
**flagReason** | **String** |  | [optional] 
**resolvedAt** | [**DateTime**](DateTime.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


