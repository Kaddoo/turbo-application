# turbo_api_generated.model.VerificationDetail

## Load the model package
```dart
import 'package:turbo_api_generated/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | UUID (v7 recommended so ids sort by creation time). | 
**student** | [**StudentSummary**](StudentSummary.md) |  | 
**status** | [**VerificationStatus**](VerificationStatus.md) |  | 
**submittedFullName** | **String** |  | 
**studentIdNumber** | **String** |  | 
**submittedAt** | [**DateTime**](DateTime.md) |  | 
**documents** | [**List&lt;VerificationDocument&gt;**](VerificationDocument.md) |  | 
**history** | [**List&lt;VerificationDecisionRecord&gt;**](VerificationDecisionRecord.md) |  | 
**ghanaCardNumber** | **String** | As submitted. Shown to verifiers only, for comparison with the card images. Stored encrypted. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


