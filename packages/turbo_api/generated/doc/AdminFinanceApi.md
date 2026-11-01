# turbo_api_generated.api.AdminFinanceApi

## Load the API package
```dart
import 'package:turbo_api_generated/api.dart';
```

All URIs are relative to *http://localhost:4010*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adjustWallet**](AdminFinanceApi.md#adjustwallet) | **POST** /admin/students/{id}/wallet/adjustments | Credit or debit with a reason
[**approveAdjustment**](AdminFinanceApi.md#approveadjustment) | **POST** /admin/wallet-adjustments/{id}/approve | Approve an adjustment request
[**getStudentWallet**](AdminFinanceApi.md#getstudentwallet) | **GET** /admin/students/{id}/wallet | A student&#39;s wallet
[**listAdjustmentRequests**](AdminFinanceApi.md#listadjustmentrequests) | **GET** /admin/wallet-adjustments | Adjustment requests
[**listReconciliationReports**](AdminFinanceApi.md#listreconciliationreports) | **GET** /admin/reconciliation/reports | Past reconciliation reports
[**listStudentWalletTransactions**](AdminFinanceApi.md#liststudentwallettransactions) | **GET** /admin/students/{id}/wallet/transactions | A student&#39;s wallet history
[**listTopups**](AdminFinanceApi.md#listtopups) | **GET** /admin/topups | All top-ups for reconciliation
[**refundRide**](AdminFinanceApi.md#refundride) | **POST** /admin/rides/{id}/refund | Refund a ride in full or in part
[**rejectAdjustment**](AdminFinanceApi.md#rejectadjustment) | **POST** /admin/wallet-adjustments/{id}/reject | Reject an adjustment request
[**resolveTopup**](AdminFinanceApi.md#resolvetopup) | **POST** /admin/topups/{id}/resolve | Close a flagged top-up
[**runReconciliation**](AdminFinanceApi.md#runreconciliation) | **POST** /admin/reconciliation/reports | Compare our top-ups with the provider statement


# **adjustWallet**
> WalletTransaction adjustWallet(id, idempotencyKey, walletAdjustment)

Credit or debit with a reason

**Access:** admin:finance.  Append-only ledger entry. Debits that would take the balance below zero are rejected.  At or below `adjustmentApprovalThresholdPesewas` the adjustment applies at once (201). Above it, a pending request is created (202) and a different finance or super_admin user must approve it. You cannot adjust a wallet whose phone number is your own (403 `self_adjustment_forbidden`).

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminFinanceApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String idempotencyKey = idempotencyKey_example; // String | Client generated UUID. Reuse it when retrying the same request.
final WalletAdjustment walletAdjustment = ; // WalletAdjustment | 

try {
    final response = api.adjustWallet(id, idempotencyKey, walletAdjustment);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->adjustWallet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **idempotencyKey** | **String**| Client generated UUID. Reuse it when retrying the same request. | 
 **walletAdjustment** | [**WalletAdjustment**](WalletAdjustment.md)|  | 

### Return type

[**WalletTransaction**](WalletTransaction.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **approveAdjustment**
> AdjustmentRequest approveAdjustment(id, idempotencyKey, adjustmentDecision)

Approve an adjustment request

**Access:** admin:finance. The requester cannot decide their own request (409 `approval_by_requester_forbidden`). Approval writes the ledger entry in one transaction and is idempotent.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminFinanceApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String idempotencyKey = idempotencyKey_example; // String | Client generated UUID. Reuse it when retrying the same request.
final AdjustmentDecision adjustmentDecision = ; // AdjustmentDecision | 

try {
    final response = api.approveAdjustment(id, idempotencyKey, adjustmentDecision);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->approveAdjustment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **idempotencyKey** | **String**| Client generated UUID. Reuse it when retrying the same request. | 
 **adjustmentDecision** | [**AdjustmentDecision**](AdjustmentDecision.md)|  | 

### Return type

[**AdjustmentRequest**](AdjustmentRequest.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getStudentWallet**
> Wallet getStudentWallet(id)

A student's wallet

**Access:** admin:finance.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminFinanceApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getStudentWallet(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->getStudentWallet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**Wallet**](Wallet.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAdjustmentRequests**
> AdjustmentRequestList listAdjustmentRequests(status, cursor, limit)

Adjustment requests

**Access:** admin:finance.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminFinanceApi();
final String status = status_example; // String | 
final String cursor = cursor_example; // String | Opaque cursor from `page.nextCursor`.
final int limit = 56; // int | 

try {
    final response = api.listAdjustmentRequests(status, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->listAdjustmentRequests: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] 
 **cursor** | **String**| Opaque cursor from `page.nextCursor`. | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**AdjustmentRequestList**](AdjustmentRequestList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listReconciliationReports**
> ReconciliationReportList listReconciliationReports(cursor, limit)

Past reconciliation reports

**Access:** admin:finance.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminFinanceApi();
final String cursor = cursor_example; // String | Opaque cursor from `page.nextCursor`.
final int limit = 56; // int | 

try {
    final response = api.listReconciliationReports(cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->listReconciliationReports: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque cursor from `page.nextCursor`. | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**ReconciliationReportList**](ReconciliationReportList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listStudentWalletTransactions**
> WalletTransactionList listStudentWalletTransactions(id, type, cursor, limit)

A student's wallet history

**Access:** admin:finance.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminFinanceApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final TransactionType type = ; // TransactionType | 
final String cursor = cursor_example; // String | Opaque cursor from `page.nextCursor`.
final int limit = 56; // int | 

try {
    final response = api.listStudentWalletTransactions(id, type, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->listStudentWalletTransactions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
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

# **listTopups**
> TopupList listTopups(status, studentId, cursor, limit, flagged, from, to)

All top-ups for reconciliation

**Access:** admin:finance.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminFinanceApi();
final String status = status_example; // String | 
final String studentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String cursor = cursor_example; // String | Opaque cursor from `page.nextCursor`.
final int limit = 56; // int | 
final bool flagged = true; // bool | Exceptions queue.
final DateTime from = 2013-10-20; // DateTime | 
final DateTime to = 2013-10-20; // DateTime | 

try {
    final response = api.listTopups(status, studentId, cursor, limit, flagged, from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->listTopups: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] 
 **studentId** | **String**|  | [optional] 
 **cursor** | **String**| Opaque cursor from `page.nextCursor`. | [optional] 
 **limit** | **int**|  | [optional] [default to 20]
 **flagged** | **bool**| Exceptions queue. | [optional] 
 **from** | **DateTime**|  | [optional] 
 **to** | **DateTime**|  | [optional] 

### Return type

[**TopupList**](TopupList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **refundRide**
> WalletTransaction refundRide(id, idempotencyKey, refundRequest)

Refund a ride in full or in part

**Access:** admin:finance.  409 `refund_exceeds_charge` when the amount is more than was charged minus earlier refunds.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminFinanceApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String idempotencyKey = idempotencyKey_example; // String | Client generated UUID. Reuse it when retrying the same request.
final RefundRequest refundRequest = ; // RefundRequest | 

try {
    final response = api.refundRide(id, idempotencyKey, refundRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->refundRide: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **idempotencyKey** | **String**| Client generated UUID. Reuse it when retrying the same request. | 
 **refundRequest** | [**RefundRequest**](RefundRequest.md)|  | 

### Return type

[**WalletTransaction**](WalletTransaction.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **rejectAdjustment**
> AdjustmentRequest rejectAdjustment(id, idempotencyKey, adjustmentDecision)

Reject an adjustment request

**Access:** admin:finance. The requester cannot decide their own request (409 `approval_by_requester_forbidden`). Approval writes the ledger entry in one transaction and is idempotent.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminFinanceApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String idempotencyKey = idempotencyKey_example; // String | Client generated UUID. Reuse it when retrying the same request.
final AdjustmentDecision adjustmentDecision = ; // AdjustmentDecision | 

try {
    final response = api.rejectAdjustment(id, idempotencyKey, adjustmentDecision);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->rejectAdjustment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **idempotencyKey** | **String**| Client generated UUID. Reuse it when retrying the same request. | 
 **adjustmentDecision** | [**AdjustmentDecision**](AdjustmentDecision.md)|  | 

### Return type

[**AdjustmentRequest**](AdjustmentRequest.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resolveTopup**
> Topup resolveTopup(idempotencyKey, id, topupResolve)

Close a flagged top-up

**Access:** admin:finance.  Clears the flag, records the decision in the audit log. Any wallet change goes through the adjustment endpoint, not here. Send an `Idempotency-Key` (required). A retry with the same key and body returns the first answer and does nothing twice; the same key with a different body is 409 `idempotency_key_reused`. 409 `topup_not_resolvable`: the top-up is not flagged, or was already resolved.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminFinanceApi();
final String idempotencyKey = idempotencyKey_example; // String | Client generated UUID. Reuse it when retrying the same request.
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final TopupResolve topupResolve = ; // TopupResolve | 

try {
    final response = api.resolveTopup(idempotencyKey, id, topupResolve);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->resolveTopup: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**| Client generated UUID. Reuse it when retrying the same request. | 
 **id** | **String**|  | 
 **topupResolve** | [**TopupResolve**](TopupResolve.md)|  | 

### Return type

[**Topup**](Topup.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **runReconciliation**
> ReconciliationReport runReconciliation(idempotencyKey, reconciliationRun)

Compare our top-ups with the provider statement

**Access:** admin:finance.  Matches by provider reference. Every mismatch becomes an exception and flags the top-up. Runs on the same totals as the nightly self-check but against the outside world. Send an `Idempotency-Key` (required). A retry with the same key and body returns the first answer and does nothing twice; the same key with a different body is 409 `idempotency_key_reused`.

### Example
```dart
import 'package:turbo_api_generated/api.dart';

final api = TurboApiGenerated().getAdminFinanceApi();
final String idempotencyKey = idempotencyKey_example; // String | Client generated UUID. Reuse it when retrying the same request.
final ReconciliationRun reconciliationRun = ; // ReconciliationRun | 

try {
    final response = api.runReconciliation(idempotencyKey, reconciliationRun);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->runReconciliation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**| Client generated UUID. Reuse it when retrying the same request. | 
 **reconciliationRun** | [**ReconciliationRun**](ReconciliationRun.md)|  | 

### Return type

[**ReconciliationReport**](ReconciliationReport.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json, application/problem+json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

