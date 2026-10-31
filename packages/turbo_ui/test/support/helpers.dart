import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_ui/turbo_ui.dart';

/// Pumps [child] in a themed app. Phone-sized, dark by default.
Future<void> pumpTurbo(
  WidgetTester tester,
  Widget child, {
  BrandTokens brand = turboBrand,
  Brightness brightness = Brightness.dark,
  double textScale = 1,
  Size size = const Size(390, 844),
  bool reduceMotion = false,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: buildTurboTheme(brand, brightness),
      localizationsDelegates: TurboUiLocalizations.localizationsDelegates,
      supportedLocales: TurboUiLocalizations.supportedLocales,
      builder: (context, app) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(textScale),
          disableAnimations: reduceMotion,
        ),
        child: app!,
      ),
      home: Scaffold(body: child),
    ),
  );
  await tester.pump();
}
