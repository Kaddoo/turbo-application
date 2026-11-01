import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';
import 'src/features/push/push_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final hasPush = await initFirebase();
  runApp(
    // Riverpod retries failed providers on its own by default. Our providers
    // decide for themselves what a failure means, so retries are off.
    ProviderScope(
      retry: (_, _) => null,
      overrides: [pushPlatformProvider.overrideWithValue(hasPush ? const FirebasePushPlatform() : null)],
      child: const App(),
    ),
  );
}
