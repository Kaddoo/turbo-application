import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turbo_ui/turbo_ui.dart';

import 'core/flow.dart';
import 'core/flow_provider.dart';
import 'core/gate.dart';
import 'core/profile.dart';
import 'core/providers.dart';
import 'core/session.dart';
import 'features/push/push_service.dart';
import 'l10n/app_localizations.dart';
import 'router.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  final _push = <StreamSubscription<PushMessage>>[];
  String? _pendingRoute;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _listenForPush();
  }

  /// Taps and messages from the push system. Without Firebase this does nothing.
  Future<void> _listenForPush() async {
    final platform = ref.read(pushPlatformProvider);
    if (platform == null) return;
    _push
      ..add(platform.onOpened.listen(_open))
      ..add(platform.onForeground.listen(_showInApp));
    final first = await platform.initialMessage();
    if (first != null) _open(first);
  }

  void _open(PushMessage m) {
    final route = pushRoute(m.data);
    if (route == null) return;
    if (ref.read(flowProvider) == FlowStep.home) {
      ref.read(routerProvider).go(route);
    } else {
      _pendingRoute = route;
    }
  }

  void _showInApp(PushMessage m) {
    // Whatever changed on the server, the screens ask again.
    ref.read(profileProvider.notifier).reload();
    final context = ref.read(routerProvider).routerDelegate.navigatorKey.currentContext;
    final text = [m.title, m.body].whereType<String>().join('. ');
    if (context != null && context.mounted && text.isNotEmpty) showTurboToast(context, text);
  }

  @override
  void dispose() {
    for (final s in _push) {
      s.cancel();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// The app-config check and the profile (duty, current ride) run on every
  /// resume, not just on start.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(gateProvider.notifier).recheck();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(sessionProvider, (prev, next) {
      final was = prev?.value?.status == SessionStatus.signedIn;
      final now = next.value?.status == SessionStatus.signedIn;
      if (now && !was) ref.read(pushRegistrarProvider).register(platformName: platformKey());
    });
    ref.listen(flowProvider, (_, step) {
      final route = _pendingRoute;
      if (step == FlowStep.home && route != null) {
        _pendingRoute = null;
        ref.read(routerProvider).go(route);
      }
    });
    return MaterialApp.router(
      onGenerateTitle: (_) => turboBrand.appName,
      theme: buildTurboTheme(turboBrand, Brightness.light),
      darkTheme: buildTurboTheme(turboBrand, Brightness.dark),
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...TurboUiLocalizations.localizationsDelegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
