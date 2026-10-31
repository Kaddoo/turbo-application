# turbo_api_generated.model.VerificationSummary

## Load the model package
```dart
import 'package:turbo_api_generated/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | UUID (v7 recommended so ids sort by creation time). | 
**student** | [**VerificationSummaryStudent**](VerificationSummaryStudent.md) |  | 
**status** | [**VerificationStatus**](VerificationStatus.md) |  | 
**submittedAt** | [**DateTime**](DateTime.md) |  | 
**claimedBy** | **String** | UUID (v7 recommended so ids sort by creation time). | [optional] 
**claimExpiresAt** | [**DateTime**](DateTime.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


