# turbo_api_generated.model.WalletTransaction

## Load the model package
```dart
import 'package:turbo_api_generated/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | UUID (v7 recommended so ids sort by creation time). | 
**type** | [**TransactionType**](TransactionType.md) |  | 
**amountPesewas** | **int** | Signed pesewas. Positive credits the wallet, negative debits it. | 
**affectsBalance** | **bool** | False for ride_hold and ride_release, which only move money between available and reserved. | 
**balanceAfterPesewas** | **int** | Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500. | 
**rideId** | **String** | UUID (v7 recommended so ids sort by creation time). | [optional] 
**description** | **String** |  | 
**createdAt** | [**DateTime**](DateTime.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


