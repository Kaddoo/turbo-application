# turbo_api_generated.api.UploadsApi

## Load the API package
```dart
import 'package:turbo_api_generated/api.dart';
```

All URIs are relative to *http://localhost:4010*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createUpload**](UploadsApi.md#createupload) | **POST** /uploads | Get a signed URL to upload a file


# **createUpload**
> UploadSlot createUpload(uploadRequest)

Get a signed URL to upload a file

**Access:** any.  Files go straight to private object storage. Nothing here is ever publicly readable. Reference the returned uploadId in the next request.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getUploadsApi();
final UploadRequest uploadRequest = ; // UploadRequest | 

try {
    final response = api.createUpload(uploadRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UploadsApi->createUpload: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uploadRequest** | [**UploadRequest**](UploadRequest.md)|  | 

### Return type

[**UploadSlot**](UploadSlot.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

