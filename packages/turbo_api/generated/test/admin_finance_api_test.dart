import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';


/// tests for AdminFinanceApi
void main() {
  final instance = TurboApiGenerated().getAdminFinanceApi();

  group(AdminFinanceApi, () {
    // Credit or debit with a reason
    //
    // **Access:** admin:finance.  Append-only ledger entry. Debits that would take the balance below zero are rejected.  At or below `adjustmentApprovalThresholdPesewas` the adjustment applies at once (201). Above it, a pending request is created (202) and a different finance or super_admin user must approve it. You cannot adjust a wallet whose phone number is your own (403 `self_adjustment_forbidden`).
    //
    //Future<WalletTransaction> adjustWallet(String id, String idempotencyKey, WalletAdjustment walletAdjustment) async
    test('test adjustWallet', () async {
      // TODO
    });

    // Approve an adjustment request
    //
    // **Access:** admin:finance. The requester cannot decide their own request (409 `approval_by_requester_forbidden`). Approval writes the ledger entry in one transaction and is idempotent.
    //
    //Future<AdjustmentRequest> approveAdjustment(String id, String idempotencyKey, AdjustmentDecision adjustmentDecision) async
    test('test approveAdjustment', () async {
      // TODO
    });

    // A student's wallet
    //
    // **Access:** admin:finance.
    //
    //Future<Wallet> getStudentWallet(String id) async
    test('test getStudentWallet', () async {
      // TODO
    });

    // Adjustment requests
    //
    // **Access:** admin:finance.
    //
    //Future<AdjustmentRequestList> listAdjustmentRequests({ String status, String cursor, int limit }) async
    test('test listAdjustmentRequests', () async {
      // TODO
    });

    // Past reconciliation reports
    //
    // **Access:** admin:finance.
    //
    //Future<ReconciliationReportList> listReconciliationReports({ String cursor, int limit }) async
    test('test listReconciliationReports', () async {
      // TODO
    });

    // A student's wallet history
    //
    // **Access:** admin:finance.
    //
    //Future<WalletTransactionList> listStudentWalletTransactions(String id, { TransactionType type, String cursor, int limit }) async
    test('test listStudentWalletTransactions', () async {
      // TODO
    });

    // All top-ups for reconciliation
    //
    // **Access:** admin:finance.
    //
    //Future<TopupList> listTopups({ String status, String studentId, String cursor, int limit, bool flagged, DateTime from, DateTime to }) async
    test('test listTopups', () async {
      // TODO
    });

    // Refund a ride in full or in part
    //
    // **Access:** admin:finance.  409 `refund_exceeds_charge` when the amount is more than was charged minus earlier refunds.
    //
    //Future<WalletTransaction> refundRide(String id, String idempotencyKey, RefundRequest refundRequest) async
    test('test refundRide', () async {
      // TODO
    });

    // Reject an adjustment request
    //
    // **Access:** admin:finance. The requester cannot decide their own request (409 `approval_by_requester_forbidden`). Approval writes the ledger entry in one transaction and is idempotent.
    //
    //Future<AdjustmentRequest> rejectAdjustment(String id, String idempotencyKey, AdjustmentDecision adjustmentDecision) async
    test('test rejectAdjustment', () async {
      // TODO
    });

    // Close a flagged top-up
    //
    // **Access:** admin:finance.  Clears the flag, records the decision in the audit log. Any wallet change goes through the adjustment endpoint, not here. Send an `Idempotency-Key` (required). A retry with the same key and body returns the first answer and does nothing twice; the same key with a different body is 409 `idempotency_key_reused`.
    //
    //Future<Topup> resolveTopup(String idempotencyKey, String id, TopupResolve topupResolve) async
    test('test resolveTopup', () async {
      // TODO
    });

    // Compare our top-ups with the provider statement
    //
    // **Access:** admin:finance.  Matches by provider reference. Every mismatch becomes an exception and flags the top-up. Runs on the same totals as the nightly self-check but against the outside world. Send an `Idempotency-Key` (required). A retry with the same key and body returns the first answer and does nothing twice; the same key with a different body is 409 `idempotency_key_reused`.
    //
    //Future<ReconciliationReport> runReconciliation(String idempotencyKey, ReconciliationRun reconciliationRun) async
    test('test runReconciliation', () async {
      // TODO
    });

  });
}
