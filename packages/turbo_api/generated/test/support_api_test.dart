import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';


/// tests for SupportApi
void main() {
  final instance = TurboApiGenerated().getSupportApi();

  group(SupportApi, () {
    // Report an issue or ask for help
    //
    // **Access:** student, driver.
    //
    //Future<SupportTicket> createSupportTicket(SupportTicketCreate supportTicketCreate) async
    test('test createSupportTicket', () async {
      // TODO
    });

    // One ticket with its messages
    //
    // **Access:** student, driver.
    //
    //Future<SupportTicket> getMySupportTicket(String id) async
    test('test getMySupportTicket', () async {
      // TODO
    });

    // My tickets
    //
    // **Access:** student, driver.
    //
    //Future<SupportTicketList> listMySupportTickets({ String cursor, int limit }) async
    test('test listMySupportTickets', () async {
      // TODO
    });

    // Reply on a ticket
    //
    // **Access:** student, driver. 409 `ticket_state_invalid`: the ticket is closed; open a new one.
    //
    //Future<SupportMessage> replyToSupportTicket(String id, SupportMessageCreate supportMessageCreate) async
    test('test replyToSupportTicket', () async {
      // TODO
    });

  });
}
