import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';

// tests for ReconciliationReport
void main() {
  final ReconciliationReport? instance = /* ReconciliationReport(...) */ null;
  // TODO add properties to the entity

  group(ReconciliationReport, () {
    // UUID (v7 recommended so ids sort by creation time).
    // String id
    test('to test the property `id`', () async {
      // TODO
    });

    // DateTime periodFrom
    test('to test the property `periodFrom`', () async {
      // TODO
    });

    // DateTime periodTo
    test('to test the property `periodTo`', () async {
      // TODO
    });

    // int matchedCount
    test('to test the property `matchedCount`', () async {
      // TODO
    });

    // Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
    // int providerTotalPesewas
    test('to test the property `providerTotalPesewas`', () async {
      // TODO
    });

    // Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
    // int ourTotalPesewas
    test('to test the property `ourTotalPesewas`', () async {
      // TODO
    });

    // List<ReconciliationItem> exceptions
    test('to test the property `exceptions`', () async {
      // TODO
    });

    // DateTime createdAt
    test('to test the property `createdAt`', () async {
      // TODO
    });

  });
}
