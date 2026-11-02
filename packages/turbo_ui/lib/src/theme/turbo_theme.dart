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
  Color get fill => palette.fill;
  Color get sos => palette.sos;
  Color get onSos => palette.onSos;
  Color get successTint => palette.successTint;
  Color get warningTint => palette.warningTint;
  Color get dangerTint => palette.dangerTint;

  /// Text and icons on a danger fill.
  Color get onDanger => palette.background;
}

/// Text roles that have no slot in Material's [TextTheme]: the wordmark, the driver's big
/// button, field labels, and every mono role (money, plates, PINs, codes, timers).
@immutable
class TurboType {
  const TurboType({
    required this.splash,
    required this.wordmark,
    required this.driverTitle,
    required this.driverButton,
    required this.emphasis,
    required this.fieldLabel,
    required this.input,
    required this.tab,
    required this.tag,
    required this.monoTimer,
    required this.monoPin,
    required this.monoCountdown,
    required this.monoKeypad,
    required this.monoCode,
    required this.monoPlate,
    required this.monoMoneyLarge,
    required this.monoMoneyRow,
    required this.monoPhone,
    required this.monoLink,
    required this.monoCardName,
  });

  final TextStyle splash, wordmark, driverTitle, driverButton, emphasis, fieldLabel, input, tab, tag;
  final TextStyle monoTimer, monoPin, monoCountdown, monoKeypad, monoCode, monoPlate;
  final TextStyle monoMoneyLarge, monoMoneyRow, monoPhone, monoLink, monoCardName;
}

/// The theme extension every component reads through `context.turbo`.
@immutable
class TurboTheme extends ThemeExtension<TurboTheme> {
  const TurboTheme({required this.brand, required this.colors, required this.styles});

  final BrandTokens brand;
  final TurboColors colors;
  /// Text roles beyond Material's [TextTheme]: `context.turbo.styles.monoPin`.
  final TurboType styles;

  double get radiusCard => brand.radiusCard;
  double get radiusInput => brand.radiusInput;
  double get radiusFull => brand.radiusFull;
  double get radiusSheet => brand.radiusSheet;
  double get radiusPanel => brand.radiusPanel;
  double get radiusTile => brand.radiusTile;
  double get radiusListCard => brand.radiusListCard;
  double get radiusInner => brand.radiusInner;
  double get radiusCode => brand.radiusCode;

  @override
  TurboTheme copyWith({BrandTokens? brand, TurboColors? colors, TurboType? styles}) =>
      TurboTheme(brand: brand ?? this.brand, colors: colors ?? this.colors, styles: styles ?? this.styles);

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

  // One style per role in design/Turbo-type-scale.csv. `spacing` is in em (the sheet writes -0.035em).
  TextStyle text(double size, FontWeight weight, {double height = 1.45, double spacing = 0, Color? color}) => TextStyle(
        fontFamily: brand.fontFamily,
        package: brand.fontFamily == null ? null : brand.fontPackage,
        fontSize: size,
        fontWeight: weight,
        height: height,
        letterSpacing: spacing * size,
        color: color ?? colors.textPrimary,
      );
  TextStyle mono(double size, FontWeight weight, {double height = 1.45, double spacing = -0.01, Color? color}) => TextStyle(
        fontFamily: brand.monoFontFamily ?? 'monospace',
        package: brand.monoFontFamily == null ? null : brand.fontPackage,
        fontSize: size,
        fontWeight: weight,
        height: height,
        letterSpacing: spacing * size,
        color: color ?? colors.textPrimary,
      );

  final textTheme = TextTheme(
    displayLarge: text(scale.moneyHero, FontWeight.w600, height: 1.0, spacing: -0.05),
    displayMedium: text(scale.driverTitle, FontWeight.w500, height: 1.08, spacing: -0.035),
    displaySmall: text(scale.heroTitle, FontWeight.w500, height: 1.08, spacing: -0.035),
    headlineMedium: text(scale.h1, FontWeight.w500, height: 1.08, spacing: -0.035),
    headlineSmall: text(scale.emphasis, FontWeight.w600),
    titleLarge: text(scale.h2, FontWeight.w500, height: 1.2, spacing: -0.02),
    titleMedium: text(scale.section, FontWeight.w500, spacing: -0.01),
    titleSmall: text(scale.bodyBold, FontWeight.w600),
    bodyLarge: text(scale.lead, FontWeight.w400),
    bodyMedium: text(scale.body, FontWeight.w400),
    bodySmall: text(scale.small, FontWeight.w400, color: colors.textSecondary),
    labelLarge: text(scale.button, FontWeight.w500, height: 1.2),
    labelMedium: text(scale.bodyStrong, FontWeight.w600),
    labelSmall: text(scale.caption, FontWeight.w600, color: colors.textSecondary),
  );

  final styles = TurboType(
    splash: text(scale.splash, FontWeight.w600, height: 1.0, spacing: -0.05),
    wordmark: text(scale.wordmark, FontWeight.w600, height: 1.0, spacing: -0.05),
    driverTitle: text(scale.driverTitle, FontWeight.w500, height: 1.08, spacing: -0.035),
    driverButton: text(scale.driverButton, FontWeight.w600, height: 1.2),
    emphasis: text(scale.emphasis, FontWeight.w600),
    fieldLabel: text(scale.fieldLabel, FontWeight.w500, color: colors.textSecondary),
    input: text(scale.input, FontWeight.w400, height: 1.2),
    tab: text(scale.tab, FontWeight.w500),
    tag: text(scale.tag, FontWeight.w600, height: 1.2),
    monoTimer: mono(scale.monoTimer, FontWeight.w600, height: 1.0, spacing: -0.04),
    monoPin: mono(scale.monoPin, FontWeight.w600, height: 1.2, spacing: 0),
    monoCountdown: mono(scale.monoCountdown, FontWeight.w600, height: 1.0),
    monoKeypad: mono(scale.monoKeypad, FontWeight.w500, height: 1.2, spacing: 0),
    monoCode: mono(scale.monoCode, FontWeight.w500, height: 1.2, spacing: 0),
    monoPlate: mono(scale.monoPlate, FontWeight.w600),
    monoMoneyLarge: mono(scale.monoMoneyLarge, FontWeight.w600),
    monoMoneyRow: mono(scale.monoMoneyRow, FontWeight.w600),
    monoPhone: mono(scale.monoPhone, FontWeight.w400),
    monoLink: mono(scale.monoLink, FontWeight.w400),
    monoCardName: mono(scale.monoCardName, FontWeight.w400),
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
    package: brand.fontFamily == null ? null : brand.fontPackage,
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
    // Plain text buttons use the readable accent: lime on a light page is unreadable.
    textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: colors.accentText)),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? colors.accent : colors.fill),
      thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? colors.onAccent : colors.textSecondary),
      trackOutlineColor: WidgetStatePropertyAll(colors.border),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? colors.accentText : colors.controlBorder),
    ),
    extensions: [TurboTheme(brand: brand, colors: colors, styles: styles)],
  );
}
