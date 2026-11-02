import 'package:flutter/services.dart';
import 'package:turbo_ui/turbo_ui.dart';

/// What the driver feels and hears for each event, one buzz per action.
/// Call sites say what happened. The system haptic and silent-mode settings
/// are honoured by the platform, and no sound ever loops.
abstract final class DriverFeedback {
  /// A new ride is offered: buzz and the alert sound.
  static void offered() {
    TurboHaptics.warning();
    SystemSound.play(SystemSoundType.alert);
  }

  /// Ten seconds left to accept: one short sound, no buzz.
  static void offerExpiring() => SystemSound.play(SystemSoundType.alert);

  static void accepted() => TurboHaptics.warning();

  static void arrived() => TurboHaptics.success();

  /// The PIN was right: a soft click and a light buzz.
  static void pinAccepted() {
    TurboHaptics.success();
    SystemSound.play(SystemSoundType.click);
  }

  static void pinWrong() => TurboHaptics.error();

  /// Once, at the end of the trip.
  static void tripCompleted() => TurboHaptics.error();

  static void wentOffline() => TurboHaptics.warning();
}
