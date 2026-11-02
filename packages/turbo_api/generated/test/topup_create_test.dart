import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';

// tests for TopupCreate
void main() {
  final TopupCreate? instance = /* TopupCreate(...) */ null;
  // TODO add properties to the entity

  group(TopupCreate, () {
    // Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
    // int amountPesewas
    test('to test the property `amountPesewas`', () async {
      // TODO
    });

    // String channel
    test('to test the property `channel`', () async {
      // TODO
    });

    // The mobile money network. Leave it out to let the server work it out from the number; if it cannot, 422 `network_unknown` and the app asks \"Pay with\" and sends the choice.
    // MomoNetwork network
    test('to test the property `network`', () async {
      // TODO
    });

    // The number that approves the payment, E.164. Defaults to the number the student signed in with.
    // String msisdn
    test('to test the property `msisdn`', () async {
      // TODO
    });

  });
}
