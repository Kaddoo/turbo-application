import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/flow.dart';
import 'core/flow_provider.dart';
import 'features/auth/code_screen.dart';
import 'features/auth/phone_screen.dart';
import 'features/auth/terms_screen.dart';
import 'features/auth/welcome_screen.dart';
import 'features/gate/gate_screens.dart';
import 'features/home/home_screen.dart';
import 'features/me/me_screen.dart';
import 'features/me/record_screens.dart';
import 'features/me/trips_screen.dart';
import 'features/support/help_screen.dart';
import 'features/support/support_screens.dart';
import 'features/ride/ride_screen.dart';
import 'features/shell/main_shell.dart';
import 'package:turbo_ui/turbo_ui.dart';

import 'location/spike_screen.dart';

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
    redirect: (context, state) => redirectFor(ref.read(flowProvider), state.matchedLocation),
    routes: [
      GoRoute(path: '/loading', builder: (_, _) => const LoadingScreen()),
      GoRoute(path: '/offline', builder: (_, _) => const BootErrorScreen()),
      GoRoute(path: '/update', builder: (_, _) => const UpdateRequiredScreen()),
      GoRoute(path: '/maintenance', builder: (_, _) => const MaintenanceScreen()),
      GoRoute(path: '/suspended', builder: (_, _) => const SuspendedScreen()),
      GoRoute(path: '/welcome', builder: (_, _) => const WelcomeScreen()),
      GoRoute(path: '/phone', builder: (_, _) => const PhoneScreen()),
      GoRoute(path: '/code', builder: (_, _) => const CodeScreen()),
      GoRoute(path: '/terms', builder: (_, _) => const TermsScreen()),
      ShellRoute(
        navigatorKey: _shellKey,
        builder: (_, _, child) => MainShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
          GoRoute(path: '/trips', builder: (_, _) => const TripsScreen()),
          GoRoute(path: '/trips/shifts', builder: (_, _) => const ShiftsScreen()),
          GoRoute(path: '/trips/hours', builder: (_, _) => const AttendanceScreen()),
          GoRoute(path: '/trips/salary', builder: (_, _) => const SalaryScreen()),
          GoRoute(path: '/help', builder: (_, _) => const HelpScreen()),
          GoRoute(path: '/me', builder: (_, _) => const MeScreen()),
        ],
      ),
      GoRoute(path: '/support', parentNavigatorKey: _rootKey, builder: (_, _) => const SupportListScreen()),
      GoRoute(path: '/support/new', parentNavigatorKey: _rootKey, builder: (_, state) => NewTicketScreen(rideId: state.extra as String?)),
      GoRoute(
        path: '/support/:id',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => TicketScreen(ticketId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/ride', parentNavigatorKey: _rootKey, builder: (_, _) => const DriverRideScreen()),
      // Developer screen for the background-location test; not linked from the app.
      GoRoute(path: '/spike', parentNavigatorKey: _rootKey, builder: (_, _) => const LocationSpikeScreen(brand: turboBrand)),
    ],
  );
});
