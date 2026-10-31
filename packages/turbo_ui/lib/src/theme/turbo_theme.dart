import 'package:flutter/material.dart';

import '../brand/brand_tokens.dart';

/// Semantic colour roles. Components read these, never raw colours.
@immutable
class TurboColors {
  const TurboColors(this.palette);

  final BrandPalette palette;

  Color get background => palette.background;
  Color get surface => palette.surface;
  Color get surfaceRaised => palette.surfaceRaised;
  Color get border => palette.border;
  Color get controlBorder => palette.controlBorder;
  Color get textPrimary => palette.textPrimary;
  Color get textSecondary => palette.textSecondary;
  Color get accent => palette.accent;
  Color get onAccent => palette.onAccent;
  Color get accentText => palette.accentText;
  Color get accentBorder => palette.accentBorder;
  Color get focusRing => palette.focusRing;
  Color get success => palette.success;
  Color get warning => palette.warning;
  Color get danger => palette.danger;

  /// Text and icons on a danger fill.
  Color get onDanger => palette.background;
}

/// The theme extension every component reads through `context.turbo`.
@immutable
class TurboTheme extends ThemeExtension<TurboTheme> {
  const TurboTheme({required this.brand, required this.colors});

  final BrandTokens brand;
  final TurboColors colors;

  double get radiusCard => brand.radiusCard;
  double get radiusInput => brand.radiusInput;
  double get radiusFull => brand.radiusFull;

  @override
  TurboTheme copyWith({BrandTokens? brand, TurboColors? colors}) =>
      TurboTheme(brand: brand ?? this.brand, colors: colors ?? this.colors);

  /// Brand tokens are not interpolated; the new theme wins at the midpoint.
  @override
  TurboTheme lerp(ThemeExtension<TurboTheme>? other, double t) =>
      other is TurboTheme && t >= 0.5 ? other : this;
}

extension TurboThemeContext on BuildContext {
  TurboTheme get turbo => Theme.of(this).extension<TurboTheme>()!;
}

/// Builds the light or dark [ThemeData] for [brand].
ThemeData buildTurboTheme(BrandTokens brand, Brightness brightness) {
  final palette = brightness == Brightness.dark ? brand.dark : brand.light;
  final colors = TurboColors(palette);
  final scale = brand.typeScale;

  TextStyle style(double size, FontWeight weight, Color color) => TextStyle(
        fontFamily: brand.fontFamily,
        fontSize: size,
        fontWeight: weight,
        height: size >= scale.title ? 1.3 : 1.45,
        color: color,
      );

  final textTheme = TextTheme(
    headlineMedium: style(scale.display, FontWeight.w600, colors.textPrimary),
    titleLarge: style(scale.title, FontWeight.w600, colors.textPrimary),
    bodyLarge: style(scale.bodyLarge, FontWeight.w400, colors.textPrimary),
    bodyMedium: style(scale.body, FontWeight.w400, colors.textPrimary),
    bodySmall: style(scale.caption, FontWeight.w400, colors.textSecondary),
    labelLarge: style(scale.bodyLarge, FontWeight.w600, colors.textPrimary),
    labelMedium: style(scale.body, FontWeight.w600, colors.textPrimary),
    labelSmall: style(scale.caption, FontWeight.w600, colors.textSecondary),
  );

  final scheme = ColorScheme(
    brightness: brightness,
    primary: colors.accent,
    onPrimary: colors.onAccent,
    secondary: colors.accentText,
    onSecondary: colors.background,
    error: colors.danger,
    onError: colors.onDanger,
    surface: colors.surface,
    onSurface: colors.textPrimary,
    outline: colors.controlBorder,
    outlineVariant: colors.border,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: colors.background,
    canvasColor: colors.background,
    dividerColor: colors.border,
    fontFamily: brand.fontFamily,
    textTheme: textTheme,
    splashFactory: NoSplash.splashFactory,
    appBarTheme: AppBarTheme(
      backgroundColor: colors.background,
      foregroundColor: colors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: textTheme.titleLarge,
    ),
    dividerTheme: DividerThemeData(color: colors.border, space: 1, thickness: 1),
    extensions: [TurboTheme(brand: brand, colors: colors)],
  );
}
