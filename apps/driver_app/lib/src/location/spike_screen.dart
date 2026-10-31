import 'dart:async';

import 'package:flutter/material.dart';
import 'package:turbo_api/turbo_api.dart';
import 'package:turbo_ui/turbo_ui.dart';

import 'api_sender.dart';
import 'location_access.dart';
import 'location_reporter.dart';

/// Throwaway screen for the background-location spike (risk R7). It exercises
/// the real pipeline against the mock. English is hard-coded on purpose; the
/// real duty screen replaces this.
class LocationSpikeScreen extends StatefulWidget {
  const LocationSpikeScreen({super.key, required this.brand});

  final BrandTokens brand;

  @override
  State<LocationSpikeScreen> createState() => _LocationSpikeScreenState();
}

class _LocationSpikeScreenState extends State<LocationSpikeScreen> with WidgetsBindingObserver {
  static const _baseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:4010');
  static const _gpsSilentAfter = Duration(seconds: 30);
  static const _serverSilentAfter = Duration(seconds: 30);

  late final TurboClient _client = TurboClient(
    baseUrl: _baseUrl,
    appVersion: 'ios/0.0.1',
    // The mock accepts any bearer token. Real login replaces this.
    accessToken: () => 'mock-token',
  );
  LocationReporter? _reporter;
  DriverLocationAccess? _access;
  Timer? _tick;
  DateTime _now = DateTime.now();
  final List<String> _lifecycle = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshAccess();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) => setState(() => _now = DateTime.now()));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tick?.cancel();
    _reporter?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final t = DateTime.now().toIso8601String().substring(11, 19);
    setState(() => _lifecycle.insert(0, '$t ${state.name}'));
    if (state == AppLifecycleState.resumed) _refreshAccess();
  }

  Future<void> _refreshAccess() async {
    final a = await checkLocationAccess();
    if (mounted) setState(() => _access = a);
  }

  Future<void> _ask() async {
    final a = await requestLocationAccess();
    if (mounted) setState(() => _access = a);
  }

  void _start() {
    final brand = widget.brand;
    final reporter = LocationReporter(
      source: backgroundPositions(
        notificationTitle: brand.appName,
        notificationText: '${brand.appName} is sharing your location while you are on duty.',
      ),
      send: apiSender(_client),
    )..start();
    setState(() => _reporter = reporter);
  }

  Future<void> _stop() async {
    final r = _reporter;
    await r?.stop();
    setState(() {});
  }

  String _age(DateTime? t) => t == null ? 'never' : '${_now.difference(t).inSeconds}s ago';

  String _elapsed(ReporterState s) {
    final start = s.startedAt;
    if (start == null) return '-';
    final d = _now.difference(start);
    return '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final t = context.turbo;
    final text = Theme.of(context).textTheme;
    final reporter = _reporter;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location spike'),
        actions: [
          IconButton(
            tooltip: 'Component gallery',
            icon: const Icon(Icons.palette_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => TurboGalleryScreen(brand: widget.brand)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder<ReporterState>(
          valueListenable: reporter?.state ?? ValueNotifier(const ReporterState()),
          builder: (context, s, _) {
            final silent = s.gpsSilent(_now, _gpsSilentAfter);
            final unreachable = s.serverUnreachable(_now, _serverSilentAfter);
            return ListView(
              padding: const EdgeInsets.all(TurboSpacing.lg),
              children: [
                if (silent || unreachable)
                  Padding(
                    padding: const EdgeInsets.only(bottom: TurboSpacing.lg),
                    child: TurboCard(
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: t.colors.danger),
                          const SizedBox(width: TurboSpacing.md),
                          Expanded(
                            child: Text(
                              silent
                                  ? "Your location isn't being shared. Open the app."
                                  : "We can't reach the server. Points are being kept and will be sent.",
                              style: text.bodyLarge?.copyWith(color: t.colors.danger),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Text('Permission', style: text.titleLarge),
                const SizedBox(height: TurboSpacing.sm),
                _accessChip(_access),
                const SizedBox(height: TurboSpacing.md),
                TurboButton(
                  label: 'Allow location',
                  variant: TurboButtonVariant.secondary,
                  onPressed: _ask,
                ),
                const SizedBox(height: TurboSpacing.sm),
                TurboButton(
                  label: 'Open Settings',
                  variant: TurboButtonVariant.secondary,
                  onPressed: openLocationSettings,
                ),
                const SizedBox(height: TurboSpacing.xl),
                TurboButton(
                  label: s.running ? 'Go off duty' : 'Go on duty',
                  large: true,
                  variant: s.running ? TurboButtonVariant.secondary : TurboButtonVariant.primary,
                  onPressed: s.running ? _stop : _start,
                ),
                const SizedBox(height: TurboSpacing.xl),
                Text('Numbers', style: text.titleLarge),
                const SizedBox(height: TurboSpacing.sm),
                TurboCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Server: $_baseUrl', style: text.bodySmall),
                      Text('On duty for: ${_elapsed(s)}', style: text.bodyLarge),
                      Text('Fixes from GPS: ${s.fixesReceived}', style: text.bodyLarge),
                      Text('Points sent: ${s.pointsSent} in ${s.requestsSent} requests', style: text.bodyLarge),
                      Text('Waiting to send: ${s.buffered}', style: text.bodyLarge),
                      Text('Dropped as too old: ${s.pointsDropped}', style: text.bodyLarge),
                      Text('Failed requests: ${s.failures}', style: text.bodyLarge),
                      Text('Last GPS fix: ${_age(s.lastFixAt)}', style: text.bodyLarge),
                      Text('Last accepted by server: ${_age(s.lastSuccessAt)}', style: text.bodyLarge),
                      if (s.lastError != null) Text('Last error: ${s.lastError}', style: text.bodySmall),
                    ],
                  ),
                ),
                const SizedBox(height: TurboSpacing.xl),
                Text('App state changes', style: text.titleLarge),
                const SizedBox(height: TurboSpacing.sm),
                TurboCard(
                  child: Text(
                    _lifecycle.isEmpty ? 'None yet' : _lifecycle.take(8).join('\n'),
                    style: text.bodySmall,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _accessChip(DriverLocationAccess? a) {
    final (label, icon, tone) = switch (a) {
      DriverLocationAccess.always => ('Always allowed', Icons.check_circle_outline, StatusTone.success),
      DriverLocationAccess.whileInUse => ('Only while using the app', Icons.warning_amber, StatusTone.warning),
      DriverLocationAccess.denied => ('Not allowed yet', Icons.error_outline, StatusTone.danger),
      DriverLocationAccess.deniedForever => ('Blocked in Settings', Icons.error_outline, StatusTone.danger),
      DriverLocationAccess.servicesOff => ('Location is switched off', Icons.error_outline, StatusTone.danger),
      null => ('Checking', Icons.schedule, StatusTone.neutral),
    };
    return Align(
      alignment: Alignment.centerLeft,
      child: StatusChip(label: label, icon: icon, tone: tone),
    );
  }
}
