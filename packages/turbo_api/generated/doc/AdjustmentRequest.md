# turbo_api_generated.model.AdjustmentRequest

## Load the model package
```dart
import 'package:turbo_api_generated/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | UUID (v7 recommended so ids sort by creation time). | 
**studentId** | **String** | UUID (v7 recommended so ids sort by creation time). | 
**amountPesewas** | **int** | Signed pesewas. Positive credits the wallet, negative debits it. | 
**reasonCode** | **String** |  | 
**note** | **String** |  | [optional] 
**status** | **String** |  | 
**requestedBy** | **String** | UUID (v7 recommended so ids sort by creation time). | 
**decidedBy** | **String** | UUID (v7 recommended so ids sort by creation time). | [optional] 
**createdAt** | [**DateTime**](DateTime.md) |  | 
**decidedAt** | [**DateTime**](DateTime.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


