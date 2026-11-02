# turbo_api_generated.model.Settings

## Load the model package
```dart
import 'package:turbo_api_generated/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**announcement** | [**HomeNoticeInput**](HomeNoticeInput.md) | The home-screen notice (see AppConfig). Null clears it. | [optional] 
**maxTripDistanceMeters** | **int** |  | [default to 18000]
**quoteTtlSeconds** | **int** |  | [default to 300]
**driverAckTimeoutSeconds** | **int** |  | [default to 45]
**noDriverTimeoutSeconds** | **int** |  | [default to 300]
**minTopupPesewas** | **int** | Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500. | 
**maxTopupPesewas** | **int** | Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500. | 
**operatingHours** | [**List&lt;OperatingWindow&gt;**](OperatingWindow.md) |  | [optional] 
**driverSilenceSeconds** | **int** |  | [optional] [default to 180]
**noShowWaitSeconds** | **int** |  | [optional] [default to 300]
**quoteLimitPerMinute** | **int** |  | [optional] [default to 10]
**smsDailyLimit** | **int** |  | [optional] [default to 500]
**adjustmentApprovalThresholdPesewas** | **int** |  | [optional] [default to 5000]
**locationRetentionDays** | **int** |  | [optional] [default to 90]
**bookingsPaused** | **bool** | When true, quotes return ineligible with code bookings_paused and the message below. Rides already underway continue. | [optional] [default to false]
**pauseMessage** | **String** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


