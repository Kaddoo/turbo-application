import 'package:flutter/services.dart';

/// What happened, in the words of the haptic grammar. Components play these; a screen rarely needs to.
///
/// - [selection]: a chip, a segment or a choice changed.
/// - [success]: something went through and the person is waiting for it (a top-up landed, the driver arrived).
/// - [confirm]: a deliberate commitment (slide to continue, Book).
/// - [completed]: the ride is over. Once.
enum TurboHapticKind { selection, success, confirm, completed }

/// Call sites say what happened, not which vibration to use. The system's own haptic setting still applies.
/// Never play one on scroll, and only once per action.
abstract final class TurboHaptics {
  static Future<void> selection() => HapticFeedback.selectionClick();
  static Future<void> success() => HapticFeedback.lightImpact();
  static Future<void> warning() => HapticFeedback.mediumImpact();
  static Future<void> error() => HapticFeedback.heavyImpact();
  static Future<void> confirm() => HapticFeedback.mediumImpact();
  static Future<void> completed() => HapticFeedback.heavyImpact();

  static Future<void> play(TurboHapticKind kind) => switch (kind) {
    TurboHapticKind.selection => selection(),
    TurboHapticKind.success => success(),
    TurboHapticKind.confirm => confirm(),
    TurboHapticKind.completed => completed(),
  };
}
