import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/flow.dart';
import 'core/flow_provider.dart';
import 'features/activity/activity_screen.dart';
import 'features/auth/code_screen.dart';
import 'features/auth/phone_screen.dart';
import 'features/auth/terms_screen.dart';
import 'features/auth/welcome_screen.dart';
import 'features/gate/gate_screens.dart';
import 'features/home/destination_screen.dart';
import 'features/home/home_screen.dart';
import 'features/home/quote_screen.dart';
import 'features/wallet/topup_screen.dart';
import 'features/wallet/topup_waiting_screen.dart';
import 'features/wallet/transactions_screen.dart';
import 'features/wallet/wallet_screen.dart';
import 'features/shell/main_shell.dart';
import 'features/verification/verification_capture_screen.dart';
import 'features/verification/verification_status_screen.dart';

final _rootKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final changed = ValueNotifier<int>(0);
  ref.listen<FlowStep>(flowProvider, (_, _) => changed.value++);
  ref.onDispose(changed.dispose);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/loading',
    refreshListenable: changed,
    redirect: (context, state) =>
        redirectFor(ref.read(flowProvider), state.matchedLocation),
    routes: [
      GoRoute(path: '/loading', builder: (_, _) => const LoadingScreen()),
      GoRoute(path: '/offline', builder: (_, _) => const BootErrorScreen()),
      GoRoute(path: '/update', builder: (_, _) => const UpdateRequiredScreen()),
      GoRoute(
        path: '/maintenance',
        builder: (_, _) => const MaintenanceScreen(),
      ),
      GoRoute(path: '/suspended', builder: (_, _) => const SuspendedScreen()),
      GoRoute(path: '/welcome', builder: (_, _) => const WelcomeScreen()),
      GoRoute(path: '/phone', builder: (_, _) => const PhoneScreen()),
      GoRoute(path: '/code', builder: (_, _) => const CodeScreen()),
      GoRoute(path: '/terms', builder: (_, _) => const TermsScreen()),
      GoRoute(
        path: '/verification',
        builder: (_, _) => const VerificationCaptureScreen(),
      ),
      GoRoute(
        path: '/verification/status',
        builder: (_, _) => const VerificationStatusScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellKey,
        builder: (_, _, child) => MainShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
          GoRoute(path: '/wallet', builder: (_, _) => const WalletScreen()),
          GoRoute(path: '/activity', builder: (_, _) => const ActivityScreen()),
        ],
      ),
      // Ride and money flows sit above the bottom bar, full screen.
      GoRoute(
        path: '/home/destination',
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const DestinationScreen(),
      ),
      GoRoute(
        path: '/home/quote',
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const QuoteScreen(),
      ),
      GoRoute(
        path: '/wallet/topup',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => TopupScreen(suggested: state.extra as int?),
      ),
      GoRoute(
        path: '/wallet/topup/waiting',
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const TopupWaitingScreen(),
      ),
      GoRoute(
        path: '/wallet/transactions',
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const TransactionsScreen(),
      ),
    ],
  );
});
