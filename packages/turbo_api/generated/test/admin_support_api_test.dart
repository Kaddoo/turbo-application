import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';


/// tests for AdminSupportApi
void main() {
  final instance = TurboApiGenerated().getAdminSupportApi();

  group(AdminSupportApi, () {
    // Ticket with messages and internal notes
    //
    // **Access:** admin:support.
    //
    //Future<SupportTicket> getAdminSupportTicket(String id) async
    test('test getAdminSupportTicket', () async {
      // TODO
    });

    // All tickets
    //
    // **Access:** admin:support.
    //
    //Future<SupportTicketList> listAllSupportTickets({ String status, String category, String cursor, int limit }) async
    test('test listAllSupportTickets', () async {
      // TODO
    });

    // SOS and safety incidents
    //
    // **Access:** admin:support.
    //
    //Future<IncidentList> listIncidents({ String status, String cursor, int limit }) async
    test('test listIncidents', () async {
      // TODO
    });

    // Reply or add an internal note
    //
    // **Access:** admin:support.
    //
    //Future<SupportMessage> replyAsStaff(String id, SupportMessageCreate supportMessageCreate) async
    test('test replyAsStaff', () async {
      // TODO
    });

    // Acknowledge or resolve an incident
    //
    // **Access:** admin:support. 409 `incident_state_invalid`: the incident is already resolved, or is not open when acknowledging.
    //
    //Future<Incident> updateIncident(String id, IncidentUpdate incidentUpdate) async
    test('test updateIncident', () async {
      // TODO
    });

    // Change status or assignee
    //
    // **Access:** admin:support.
    //
    //Future<SupportTicket> updateSupportTicket(String id, TicketUpdate ticketUpdate) async
    test('test updateSupportTicket', () async {
      // TODO
    });

  });
}
