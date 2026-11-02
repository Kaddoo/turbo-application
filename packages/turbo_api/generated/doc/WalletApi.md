# turbo_api_generated.api.WalletApi

## Load the API package
```dart
import 'package:turbo_api_generated/api.dart';
```

All URIs are relative to *http://localhost:4010*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createTopup**](WalletApi.md#createtopup) | **POST** /wallet/topups | Start a top-up
[**getTopup**](WalletApi.md#gettopup) | **GET** /wallet/topups/{id} | Top-up status (poll after checkout)
[**getWallet**](WalletApi.md#getwallet) | **GET** /wallet | Balance, reserved and available
[**listWalletTransactions**](WalletApi.md#listwallettransactions) | **GET** /wallet/transactions | Wallet history


# **createTopup**
> Topup createTopup(idempotencyKey, topupCreate)

Start a top-up

**Access:** student.  Amount must sit inside the admin-configured min and max, otherwise 422 `topup_amount_out_of_range`. When the server cannot tell which network the number is on and none was sent, 422 `network_unknown`. The wallet is only credited by a verified provider webhook, never by the app.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getWalletApi();
final String idempotencyKey = idempotencyKey_example; // String | Client generated UUID. Reuse it when retrying the same request.
final TopupCreate topupCreate = ; // TopupCreate | 

try {
    final response = api.createTopup(idempotencyKey, topupCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WalletApi->createTopup: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**| Client generated UUID. Reuse it when retrying the same request. | 
 **topupCreate** | [**TopupCreate**](TopupCreate.md)|  | 

### Return type

[**Topup**](Topup.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTopup**
> Topup getTopup(id)

Top-up status (poll after checkout)

**Access:** student.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getWalletApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getTopup(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WalletApi->getTopup: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**Topup**](Topup.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getWallet**
> Wallet getWallet()

Balance, reserved and available

**Access:** student.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getWalletApi();

try {
    final response = api.getWallet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling WalletApi->getWallet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**Wallet**](Wallet.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listWalletTransactions**
> WalletTransactionList listWalletTransactions(type, cursor, limit)

Wallet history

**Access:** student.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getWalletApi();
final TransactionType type = ; // TransactionType | 
final String cursor = cursor_example; // String | Opaque cursor from `page.nextCursor`.
final int limit = 56; // int | 

try {
    final response = api.listWalletTransactions(type, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WalletApi->listWalletTransactions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **type** | [**TransactionType**](.md)|  | [optional] 
 **cursor** | **String**| Opaque cursor from `page.nextCursor`. | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**WalletTransactionList**](WalletTransactionList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

