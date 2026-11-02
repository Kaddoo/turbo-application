# turbo_api_generated.model.AppConfig

## Load the model package
```dart
import 'package:turbo_api_generated/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**minVersion** | [**AppConfigMinVersion**](AppConfigMinVersion.md) |  | 
**maintenance** | [**AppConfigMaintenance**](AppConfigMaintenance.md) |  | 
**bookingsPaused** | **bool** |  | 
**pauseMessage** | **String** |  | [optional] 
**supervisorPhone** | **String** | The drivers' supervisor, E.164. Null until staff set it; the apps then draw no call button. | [optional] 
**campusSecurityPhone** | **String** | Campus security, E.164. Null until staff set it; the apps then show 112 only. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


