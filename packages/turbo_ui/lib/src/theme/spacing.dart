/// Spacing unit 4. Use these, not numbers, in screens and components.
abstract final class TurboSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  /// Side padding of every screen in the design (390 pt wide phones).
  static const double screen = 22;

  /// The gap between stacked controls and cards on a screen: 10 to 16 in the design.
  static const double gap = 10;
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

  /// Every button in the design is 60 tall; the driver's main actions are 80.
  static const double buttonHeight = 60;
  static const double driverButtonHeight = 80;
  static const double textButtonHeight = 46;
  static const double iconButton = 54;
  static const double chipHeight = 50;
  static const double smallChipHeight = 34;
  static const double tagHeight = 26;
  static const double fieldHeight = 62;

  /// One tab in the bottom bar: a 56 pt circle.
  static const double navItem = 56;
  static const double avatar = 54;
  static const double avatarSmall = 44;
  static const double pinBoxWidth = 68;
  static const double pinBoxHeight = 80;
  static const double sheetHandleWidth = 46;
  static const double sheetHandleHeight = 4;

  /// The big picture on sign-in and system screens.
  static const double heroIcon = 88;

  /// Height of one label and one big number, for a bar pinned above a list.
  static const double pinnedBar = 56;
}
