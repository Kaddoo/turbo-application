# turbo_api_generated.model.AuditEntry

## Load the model package
```dart
import 'package:turbo_api_generated/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | UUID (v7 recommended so ids sort by creation time). | 
**at** | [**DateTime**](DateTime.md) |  | 
**actorStaffId** | **String** | UUID (v7 recommended so ids sort by creation time). | [optional] 
**action** | **String** | e.g. verification.approved, wallet.adjusted, ride.reassigned | 
**entityType** | **String** |  | 
**entityId** | **String** | UUID (v7 recommended so ids sort by creation time). | 
**detail** | **Map&lt;String, Object&gt;** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


