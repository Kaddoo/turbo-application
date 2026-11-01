import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';

import '../../core/profile.dart';
import '../../l10n/app_localizations.dart';
import '../duty/location_sharing.dart';
import '../ride/ride_providers.dart';

/// The signed-in frame: Home, Trips, Me. It also keeps location sharing in step
/// with the server's duty status: on duty means sharing, anything else means not.
class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  static const _paths = ['/home', '/trips', '/help', '/me'];

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  void _sync(ProfileState? state) {
    final sharing = ref.read(locationSharingProvider.notifier);
    final on = state is ProfileLoaded && state.profile.dutyStatus == DriverProfileDutyStatusEnum.onDuty;
    if (on) {
      final l10n = AppLocalizations.of(context);
      final name = context.turbo.brand.appName;
      sharing.start(title: l10n.notificationTitle(name), text: l10n.notificationText(name));
    } else {
      sharing.stop();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _sync(ref.read(profileProvider).value));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    ref.listen(profileProvider, (_, next) => _sync(next.value));
    // A ride takes over the whole screen until it is over.
    ref.listen(currentRideProvider, (_, next) {
      if (next.value != null && !GoRouterState.of(context).matchedLocation.startsWith('/ride')) {
        context.go('/ride');
      }
    });
    final location = GoRouterState.of(context).matchedLocation;
    final index = MainShell._paths.indexWhere((p) => location == p || location.startsWith('$p/'));
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: FloatingNavBar(
        selectedIndex: index < 0 ? 0 : index,
        onSelected: (i) => context.go(MainShell._paths[i]),
        items: [
          FloatingNavItem(icon: Icons.home_outlined, selectedIcon: Icons.home, label: l10n.navHome),
          FloatingNavItem(icon: Icons.receipt_long_outlined, selectedIcon: Icons.receipt_long, label: l10n.navTrips),
          FloatingNavItem(icon: Icons.shield_outlined, selectedIcon: Icons.shield, label: l10n.navHelp),
          FloatingNavItem(icon: Icons.person_outline, selectedIcon: Icons.person, label: l10n.navMe),
        ],
      ),
    );
  }
}
