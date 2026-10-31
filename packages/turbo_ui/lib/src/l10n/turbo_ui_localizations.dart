import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'turbo_ui_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of TurboUiLocalizations
/// returned by `TurboUiLocalizations.of(context)`.
///
/// Applications need to include `TurboUiLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/turbo_ui_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: TurboUiLocalizations.localizationsDelegates,
///   supportedLocales: TurboUiLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the TurboUiLocalizations.supportedLocales
/// property.
abstract class TurboUiLocalizations {
  TurboUiLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static TurboUiLocalizations of(BuildContext context) {
    return Localizations.of<TurboUiLocalizations>(
      context,
      TurboUiLocalizations,
    )!;
  }

  static const LocalizationsDelegate<TurboUiLocalizations> delegate =
      _TurboUiLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @paste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get paste;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @errorDefault.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Check your connection and try again.'**
  String get errorDefault;

  /// No description provided for @otpDigit.
  ///
  /// In en, this message translates to:
  /// **'Digit {position} of {total}'**
  String otpDigit(int position, int total);

  /// No description provided for @mapUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The map isn\'t available right now.'**
  String get mapUnavailable;

  /// No description provided for @typeToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Type {phrase} to confirm'**
  String typeToConfirm(String phrase);

  /// No description provided for @timelineDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get timelineDone;

  /// No description provided for @timelineCurrent.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get timelineCurrent;

  /// No description provided for @timelineUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Not yet'**
  String get timelineUpcoming;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated {time}'**
  String lastUpdated(String time);
}

class _TurboUiLocalizationsDelegate
    extends LocalizationsDelegate<TurboUiLocalizations> {
  const _TurboUiLocalizationsDelegate();

  @override
  Future<TurboUiLocalizations> load(Locale locale) {
    return SynchronousFuture<TurboUiLocalizations>(
      lookupTurboUiLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_TurboUiLocalizationsDelegate old) => false;
}

TurboUiLocalizations lookupTurboUiLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return TurboUiLocalizationsEn();
  }

  throw FlutterError(
    'TurboUiLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
