import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';

/// The signed-in frame: Ride, Wallet and Activity. Ride flow screens sit above
/// it, full screen.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  static const _paths = ['/home', '/wallet', '/activity'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final location = GoRouterState.of(context).matchedLocation;
    final index = _paths.indexWhere(
      (p) => location == p || location.startsWith('$p/'),
    );
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index < 0 ? 0 : index,
        onDestinationSelected: (i) => context.go(_paths[i]),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.directions_car_outlined),
            selectedIcon: const Icon(Icons.directions_car),
            label: l10n.navRide,
          ),
          NavigationDestination(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: const Icon(Icons.account_balance_wallet),
            label: l10n.navWallet,
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: l10n.navActivity,
          ),
        ],
      ),
    );
  }
}
