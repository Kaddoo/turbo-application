import 'package:flutter/material.dart';
import 'package:turbo_ui/turbo_ui.dart';

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
      // Placeholder until the first real screen: the component gallery.
      home: const TurboGalleryScreen(brand: turboBrand),
    );
  }
}
