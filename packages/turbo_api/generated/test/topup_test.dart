import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';

// tests for Topup
void main() {
  final Topup? instance = /* Topup(...) */ null;
  // TODO add properties to the entity

  group(Topup, () {
    // UUID (v7 recommended so ids sort by creation time).
    // String id
    test('to test the property `id`', () async {
      // TODO
    });

    // UUID (v7 recommended so ids sort by creation time).
    // String studentId
    test('to test the property `studentId`', () async {
      // TODO
    });

    // String status
    test('to test the property `status`', () async {
      // TODO
    });

    // Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
    // int amountPesewas
    test('to test the property `amountPesewas`', () async {
      // TODO
    });

    // String channel
    test('to test the property `channel`', () async {
      // TODO
    });

    // String reference
    test('to test the property `reference`', () async {
      // TODO
    });

    // TopupCheckout checkout
    test('to test the property `checkout`', () async {
      // TODO
    });

    // DateTime createdAt
    test('to test the property `createdAt`', () async {
      // TODO
    });

    // DateTime completedAt
    test('to test the property `completedAt`', () async {
      // TODO
    });

    // What the provider says it collected. Credit is always this amount.
    // int amountReceivedPesewas
    test('to test the property `amountReceivedPesewas`', () async {
      // TODO
    });

    // Payaza amount_validation, lower-cased.
    // String validation
    test('to test the property `validation`', () async {
      // TODO
    });

    // True when validation is not exact, or the provider reversed it, or a reconciliation run found a mismatch.
    // bool flagged
    test('to test the property `flagged`', () async {
      // TODO
    });

    // String flagReason
    test('to test the property `flagReason`', () async {
      // TODO
    });

    // DateTime resolvedAt
    test('to test the property `resolvedAt`', () async {
      // TODO
    });

  });
}
