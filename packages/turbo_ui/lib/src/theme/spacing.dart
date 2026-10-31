/// Spacing unit 4. Use these, not numbers, in screens and components.
abstract final class TurboSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

/// Sizes that come from accessibility rules rather than the brand.
abstract final class TurboSizes {
  /// Minimum tap target in logical pixels.
  static const double minTap = 44;

  /// Primary actions in the driver app and other glanceable screens.
  static const double primaryAction = 56;
  static const double accentBorderWidth = 1.5;
  static const double focusRingWidth = 2;
  static const double iconSm = 20;
  static const double iconMd = 24;
  static const double iconLg = 40;
}
