import 'package:flutter/material.dart';
import 'package:turbo_ui/turbo_ui.dart';

import 'src/location/spike_screen.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: turboBrand.appName,
      theme: buildTurboTheme(turboBrand, Brightness.light),
      darkTheme: buildTurboTheme(turboBrand, Brightness.dark),
      themeMode: ThemeMode.system,
      localizationsDelegates: TurboUiLocalizations.localizationsDelegates,
      supportedLocales: TurboUiLocalizations.supportedLocales,
      // The spike screen stands in for the duty screen until group 5.
      home: const LocationSpikeScreen(brand: turboBrand),
    );
  }
}
