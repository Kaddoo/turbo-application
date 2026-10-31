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

  /// No description provided for @problemTopupRange.
  ///
  /// In en, this message translates to:
  /// **'That amount isn\'t allowed. Choose a different amount.'**
  String get problemTopupRange;

  /// No description provided for @problemPaymentProvider.
  ///
  /// In en, this message translates to:
  /// **'The payment service isn\'t answering. Try again in a moment.'**
  String get problemPaymentProvider;

  /// No description provided for @problemInsufficient.
  ///
  /// In en, this message translates to:
  /// **'Your wallet doesn\'t have enough for this ride. Top up and try again.'**
  String get problemInsufficient;

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

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @welcomeTagline.
  ///
  /// In en, this message translates to:
  /// **'Drive for the campus, one ride at a time'**
  String get welcomeTagline;

  /// No description provided for @welcomeAudience.
  ///
  /// In en, this message translates to:
  /// **'For {appName} drivers'**
  String welcomeAudience(String appName);

  /// No description provided for @termsBulletRules.
  ///
  /// In en, this message translates to:
  /// **'{appName} assigns rides to you automatically. You accept or decline each one.'**
  String termsBulletRules(String appName);

  /// No description provided for @termsBulletData.
  ///
  /// In en, this message translates to:
  /// **'Your position is shared only while you are on duty. Your trips, shifts and attendance are recorded for payroll.'**
  String get termsBulletData;

  /// No description provided for @termsWhyLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Why we need your location all the time'**
  String get termsWhyLocationTitle;

  /// No description provided for @termsWhyLocation.
  ///
  /// In en, this message translates to:
  /// **'So rides can be assigned to the nearest driver and students can see you arrive, even when the screen is locked. Sharing stops when you go off duty.'**
  String get termsWhyLocation;

  /// No description provided for @problemNotADriver.
  ///
  /// In en, this message translates to:
  /// **'This number isn\'t registered as a driver. Contact your supervisor.'**
  String get problemNotADriver;

  /// No description provided for @problemDocumentExpired.
  ///
  /// In en, this message translates to:
  /// **'A document has expired. Contact your supervisor.'**
  String get problemDocumentExpired;

  /// No description provided for @problemHasActiveRide.
  ///
  /// In en, this message translates to:
  /// **'You can\'t go off duty during a ride.'**
  String get problemHasActiveRide;

  /// No description provided for @problemPinLocked.
  ///
  /// In en, this message translates to:
  /// **'Too many tries. Call your supervisor.'**
  String get problemPinLocked;

  /// No description provided for @problemInvalidPin.
  ///
  /// In en, this message translates to:
  /// **'That PIN isn\'t right. Ask the student again.'**
  String get problemInvalidPin;

  /// No description provided for @problemNoShowEarly.
  ///
  /// In en, this message translates to:
  /// **'It\'s too early to mark the student as not here.'**
  String get problemNoShowEarly;

  /// No description provided for @suspendedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your account is suspended'**
  String get suspendedTitle;

  /// No description provided for @suspendedBody.
  ///
  /// In en, this message translates to:
  /// **'Contact your supervisor to find out why.'**
  String get suspendedBody;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String homeGreeting(String name);

  /// No description provided for @homeVehicle.
  ///
  /// In en, this message translates to:
  /// **'{colour} {make} {model} · {plate}'**
  String homeVehicle(String colour, String make, String model, String plate);

  /// No description provided for @homeNoVehicle.
  ///
  /// In en, this message translates to:
  /// **'No vehicle assigned yet. Contact your supervisor.'**
  String get homeNoVehicle;

  /// No description provided for @homeOffDuty.
  ///
  /// In en, this message translates to:
  /// **'Off duty'**
  String get homeOffDuty;

  /// No description provided for @homeGoOnDuty.
  ///
  /// In en, this message translates to:
  /// **'Go on duty'**
  String get homeGoOnDuty;

  /// No description provided for @homeGoOffDuty.
  ///
  /// In en, this message translates to:
  /// **'Go off duty'**
  String get homeGoOffDuty;

  /// No description provided for @homeOnDutyWaiting.
  ///
  /// In en, this message translates to:
  /// **'On duty. Waiting for a ride.'**
  String get homeOnDutyWaiting;

  /// No description provided for @homeOnDutyFor.
  ///
  /// In en, this message translates to:
  /// **'On duty for {time}'**
  String homeOnDutyFor(String time);

  /// No description provided for @homeOffDutyConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Go off duty?'**
  String get homeOffDutyConfirmTitle;

  /// No description provided for @homeOffDutyConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'You won\'t get new rides until you go on duty again.'**
  String get homeOffDutyConfirmBody;

  /// No description provided for @homeOffDutyConfirm.
  ///
  /// In en, this message translates to:
  /// **'Go off duty'**
  String get homeOffDutyConfirm;

  /// No description provided for @homeStayOn.
  ///
  /// In en, this message translates to:
  /// **'Stay on duty'**
  String get homeStayOn;

  /// No description provided for @readinessTitle.
  ///
  /// In en, this message translates to:
  /// **'Before you go on duty'**
  String get readinessTitle;

  /// No description provided for @readinessLocation.
  ///
  /// In en, this message translates to:
  /// **'Location set to Always'**
  String get readinessLocation;

  /// No description provided for @readinessBattery.
  ///
  /// In en, this message translates to:
  /// **'Battery above 20% or charging'**
  String get readinessBattery;

  /// No description provided for @readinessInternet.
  ///
  /// In en, this message translates to:
  /// **'Internet connected'**
  String get readinessInternet;

  /// No description provided for @readinessNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications on'**
  String get readinessNotifications;

  /// No description provided for @readinessDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents checked when you go on duty'**
  String get readinessDocuments;

  /// No description provided for @readinessFix.
  ///
  /// In en, this message translates to:
  /// **'Fix'**
  String get readinessFix;

  /// No description provided for @readinessOk.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get readinessOk;

  /// No description provided for @readinessProblem.
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get readinessProblem;

  /// No description provided for @readinessLocationFix.
  ///
  /// In en, this message translates to:
  /// **'Allow location always'**
  String get readinessLocationFix;

  /// No description provided for @readinessOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get readinessOpenSettings;

  /// No description provided for @dutyFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t change your duty. Check your connection and try again.'**
  String get dutyFailed;

  /// No description provided for @bannerNotSharing.
  ///
  /// In en, this message translates to:
  /// **'Your location isn\'t being shared. Open the app.'**
  String get bannerNotSharing;

  /// No description provided for @bannerOffline.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. You won\'t get rides until you\'re back online.'**
  String get bannerOffline;

  /// No description provided for @bannerServer.
  ///
  /// In en, this message translates to:
  /// **'We can\'t reach the server. Your position is kept and will be sent.'**
  String get bannerServer;

  /// No description provided for @indicatorGps.
  ///
  /// In en, this message translates to:
  /// **'GPS'**
  String get indicatorGps;

  /// No description provided for @indicatorConnection.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get indicatorConnection;

  /// No description provided for @indicatorBattery.
  ///
  /// In en, this message translates to:
  /// **'Battery {percent}%'**
  String indicatorBattery(int percent);

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'{appName}'**
  String notificationTitle(String appName);

  /// No description provided for @notificationText.
  ///
  /// In en, this message translates to:
  /// **'{appName} is sharing your location while you are on duty.'**
  String notificationText(String appName);

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navTrips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get navTrips;

  /// No description provided for @navMe.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get navMe;

  /// No description provided for @shareStopped.
  ///
  /// In en, this message translates to:
  /// **'Location sharing stopped'**
  String get shareStopped;

  /// No description provided for @tripsTitle.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get tripsTitle;

  /// No description provided for @tripsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No trips yet.'**
  String get tripsEmpty;

  /// No description provided for @tripsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your trips. Check your connection and try again.'**
  String get tripsLoadFailed;

  /// No description provided for @rideStatusSearching.
  ///
  /// In en, this message translates to:
  /// **'Finding a driver'**
  String get rideStatusSearching;

  /// No description provided for @rideStatusAssigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get rideStatusAssigned;

  /// No description provided for @rideStatusArrived.
  ///
  /// In en, this message translates to:
  /// **'Arrived'**
  String get rideStatusArrived;

  /// No description provided for @rideStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get rideStatusInProgress;

  /// No description provided for @rideStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get rideStatusCompleted;

  /// No description provided for @rideStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get rideStatusCancelled;

  /// No description provided for @meTitle.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get meTitle;

  /// No description provided for @meVehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get meVehicle;

  /// No description provided for @meSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get meSignOut;

  /// No description provided for @meVersion.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get meVersion;

  /// No description provided for @meTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get meTerms;

  /// No description provided for @mePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy notice'**
  String get mePrivacy;

  /// No description provided for @meDevices.
  ///
  /// In en, this message translates to:
  /// **'Signed-in devices'**
  String get meDevices;

  /// No description provided for @meThisDevice.
  ///
  /// In en, this message translates to:
  /// **'This phone'**
  String get meThisDevice;

  /// No description provided for @meSignOutDevice.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get meSignOutDevice;

  /// No description provided for @meSignOutOthers.
  ///
  /// In en, this message translates to:
  /// **'Sign out everywhere else'**
  String get meSignOutOthers;

  /// No description provided for @meLastUsed.
  ///
  /// In en, this message translates to:
  /// **'Last used {when}'**
  String meLastUsed(String when);

  /// No description provided for @meLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load this. Check your connection and try again.'**
  String get meLoadFailed;

  /// No description provided for @meShifts.
  ///
  /// In en, this message translates to:
  /// **'Shifts'**
  String get meShifts;

  /// No description provided for @meAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get meAttendance;

  /// No description provided for @meSalary.
  ///
  /// In en, this message translates to:
  /// **'Salary history'**
  String get meSalary;

  /// No description provided for @meHelp.
  ///
  /// In en, this message translates to:
  /// **'Help and support'**
  String get meHelp;
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
