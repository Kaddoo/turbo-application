import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';

void main() {
  runApp(
    // Riverpod retries failed providers on its own by default. Our providers
    // decide for themselves what a failure means, so retries are off.
    ProviderScope(retry: (_, _) => null, child: const App()),
  );
}
