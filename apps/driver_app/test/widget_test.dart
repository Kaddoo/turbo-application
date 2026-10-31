import 'package:driver_app/main.dart';
import 'package:driver_app/src/location/spike_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app starts on the location spike screen', (tester) async {
    await tester.pumpWidget(const App());
    expect(find.byType(LocationSpikeScreen), findsOneWidget);
    expect(find.text('Go on duty'), findsOneWidget);
  });
}
