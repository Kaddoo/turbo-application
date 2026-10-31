import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';

// tests for ReconciliationItem
void main() {
  final ReconciliationItem? instance = /* ReconciliationItem(...) */ null;
  // TODO add properties to the entity

  group(ReconciliationItem, () {
    // String providerReference
    test('to test the property `providerReference`', () async {
      // TODO
    });

    // UUID (v7 recommended so ids sort by creation time).
    // String topupId
    test('to test the property `topupId`', () async {
      // TODO
    });

    // Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
    // int providerAmountPesewas
    test('to test the property `providerAmountPesewas`', () async {
      // TODO
    });

    // Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
    // int ourAmountPesewas
    test('to test the property `ourAmountPesewas`', () async {
      // TODO
    });

    // String issue
    test('to test the property `issue`', () async {
      // TODO
    });

  });
}
