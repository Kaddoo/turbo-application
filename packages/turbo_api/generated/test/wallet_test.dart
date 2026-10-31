import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';

// tests for Wallet
void main() {
  final Wallet? instance = /* Wallet(...) */ null;
  // TODO add properties to the entity

  group(Wallet, () {
    // Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
    // int balancePesewas
    test('to test the property `balancePesewas`', () async {
      // TODO
    });

    // Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
    // int reservedPesewas
    test('to test the property `reservedPesewas`', () async {
      // TODO
    });

    // Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
    // int availablePesewas
    test('to test the property `availablePesewas`', () async {
      // TODO
    });

    // String currency
    test('to test the property `currency`', () async {
      // TODO
    });

    // Amount the student owes after a provider reversal. While above zero, booking is blocked (account_owes).
    // int owedPesewas
    test('to test the property `owedPesewas`', () async {
      // TODO
    });

  });
}
