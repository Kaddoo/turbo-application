# turbo_api_generated.model.StaffUser

## Load the model package
```dart
import 'package:turbo_api_generated/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | UUID (v7 recommended so ids sort by creation time). | 
**email** | **String** |  | 
**fullName** | **String** |  | 
**staffRole** | [**StaffRole**](StaffRole.md) |  | 
**isActive** | **bool** |  | 
**mfaEnrolled** | **bool** |  | 
**lastLoginAt** | [**DateTime**](DateTime.md) |  | [optional] 
**lockedUntil** | [**DateTime**](DateTime.md) |  | [optional] 
**invitePending** | **bool** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


