# turbo_api_generated.model.VerificationSubmission

## Load the model package
```dart
import 'package:turbo_api_generated/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**fullName** | **String** | As printed on the Ghana Card. | 
**studentIdNumber** | **String** |  | 
**ghanaCardFrontUploadId** | **String** | UUID (v7 recommended so ids sort by creation time). | 
**ghanaCardBackUploadId** | **String** | UUID (v7 recommended so ids sort by creation time). | 
**studentIdUploadId** | **String** | UUID (v7 recommended so ids sort by creation time). | 
**ghanaCardNumber** | **String** | Stored encrypted. One card, one account: a duplicate returns 409 duplicate_identity. | 
**selfieUploadId** | **String** | UUID (v7 recommended so ids sort by creation time). | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


