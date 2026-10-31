import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';

// tests for WalletTransaction
void main() {
  final WalletTransaction? instance = /* WalletTransaction(...) */ null;
  // TODO add properties to the entity

  group(WalletTransaction, () {
    // UUID (v7 recommended so ids sort by creation time).
    // String id
    test('to test the property `id`', () async {
      // TODO
    });

    // TransactionType type
    test('to test the property `type`', () async {
      // TODO
    });

    // Signed pesewas. Positive credits the wallet, negative debits it.
    // int amountPesewas
    test('to test the property `amountPesewas`', () async {
      // TODO
    });

    // False for ride_hold and ride_release, which only move money between available and reserved.
    // bool affectsBalance
    test('to test the property `affectsBalance`', () async {
      // TODO
    });

    // Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
    // int balanceAfterPesewas
    test('to test the property `balanceAfterPesewas`', () async {
      // TODO
    });

    // UUID (v7 recommended so ids sort by creation time).
    // String rideId
    test('to test the property `rideId`', () async {
      // TODO
    });

    // String description
    test('to test the property `description`', () async {
      // TODO
    });

    // DateTime createdAt
    test('to test the property `createdAt`', () async {
      // TODO
    });

  });
}
