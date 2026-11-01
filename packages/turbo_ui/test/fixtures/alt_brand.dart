import 'package:flutter/painting.dart';
import 'package:turbo_ui/turbo_ui.dart';

/// A deliberately different brand: other name, colours, radius and font. If the
/// apps restyle from this with no widget change, a rebrand is a one-file edit.
const _ink = Color(0xFF102A43);
const _coral = Color(0xFFFF5A36);

const altBrand = BrandTokens(
  appName: 'Zippa',
  wordmark: 'Zippa',
  brandBlack: _ink,
  brandNeon: _coral,
  fontFamily: 'Georgia',
  radiusCard: 4,
  radiusInput: 2,
  radiusFull: 6,
  dark: BrandPalette(
    background: Color(0xFF0B1B2B),
    surface: Color(0xFF12283D),
    surfaceRaised: Color(0xFF193552),
    border: Color(0xFF2B4A6B),
    controlBorder: Color(0xFF8FA9C4),
    textPrimary: Color(0xFFF2F6FA),
    textSecondary: Color(0xFFB4C4D6),
    accent: _coral,
    onAccent: Color(0xFF0B1B2B),
    accentText: Color(0xFFFF8566),
    accentBorder: Color(0x00000000),
    focusRing: Color(0xFFFF8566),
    success: Color(0xFF5BD9A0),
    warning: Color(0xFFFFB84D),
    danger: Color(0xFFFF7A70),
    fill: Color(0xFF244563),
    sos: Color(0xFFFF5A4A),
    successTint: Color(0x245BD9A0),
    warningTint: Color(0x24FFB84D),
    dangerTint: Color(0x29FF7A70),
  ),
  light: BrandPalette(
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFEEF3F8),
    surfaceRaised: Color(0xFFFFFFFF),
    border: Color(0xFFC9D6E3),
    controlBorder: Color(0xFF5E7A96),
    textPrimary: _ink,
    textSecondary: Color(0xFF486581),
    accent: _coral,
    onAccent: _ink,
    accentText: Color(0xFFB3300F),
    accentBorder: _ink,
    focusRing: _ink,
    success: Color(0xFF117A59),
    warning: Color(0xFFB54708),
    danger: Color(0xFFCF2A1E),
    fill: Color(0xFFDCE6F0),
    sos: Color(0xFFC62828),
    successTint: Color(0x1F117A59),
    warningTint: Color(0x1FB54708),
    dangerTint: Color(0x1FCF2A1E),
  ),
);
