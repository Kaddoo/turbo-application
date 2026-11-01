import 'package:flutter/painting.dart';

/// THE ONLY FILE WITH RAW VALUES. A rebrand edits this file and the assets.
///
/// Everything else reads semantic roles from the theme built from these tokens.

/// The role values for one brightness. Names match the role table in
/// `prompts/00-shared-rules.md`.
class BrandPalette {
  const BrandPalette({
    required this.background,
    required this.surface,
    required this.surfaceRaised,
    required this.border,
    required this.controlBorder,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
    required this.onAccent,
    required this.accentText,
    required this.accentBorder,
    required this.focusRing,
    required this.success,
    required this.warning,
    required this.danger,
    required this.fill,
    required this.sos,
    required this.successTint,
    required this.warningTint,
    required this.dangerTint,
  });

  final Color background;
  final Color surface;
  final Color surfaceRaised;

  /// Dividers and card edges.
  final Color border;

  /// Edges of inputs and secondary buttons. Must reach 3:1 against the
  /// background, which `border` deliberately does not.
  final Color controlBorder;
  final Color textPrimary;
  final Color textSecondary;

  /// The single main action per screen. Fill only.
  final Color accent;
  final Color onAccent;

  /// Accent used as text, icon or link.
  final Color accentText;

  /// Edge drawn round an accent fill. Visible on light backgrounds only.
  final Color accentBorder;
  final Color focusRing;
  final Color success;
  final Color warning;
  final Color danger;

  /// Tracks, progress rails and pressed fills: one step above `surfaceRaised`.
  final Color fill;

  /// Emergency fill (SOS buttons and badges). Never the accent, never `danger`.
  final Color sos;

  /// Soft fills behind status banners and tags.
  final Color successTint;
  final Color warningTint;
  final Color dangerTint;
}

/// Type sizes in logical pixels, one per role in `design/Turbo-type-scale.csv`.
/// Text roles use the brand font; the `mono*` roles use the mono font.
class BrandTypeScale {
  const BrandTypeScale({
    this.splash = 76,
    this.moneyHero = 50,
    this.driverTitle = 42,
    this.heroTitle = 38,
    this.h1 = 34,
    this.wordmark = 26,
    this.h2 = 21,
    this.driverButton = 22,
    this.emphasis = 20,
    this.section = 19,
    this.button = 17,
    this.lead = 17,
    this.bodyBold = 16,
    this.input = 16,
    this.bodyStrong = 15,
    this.chip = 15,
    this.body = 15,
    this.tab = 14,
    this.fieldLabel = 13,
    this.small = 13,
    this.tag = 12,
    this.caption = 12,
    this.monoTimer = 84,
    this.monoPin = 42,
    this.monoCountdown = 36,
    this.monoKeypad = 28,
    this.monoCode = 26,
    this.monoPlate = 26,
    this.monoMoneyLarge = 24,
    this.monoMoneyRow = 15,
    this.monoPhone = 15,
    this.monoLink = 13,
    this.monoCardName = 12,
  });

  final double splash;
  final double moneyHero;
  final double driverTitle;
  final double heroTitle;
  final double h1;
  final double wordmark;
  final double h2;
  final double driverButton;
  final double emphasis;
  final double section;
  final double button;
  final double lead;
  final double bodyBold;
  final double input;
  final double bodyStrong;
  final double chip;
  final double body;
  final double tab;
  final double fieldLabel;
  final double small;
  final double tag;
  final double caption;
  final double monoTimer;
  final double monoPin;
  final double monoCountdown;
  final double monoKeypad;
  final double monoCode;
  final double monoPlate;
  final double monoMoneyLarge;
  final double monoMoneyRow;
  final double monoPhone;
  final double monoLink;
  final double monoCardName;
}

