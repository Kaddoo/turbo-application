# turbo_api_generated.model.VerificationState

## Load the model package
```dart
import 'package:turbo_api_generated/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**status** | [**VerificationStatus**](VerificationStatus.md) |  | 
**reasonCode** | **String** | Why it was sent back or rejected, e.g. document_unclear, name_mismatch, expired_id. | [optional] 
**message** | **String** | Plain-language explanation to show the student. | [optional] 
**submittedAt** | [**DateTime**](DateTime.md) |  | [optional] 
**decidedAt** | [**DateTime**](DateTime.md) |  | [optional] 
**canResubmit** | **bool** |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


