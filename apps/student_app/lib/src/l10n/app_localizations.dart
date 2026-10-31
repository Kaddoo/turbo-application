import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Some things may be out of date.'**
  String get offlineBanner;

  /// No description provided for @bootErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t start up'**
  String get bootErrorTitle;

  /// No description provided for @bootErrorBody.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get bootErrorBody;

  /// No description provided for @updateRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Please update the app'**
  String get updateRequiredTitle;

  /// No description provided for @updateRequiredBody.
  ///
  /// In en, this message translates to:
  /// **'This version of {appName} is too old to keep working. Update it from the store to carry on.'**
  String updateRequiredBody(Object appName);

  /// No description provided for @maintenanceTitle.
  ///
  /// In en, this message translates to:
  /// **'We\'re doing some maintenance'**
  String get maintenanceTitle;

  /// No description provided for @maintenanceBody.
  ///
  /// In en, this message translates to:
  /// **'{appName} is paused for a short while. Please try again soon.'**
  String maintenanceBody(Object appName);

  /// No description provided for @maintenanceCheckAgain.
  ///
  /// In en, this message translates to:
  /// **'Check again'**
  String get maintenanceCheckAgain;

  /// No description provided for @welcomeTagline.
  ///
  /// In en, this message translates to:
  /// **'Campus rides, paid from your wallet'**
  String get welcomeTagline;

  /// No description provided for @welcomeAudience.
  ///
  /// In en, this message translates to:
  /// **'For Central University students at Miotso'**
  String get welcomeAudience;

  /// No description provided for @phoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Your phone number'**
  String get phoneTitle;

  /// No description provided for @phoneFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneFieldLabel;

  /// No description provided for @phoneHelper.
  ///
  /// In en, this message translates to:
  /// **'We\'ll text you a 6-digit code'**
  String get phoneHelper;

  /// No description provided for @phoneSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get phoneSendCode;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter your 9-digit number, for example 24 123 4567.'**
  String get phoneInvalid;

  /// No description provided for @codeTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your code'**
  String get codeTitle;

  /// No description provided for @codeSentTo.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to {phone}.'**
  String codeSentTo(Object phone);

  /// No description provided for @codeVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get codeVerify;

  /// No description provided for @codeResend.
  ///
  /// In en, this message translates to:
  /// **'Send a new code'**
  String get codeResend;

  /// No description provided for @codeResendIn.
  ///
  /// In en, this message translates to:
  /// **'Send a new code in {seconds} s'**
  String codeResendIn(Object seconds);

  /// No description provided for @codeWrongNumber.
  ///
  /// In en, this message translates to:
  /// **'Wrong number?'**
  String get codeWrongNumber;

  /// No description provided for @termsTitle.
  ///
  /// In en, this message translates to:
  /// **'Before you start'**
  String get termsTitle;

  /// No description provided for @termsAgree.
  ///
  /// In en, this message translates to:
  /// **'I agree'**
  String get termsAgree;

  /// No description provided for @termsBulletRules.
  ///
  /// In en, this message translates to:
  /// **'{appName} is for verified Central University students. You pay from a wallet, and fares are fixed before you book.'**
  String termsBulletRules(Object appName);

  /// No description provided for @termsBulletData.
  ///
  /// In en, this message translates to:
  /// **'We keep your ride records and your verification documents only as long as we need to. Documents are deleted after review.'**
  String get termsBulletData;

  /// No description provided for @termsWhyLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Why we need your location'**
  String get termsWhyLocationTitle;

  /// No description provided for @termsWhyLocation.
  ///
  /// In en, this message translates to:
  /// **'To show your pickup point on the map and help your driver find you. We only use it while the app is open.'**
  String get termsWhyLocation;

  /// No description provided for @termsWhyCameraTitle.
  ///
  /// In en, this message translates to:
  /// **'Why we need your camera'**
  String get termsWhyCameraTitle;

  /// No description provided for @termsWhyCamera.
  ///
  /// In en, this message translates to:
  /// **'To take photos of your Ghana Card and student ID once, so we can confirm you are a student.'**
  String get termsWhyCamera;

  /// No description provided for @termsReadTerms.
  ///
  /// In en, this message translates to:
  /// **'Read the full terms'**
  String get termsReadTerms;

  /// No description provided for @termsReadPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Read the privacy notice'**
  String get termsReadPrivacy;

  /// No description provided for @termsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load the terms. Check your connection and try again.'**
  String get termsLoadFailed;

  /// No description provided for @problemGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get problemGeneric;

  /// No description provided for @problemNetwork.
  ///
  /// In en, this message translates to:
  /// **'No connection. Check your internet and try again.'**
  String get problemNetwork;

  /// No description provided for @problemRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many tries. Please wait a moment and try again.'**
  String get problemRateLimited;

  /// No description provided for @problemRateLimitedWait.
  ///
  /// In en, this message translates to:
  /// **'Too many tries. Please wait {seconds} s and try again.'**
  String problemRateLimitedWait(Object seconds);

  /// No description provided for @problemOtpInvalid.
  ///
  /// In en, this message translates to:
  /// **'That code isn\'t right. Check it and try again.'**
  String get problemOtpInvalid;

  /// No description provided for @problemOtpExpired.
  ///
  /// In en, this message translates to:
  /// **'That code has expired. Ask for a new one.'**
  String get problemOtpExpired;

  /// No description provided for @problemOtpRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many codes asked for. Please wait before asking again.'**
  String get problemOtpRateLimited;

  /// No description provided for @problemSmsBudget.
  ///
  /// In en, this message translates to:
  /// **'We can\'t send codes right now. Try again soon.'**
  String get problemSmsBudget;

  /// No description provided for @problemAccountSuspended.
  ///
  /// In en, this message translates to:
  /// **'This account is suspended. Contact support for help.'**
  String get problemAccountSuspended;

  /// No description provided for @problemUpgradeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please update the app to carry on.'**
  String get problemUpgradeRequired;

  /// No description provided for @problemDuplicateIdentity.
  ///
  /// In en, this message translates to:
  /// **'This Ghana Card is already linked to another account. Contact support.'**
  String get problemDuplicateIdentity;

  /// No description provided for @problemVerificationRequired.
  ///
  /// In en, this message translates to:
  /// **'Your student check isn\'t finished yet.'**
  String get problemVerificationRequired;

  /// No description provided for @problemVerificationNotResubmittable.
  ///
  /// In en, this message translates to:
  /// **'Your documents can\'t be sent again right now.'**
  String get problemVerificationNotResubmittable;

  /// No description provided for @problemUploadExpired.
  ///
  /// In en, this message translates to:
  /// **'That upload took too long. Please try the photo again.'**
  String get problemUploadExpired;

  /// No description provided for @problemValidation.
  ///
  /// In en, this message translates to:
  /// **'Some details aren\'t right. Check them and try again.'**
  String get problemValidation;

  /// No description provided for @problemNoDrivers.
  ///
  /// In en, this message translates to:
  /// **'No drivers are available right now. Try again soon.'**
  String get problemNoDrivers;

  /// No description provided for @problemOutsideArea.
  ///
  /// In en, this message translates to:
  /// **'That place is outside the area we cover.'**
  String get problemOutsideArea;

  /// No description provided for @problemRouteTooLong.
  ///
  /// In en, this message translates to:
  /// **'This trip is over {km} km, which is the longest we do.'**
  String problemRouteTooLong(Object km);

  /// No description provided for @problemRouteUnavailable.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find a route between those places.'**
  String get problemRouteUnavailable;

  /// No description provided for @problemBookingsPaused.
  ///
  /// In en, this message translates to:
  /// **'Booking is paused for now. Please try again later.'**
  String get problemBookingsPaused;

  /// No description provided for @problemAccountOwes.
  ///
  /// In en, this message translates to:
  /// **'You owe money on your wallet. Top up to book again.'**
  String get problemAccountOwes;

  /// No description provided for @problemActiveRide.
  ///
  /// In en, this message translates to:
  /// **'You already have a ride in progress.'**
  String get problemActiveRide;

  /// No description provided for @problemQuoteExpired.
  ///
  /// In en, this message translates to:
  /// **'That price has expired. We\'ll get you a new one.'**
  String get problemQuoteExpired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
