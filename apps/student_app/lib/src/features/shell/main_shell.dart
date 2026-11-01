import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../l10n/app_localizations.dart';

/// The signed-in frame: Ride, Wallet and Activity. Ride flow screens sit above
/// it, full screen.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  static const _paths = ['/home', '/activity', '/wallet', '/profile'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final location = GoRouterState.of(context).matchedLocation;
    final index = _paths.indexWhere(
      (p) => location == p || location.startsWith('$p/'),
    );
    return Scaffold(
      body: child,
      bottomNavigationBar: FloatingNavBar(
        selectedIndex: index < 0 ? 0 : index,
        onSelected: (i) => context.go(_paths[i]),
        items: [
          FloatingNavItem(icon: Icons.home_outlined, selectedIcon: Icons.home, label: l10n.navRide),
          FloatingNavItem(icon: Icons.history, selectedIcon: Icons.history, label: l10n.navActivity),
          FloatingNavItem(icon: Icons.account_balance_wallet_outlined, selectedIcon: Icons.account_balance_wallet, label: l10n.navWallet),
          FloatingNavItem(icon: Icons.person_outline, selectedIcon: Icons.person, label: l10n.navProfile),
        ],
      ),
    );
  }
}
