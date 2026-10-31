# turbo_api_generated.model.OtpVerify

## Load the model package
```dart
import 'package:turbo_api_generated/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**phone** | **String** |  | 
**code** | **String** |  | 
**role** | **String** |  | 
**clientType** | **String** | mobile: refresh token returned in the body. web: refresh token set as an httpOnly cookie and omitted from the body. | 
**acceptedTermsVersion** | **String** | Required on first login (terms_not_accepted if missing). Stored with time and client. | [optional] 
**acceptedPrivacyVersion** | **String** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


