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
}

/// Type sizes in logical pixels: display, title, body large, body, caption.
class BrandTypeScale {
  const BrandTypeScale({
    this.display = 28,
    this.title = 22,
    this.bodyLarge = 17,
    this.body = 15,
    this.caption = 13,
  });

  final double display;
  final double title;
  final double bodyLarge;
  final double body;
  final double caption;
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
    this.typeScale = const BrandTypeScale(),
    this.radiusCard = 20,
    this.radiusInput = 14,
    this.radiusFull = 999,
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
  final BrandTypeScale typeScale;
  final double radiusCard;
  final double radiusInput;
  final double radiusFull;

  /// Null until Turbo supplies them. Never invent contact details.
  final String? supportEmail;
  final String? supportPhone;
}

const _black = Color(0xFF0B0B09);
const _neon = Color(0xFFD5FF3B);

/// Black-and-neon brand, with values read from the design boards.
const turboBrand = BrandTokens(
  appName: 'Turbo',
  wordmark: 'Turbo',
  brandBlack: _black,
  brandNeon: _neon,
  dark: BrandPalette(
    background: _black,
    surface: Color(0xFF141611),
    surfaceRaised: Color(0xFF1D1F19),
    border: Color(0xFF2A2D25),
    controlBorder: Color(0xFF8A8C84),
    textPrimary: Color(0xFFF5F5F5),
    textSecondary: Color(0xFFA8A8A8),
    accent: _neon,
    onAccent: _black,
    accentText: _neon,
    accentBorder: Color(0x00000000),
    focusRing: _neon,
    success: Color(0xFF4CC38A),
    warning: Color(0xFFF5A524),
    danger: Color(0xFFFF7A6B),
  ),
  light: BrandPalette(
    background: Color(0xFFEFEDE6),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFFFFFFF),
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
  ),
);
