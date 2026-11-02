# turbo_api_generated.model.DriverDocumentStatus

## Load the model package
```dart
import 'package:turbo_api_generated/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**type** | [**DriverDocumentKind**](DriverDocumentKind.md) |  | 
**expiresOn** | [**DateTime**](DateTime.md) |  | [optional] 
**daysLeft** | **int** | Whole days from today (Africa/Accra) to `expiresOn`, negative once expired. Null when the document has no expiry. | [optional] 
**status** | **String** | `expiring` is under 30 days left; `expired` is past `expiresOn`. Computed by the server so the phone clock does not matter. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


