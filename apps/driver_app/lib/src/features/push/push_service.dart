import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turbo_api/turbo_api.dart';

import '../../core/auth_draft.dart';
import '../../core/providers.dart';

/// A push message as the app sees it. The server puts only ids and a `type` in
/// `data`; details are fetched after the tap.
@immutable
class PushMessage {
  const PushMessage({this.title, this.body, this.data = const {}});

  final String? title;
  final String? body;
  final Map<String, String> data;

  String? get type => data['type'];
}

/// What the app needs from the push system. Behind an interface so tests need
/// no Firebase.
abstract class PushPlatform {
  /// Asks for permission. Returns false if the person said no.
  Future<bool> requestPermission();

  /// Whether notifications are allowed right now, without asking.
  Future<bool> notificationsEnabled();

  Future<String?> token();
  Stream<String> get onTokenRefresh;
  Stream<PushMessage> get onForeground;

  /// A message the person tapped while the app was running or in the background.
  Stream<PushMessage> get onOpened;

  /// The message that started the app from nothing, if any.
  Future<PushMessage?> initialMessage();
}

PushMessage _convert(RemoteMessage m) => PushMessage(
      title: m.notification?.title,
      body: m.notification?.body,
      data: m.data.map((k, v) => MapEntry(k, '$v')),
    );

class FirebasePushPlatform implements PushPlatform {
  const FirebasePushPlatform();

  FirebaseMessaging get _fm => FirebaseMessaging.instance;

  @override
  Future<bool> requestPermission() async {
    final settings = await _fm.requestPermission();
    // Foreground messages should still show, not be swallowed.
    await _fm.setForegroundNotificationPresentationOptions(alert: false, badge: true, sound: true);
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  @override
  @override
  Future<bool> notificationsEnabled() async {
    final s = await _fm.getNotificationSettings();
    return s.authorizationStatus == AuthorizationStatus.authorized || s.authorizationStatus == AuthorizationStatus.provisional;
  }

  @override
  // The classic FCM token is what the backend's FCM v1 sender expects. The newer
  // register()/onRegistered pair returns an installation id instead.
  // ignore: deprecated_member_use
  Future<String?> token() => _fm.getToken();

  @override
  // ignore: deprecated_member_use
  Stream<String> get onTokenRefresh => _fm.onTokenRefresh;

  @override
  Stream<PushMessage> get onForeground => FirebaseMessaging.onMessage.map(_convert);

  @override
  Stream<PushMessage> get onOpened => FirebaseMessaging.onMessageOpenedApp.map(_convert);

  @override
  Future<PushMessage?> initialMessage() async {
    final m = await _fm.getInitialMessage();
    return m == null ? null : _convert(m);
  }
}

/// Starts Firebase if this build has its config. Without it (no plist) the app
/// runs without push rather than failing.
Future<bool> initFirebase() async {
  try {
    await Firebase.initializeApp();
    return true;
  } catch (_) {
    return false;
  }
}

/// Where a tapped push should take the driver, from its `data`.
String? pushRoute(Map<String, String> data) {
  switch (data['type']) {
    case 'ride_offer' || 'ride_assigned' || 'ride_reassigned' || 'ride_cancelled_driver' || 'quick_message':
      return '/home';
    case 'support_reply':
      final ticket = data['ticketId'];
      return ticket == null ? '/support' : '/support/$ticket';
    case 'incident_ack':
      return '/home';
    case 'document_expiring' || 'announcement':
      return '/me';
  }
  return null;
}

final pushPlatformProvider = Provider<PushPlatform?>((_) => null);

/// Registers this phone for push while signed in and removes it on sign-out.
class PushRegistrar {
  PushRegistrar(this.ref);

  final Ref ref;
  StreamSubscription<String>? _refresh;
  bool _registered = false;
  String? _deviceId;

  bool get isRegistered => _registered;

  PushPlatform? get _platform => ref.read(pushPlatformProvider);

  /// Asks permission, then tells the server this phone's token. Quiet if the
  /// person declines or push is not available.
  Future<void> register({required String platformName}) async {
    final platform = _platform;
    if (platform == null) return;
    try {
      if (!await platform.requestPermission()) return;
      final token = await platform.token();
      if (token == null) return;
      // Marked first: even if the send fails, sign-out should still try to
      // remove this phone from the server.
      _registered = true;
      _refresh ??= platform.onTokenRefresh.listen((t) => _send(t, platformName));
      await _send(token, platformName);
    } catch (_) {
      // Push is a convenience; the app works by polling without it.
    }
  }

  Future<void> _send(String token, String platformName) async {
    final String deviceId = _deviceId ?? await ref.read(deviceIdProvider.future);
    _deviceId = deviceId;
    final version = await ref.read(appVersionProvider.future);
    await ref.read(clientProvider).api.getAuthApi().registerDevice(
          deviceRegistration: DeviceRegistration(
            deviceId: deviceId,
            fcmToken: token,
            platform: switch (platformName) {
              'android' => DeviceRegistrationPlatformEnum.android,
              'web' => DeviceRegistrationPlatformEnum.web,
              _ => DeviceRegistrationPlatformEnum.ios,
            },
            appVersion: version,
          ),
        );
  }

  /// Call before the session is cleared, while the token still works.
  Future<void> unregister() async {
    if (!_registered) return;
    _registered = false;
    // Read what is needed before any await: this runs during sign-out.
    final deviceId = _deviceId;
    final api = ref.read(clientProvider).api.getAuthApi();
    final sub = _refresh;
    _refresh = null;
    try {
      await sub?.cancel();
      if (deviceId != null) await api.unregisterDevice(deviceId: deviceId);
    } catch (_) {}
  }
}

final pushRegistrarProvider = Provider<PushRegistrar>(PushRegistrar.new);
