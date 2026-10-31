import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';


/// tests for WalletApi
void main() {
  final instance = TurboApiGenerated().getWalletApi();

  group(WalletApi, () {
    // Start a top-up
    //
    // **Access:** student.  Amount must sit inside the admin-configured min and max, otherwise 422 `topup_amount_out_of_range`. The wallet is only credited by a verified provider webhook, never by the app.
    //
    //Future<Topup> createTopup(String idempotencyKey, TopupCreate topupCreate) async
    test('test createTopup', () async {
      // TODO
    });

    // Top-up status (poll after checkout)
    //
    // **Access:** student.
    //
    //Future<Topup> getTopup(String id) async
    test('test getTopup', () async {
      // TODO
    });

    // Balance, reserved and available
    //
    // **Access:** student.
    //
    //Future<Wallet> getWallet() async
    test('test getWallet', () async {
      // TODO
    });

    // Wallet history
    //
    // **Access:** student.
    //
    //Future<WalletTransactionList> listWalletTransactions({ TransactionType type, String cursor, int limit }) async
    test('test listWalletTransactions', () async {
      // TODO
    });

  });
}
