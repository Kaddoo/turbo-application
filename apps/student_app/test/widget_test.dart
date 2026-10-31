import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_ui/turbo_ui.dart';

import 'package:student_app/main.dart';

void main() {
  testWidgets('app starts on the component gallery', (tester) async {
    await tester.pumpWidget(const App());
    expect(find.byType(TurboGalleryScreen), findsOneWidget);
  });
}