class BrandTokens {
  const BrandTokens({
    required this.appName,
    required this.wordmark,
    required this.brandBlack,
    required this.brandNeon,
    required this.dark,
    required this.light,
    this.logoAsset,
    this.iconAsset,
    this.fontFamily,
    this.monoFontFamily,
    this.fontPackage,
    this.typeScale = const BrandTypeScale(),
    this.radiusCard = 30,
    this.radiusInput = 20,
    this.radiusFull = 999,
    this.radiusSheet = 36,
    this.radiusPanel = 34,
    this.radiusTile = 28,
    this.radiusListCard = 26,
    this.radiusInner = 22,
    this.radiusCode = 18,
    this.supportEmail,
    this.supportPhone,
  });

  final String appName;

  /// Text placeholder shown where a logo will go.
  final String wordmark;
  final Color brandBlack;
  final Color brandNeon;
  final BrandPalette dark;
  final BrandPalette light;
  final String? logoAsset;
  final String? iconAsset;

  /// Null means the platform system font.
  final String? fontFamily;

  /// For money, plates, PINs, codes and timers. Null falls back to the platform monospace.
  final String? monoFontFamily;

  /// The package that bundles the fonts, so a font declared there resolves from any app.
  final String? fontPackage;
  final BrandTypeScale typeScale;

  /// Cards.
  final double radiusCard;

  /// Text fields.
  final double radiusInput;

  /// Buttons, chips, tags and the bottom bar.
  final double radiusFull;

  /// Photo cards and bottom sheets.
  final double radiusSheet;

  /// The booking panel and map cards.
  final double radiusPanel;

  /// Bento tiles.
  final double radiusTile;

  /// List cards and upload boxes.
  final double radiusListCard;

  /// Banners, inner panels and the trip PIN.
  final double radiusInner;

  /// Code boxes.
  final double radiusCode;

  /// Null until Turbo supplies them. Never invent contact details.
  final String? supportEmail;
  final String? supportPhone;
}

const _black = Color(0xFF0B0B0A);
const _neon = Color(0xFFD4FF3A);

/// Black-and-neon brand, with values read from `design/Turbo-components.pdf` and `turbo-components.css`.
const turboBrand = BrandTokens(
  appName: 'Turbo',
  wordmark: 'Turbo',
  brandBlack: _black,
  brandNeon: _neon,
  fontFamily: 'Geist',
  monoFontFamily: 'Geist Mono',
  fontPackage: 'turbo_ui',
  dark: BrandPalette(
    background: _black,
    surface: Color(0xFF1A1B18),
    surfaceRaised: Color(0xFF252622),
    fill: Color(0xFF31322D),
    // rgba(255,255,255,.08): a hairline, not a control edge.
    border: Color(0x14FFFFFF),
    // The design draws control edges at 24% white, which is 2.1:1 on the page. Inputs must reach 3:1, so this stays lighter.
    controlBorder: Color(0xFF8A8C84),
    textPrimary: Color(0xFFF3F1EA),
    textSecondary: Color(0xFF9E9E96),
    accent: _neon,
    onAccent: Color(0xFF0B0C0A),
    accentText: _neon,
    accentBorder: Color(0x00000000),
    focusRing: _neon,
    success: Color(0xFF86E3A8),
    warning: Color(0xFFFFBF5C),
    danger: Color(0xFFFF7A6B),
    sos: Color(0xFFE5483A),
    successTint: Color(0x2486E3A8),
    warningTint: Color(0x24FFBF5C),
    dangerTint: Color(0x29FF7A6B),
  ),
  light: BrandPalette(
    background: Color(0xFFEFEDE6),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFF7F5EF),
    fill: Color(0xFFE4E1D8),
    border: Color(0xFFDAD7CE),
    controlBorder: Color(0xFF6E6C65),
    textPrimary: _black,
    textSecondary: Color(0xFF5A5A5A),
    accent: _neon,
    onAccent: _black,
    accentText: _black,
    accentBorder: _black,
    focusRing: _black,
    success: Color(0xFF117A59),
    warning: Color(0xFFB54708),
    danger: Color(0xFFB3301C),
    sos: Color(0xFFC63A2D),
    successTint: Color(0x1F117A59),
    warningTint: Color(0x1FB54708),
    dangerTint: Color(0x1FB3301C),
  ),
);
