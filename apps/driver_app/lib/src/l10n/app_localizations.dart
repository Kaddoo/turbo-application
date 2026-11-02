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

  /// No description provided for @problemServiceBusy.
  ///
  /// In en, this message translates to:
  /// **'We\'re busy right now. Try again in a moment.'**
  String get problemServiceBusy;

  /// No description provided for @problemServiceBusyWait.
  ///
  /// In en, this message translates to:
  /// **'We\'re busy right now. Try again in {seconds} seconds.'**
  String problemServiceBusyWait(int seconds);

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

  /// No description provided for @phoneTitleAccent.
  ///
  /// In en, this message translates to:
  /// **'phone number'**
  String get phoneTitleAccent;

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

  /// No description provided for @codeTitleAccent.
  ///
  /// In en, this message translates to:
  /// **'code'**
  String get codeTitleAccent;

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
  /// **'Drive for campus'**
  String get welcomeTagline;

  /// No description provided for @welcomeTaglineAccent.
  ///
  /// In en, this message translates to:
  /// **'campus'**
  String get welcomeTaglineAccent;

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

  /// No description provided for @homeYourVehicle.
  ///
  /// In en, this message translates to:
  /// **'Your vehicle'**
  String get homeYourVehicle;

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

  /// No description provided for @readinessReadyToGo.
  ///
  /// In en, this message translates to:
  /// **'Ready to go'**
  String get readinessReadyToGo;

  /// No description provided for @readinessTileLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get readinessTileLocation;

  /// No description provided for @readinessLocationAlways.
  ///
  /// In en, this message translates to:
  /// **'Always'**
  String get readinessLocationAlways;

  /// No description provided for @readinessLocationWhileUsing.
  ///
  /// In en, this message translates to:
  /// **'Only while using'**
  String get readinessLocationWhileUsing;

  /// No description provided for @readinessLocationOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get readinessLocationOff;

  /// No description provided for @readinessTileBattery.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get readinessTileBattery;

  /// No description provided for @readinessBatteryPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String readinessBatteryPercent(int percent);

  /// No description provided for @readinessTileNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get readinessTileNotifications;

  /// No description provided for @readinessTileInternet.
  ///
  /// In en, this message translates to:
  /// **'Internet'**
  String get readinessTileInternet;

  /// No description provided for @readinessOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get readinessOn;

  /// No description provided for @readinessOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get readinessOff;

  /// No description provided for @readinessConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get readinessConnected;

  /// No description provided for @readinessOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get readinessOffline;

  /// No description provided for @readinessTileDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get readinessTileDocuments;

  /// No description provided for @primingTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow location Always'**
  String get primingTitle;

  /// No description provided for @primingBody.
  ///
  /// In en, this message translates to:
  /// **'Rides reach you and students see you arrive even when the screen is locked. Sharing stops when you go off duty.'**
  String get primingBody;

  /// No description provided for @primingAskStep1.
  ///
  /// In en, this message translates to:
  /// **'Tap Continue'**
  String get primingAskStep1;

  /// No description provided for @primingAskStep2.
  ///
  /// In en, this message translates to:
  /// **'Choose Allow While Using App'**
  String get primingAskStep2;

  /// No description provided for @primingAskStep3.
  ///
  /// In en, this message translates to:
  /// **'When asked again, choose Change to Always Allow'**
  String get primingAskStep3;

  /// No description provided for @primingSettingsStep1.
  ///
  /// In en, this message translates to:
  /// **'Tap Open Settings, then Location'**
  String get primingSettingsStep1;

  /// No description provided for @primingSettingsStep2.
  ///
  /// In en, this message translates to:
  /// **'Choose Always'**
  String get primingSettingsStep2;

  /// No description provided for @primingSettingsStep3.
  ///
  /// In en, this message translates to:
  /// **'Come back to the app'**
  String get primingSettingsStep3;

  /// No description provided for @primingContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get primingContinue;

  /// No description provided for @primingNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get primingNotNow;

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

  /// No description provided for @navHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get navHelp;

  /// No description provided for @recordsTitle.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get recordsTitle;

  /// No description provided for @recordsTabTrips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get recordsTabTrips;

  /// No description provided for @recordsTabShifts.
  ///
  /// In en, this message translates to:
  /// **'Shifts'**
  String get recordsTabShifts;

  /// No description provided for @recordsTabHours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get recordsTabHours;

  /// No description provided for @recordsTabSalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get recordsTabSalary;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get helpTitle;

  /// No description provided for @helpReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Report an issue'**
  String get helpReportTitle;

  /// No description provided for @helpMyRequests.
  ///
  /// In en, this message translates to:
  /// **'My help requests'**
  String get helpMyRequests;

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

  /// No description provided for @assignTitle.
  ///
  /// In en, this message translates to:
  /// **'New ride'**
  String get assignTitle;

  /// No description provided for @assignAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get assignAccept;

  /// No description provided for @assignDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get assignDecline;

  /// No description provided for @assignSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds}'**
  String assignSeconds(int seconds);

  /// No description provided for @assignPickup.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get assignPickup;

  /// No description provided for @assignStudent.
  ///
  /// In en, this message translates to:
  /// **'Student: {name}'**
  String assignStudent(String name);

  /// No description provided for @assignTilePickup.
  ///
  /// In en, this message translates to:
  /// **'To pickup'**
  String get assignTilePickup;

  /// No description provided for @assignTileTrip.
  ///
  /// In en, this message translates to:
  /// **'Trip'**
  String get assignTileTrip;

  /// No description provided for @assignTileStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get assignTileStudent;

  /// No description provided for @assignTilePays.
  ///
  /// In en, this message translates to:
  /// **'Student pays'**
  String get assignTilePays;

  /// No description provided for @assignKm.
  ///
  /// In en, this message translates to:
  /// **'{km} km'**
  String assignKm(String km);

  /// No description provided for @assignEta.
  ///
  /// In en, this message translates to:
  /// **'about {minutes} min'**
  String assignEta(int minutes);

  /// No description provided for @assignPassed.
  ///
  /// In en, this message translates to:
  /// **'Ride passed to another driver'**
  String get assignPassed;

  /// No description provided for @assignPassedBody.
  ///
  /// In en, this message translates to:
  /// **'You\'re back in the queue. No action needed.'**
  String get assignPassedBody;

  /// No description provided for @declineTitle.
  ///
  /// In en, this message translates to:
  /// **'Why are you declining?'**
  String get declineTitle;

  /// No description provided for @declineVehicle.
  ///
  /// In en, this message translates to:
  /// **'Car problem'**
  String get declineVehicle;

  /// No description provided for @declineFar.
  ///
  /// In en, this message translates to:
  /// **'Too far'**
  String get declineFar;

  /// No description provided for @declineUnwell.
  ///
  /// In en, this message translates to:
  /// **'Unwell'**
  String get declineUnwell;

  /// No description provided for @declineOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get declineOther;

  /// No description provided for @pickupTitle.
  ///
  /// In en, this message translates to:
  /// **'Go to the pickup'**
  String get pickupTitle;

  /// No description provided for @pickupNavigate.
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get pickupNavigate;

  /// No description provided for @pickupArrived.
  ///
  /// In en, this message translates to:
  /// **'I\'ve arrived'**
  String get pickupArrived;

  /// No description provided for @pickupFarTitle.
  ///
  /// In en, this message translates to:
  /// **'You look far from the pickup'**
  String get pickupFarTitle;

  /// No description provided for @pickupFarBody.
  ///
  /// In en, this message translates to:
  /// **'Mark as arrived anyway?'**
  String get pickupFarBody;

  /// No description provided for @pickupFarConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, I\'ve arrived'**
  String get pickupFarConfirm;

  /// No description provided for @pickupMessages.
  ///
  /// In en, this message translates to:
  /// **'Quick messages'**
  String get pickupMessages;

  /// No description provided for @navigateGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google Maps'**
  String get navigateGoogle;

  /// No description provided for @navigateWaze.
  ///
  /// In en, this message translates to:
  /// **'Waze'**
  String get navigateWaze;

  /// No description provided for @navigateFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t open a maps app.'**
  String get navigateFailed;

  /// No description provided for @waitingTitle.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the student'**
  String get waitingTitle;

  /// No description provided for @waitingTimer.
  ///
  /// In en, this message translates to:
  /// **'Waiting {time}'**
  String waitingTimer(String time);

  /// No description provided for @waitingStart.
  ///
  /// In en, this message translates to:
  /// **'Start trip'**
  String get waitingStart;

  /// No description provided for @waitingNotHere.
  ///
  /// In en, this message translates to:
  /// **'Student not here'**
  String get waitingNotHere;

  /// No description provided for @waitingNotHereConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Mark the student as not here?'**
  String get waitingNotHereConfirmTitle;

  /// No description provided for @waitingNotHereConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The ride will be cancelled. The student isn\'t charged and no fee applies.'**
  String get waitingNotHereConfirmBody;

  /// No description provided for @waitingNotHereConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, not here'**
  String get waitingNotHereConfirm;

  /// No description provided for @waitingNotHereAt.
  ///
  /// In en, this message translates to:
  /// **'You can mark the student as not here at {time}.'**
  String waitingNotHereAt(String time);

  /// No description provided for @pinTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the student\'s PIN'**
  String get pinTitle;

  /// No description provided for @pinHint.
  ///
  /// In en, this message translates to:
  /// **'Ask the student for their PIN. Never accept it by message.'**
  String get pinHint;

  /// No description provided for @pinStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get pinStart;

  /// No description provided for @pinDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get pinDelete;

  /// No description provided for @pinLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Too many tries'**
  String get pinLockedTitle;

  /// No description provided for @pinLockedBody.
  ///
  /// In en, this message translates to:
  /// **'Call your supervisor.'**
  String get pinLockedBody;

  /// No description provided for @tripTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip in progress'**
  String get tripTitle;

  /// No description provided for @tripNavigate.
  ///
  /// In en, this message translates to:
  /// **'Navigate to drop-off'**
  String get tripNavigate;

  /// No description provided for @tripDropoff.
  ///
  /// In en, this message translates to:
  /// **'Drop-off: {name}'**
  String tripDropoff(String name);

  /// No description provided for @tripElapsed.
  ///
  /// In en, this message translates to:
  /// **'On the trip for {time}'**
  String tripElapsed(String time);

  /// No description provided for @tripComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete trip'**
  String get tripComplete;

  /// No description provided for @tripCompleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete the trip?'**
  String get tripCompleteConfirmTitle;

  /// No description provided for @tripCompleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Only do this at the drop-off.'**
  String get tripCompleteConfirmBody;

  /// No description provided for @tripCompleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, complete'**
  String get tripCompleteConfirm;

  /// No description provided for @tripWaitingSignal.
  ///
  /// In en, this message translates to:
  /// **'Waiting for signal to finish your trip'**
  String get tripWaitingSignal;

  /// No description provided for @tripWaitingSignalBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ll keep trying. You don\'t need to do anything.'**
  String get tripWaitingSignalBody;

  /// No description provided for @tripReport.
  ///
  /// In en, this message translates to:
  /// **'Report a problem'**
  String get tripReport;

  /// No description provided for @doneTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip complete'**
  String get doneTitle;

  /// No description provided for @doneDetails.
  ///
  /// In en, this message translates to:
  /// **'{km} km · {minutes} min'**
  String doneDetails(String km, int minutes);

  /// No description provided for @doneBack.
  ///
  /// In en, this message translates to:
  /// **'Back to waiting'**
  String get doneBack;

  /// No description provided for @cancelledTitle.
  ///
  /// In en, this message translates to:
  /// **'Ride cancelled'**
  String get cancelledTitle;

  /// No description provided for @cancelledByStudent.
  ///
  /// In en, this message translates to:
  /// **'The student cancelled the ride.'**
  String get cancelledByStudent;

  /// No description provided for @cancelledByStaff.
  ///
  /// In en, this message translates to:
  /// **'The office cancelled the ride.'**
  String get cancelledByStaff;

  /// No description provided for @cancelledBySystem.
  ///
  /// In en, this message translates to:
  /// **'The ride was cancelled.'**
  String get cancelledBySystem;

  /// No description provided for @cancelledBody.
  ///
  /// In en, this message translates to:
  /// **'Return to your waiting position.'**
  String get cancelledBody;

  /// No description provided for @cancelledNoShow.
  ///
  /// In en, this message translates to:
  /// **'The student wasn\'t there. No fee applies.'**
  String get cancelledNoShow;

  /// No description provided for @rideMessageFailed.
  ///
  /// In en, this message translates to:
  /// **'That message didn\'t send. Try again.'**
  String get rideMessageFailed;

  /// No description provided for @rideLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your ride. Check your connection and try again.'**
  String get rideLoadFailed;

  /// No description provided for @rideActionFailed.
  ///
  /// In en, this message translates to:
  /// **'That didn\'t go through. Try again.'**
  String get rideActionFailed;

  /// No description provided for @qmRunningLate.
  ///
  /// In en, this message translates to:
  /// **'Running late'**
  String get qmRunningLate;

  /// No description provided for @qmImHere.
  ///
  /// In en, this message translates to:
  /// **'I\'m here'**
  String get qmImHere;

  /// No description provided for @qmAtTheGate.
  ///
  /// In en, this message translates to:
  /// **'At the gate'**
  String get qmAtTheGate;

  /// No description provided for @qmCannotFindYou.
  ///
  /// In en, this message translates to:
  /// **'I can\'t find you'**
  String get qmCannotFindYou;

  /// No description provided for @qmOnMyWay.
  ///
  /// In en, this message translates to:
  /// **'On my way'**
  String get qmOnMyWay;

  /// No description provided for @qmPleaseComeOut.
  ///
  /// In en, this message translates to:
  /// **'Please come out'**
  String get qmPleaseComeOut;

  /// No description provided for @sosHold.
  ///
  /// In en, this message translates to:
  /// **'Hold for SOS'**
  String get sosHold;

  /// No description provided for @sosHoldSeconds.
  ///
  /// In en, this message translates to:
  /// **'Hold for 3 seconds'**
  String get sosHoldSeconds;

  /// No description provided for @sosSecondsLeft.
  ///
  /// In en, this message translates to:
  /// **'{seconds} seconds'**
  String sosSecondsLeft(int seconds);

  /// No description provided for @sosAlerted.
  ///
  /// In en, this message translates to:
  /// **'Help has been alerted'**
  String get sosAlerted;

  /// No description provided for @sosAlertedBody.
  ///
  /// In en, this message translates to:
  /// **'Staff at {appName} can see your location and will call you. Stay where it is safe.'**
  String sosAlertedBody(String appName);

  /// No description provided for @sosFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t send the alert'**
  String get sosFailed;

  /// No description provided for @sosFailedBody.
  ///
  /// In en, this message translates to:
  /// **'Call the emergency number now.'**
  String get sosFailedBody;

  /// No description provided for @sosCall.
  ///
  /// In en, this message translates to:
  /// **'Call {number}'**
  String sosCall(String number);

  /// No description provided for @sosNoLocation.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find your location. Call the emergency number now.'**
  String get sosNoLocation;

  /// No description provided for @sosDismiss.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get sosDismiss;

  /// No description provided for @shiftsTitle.
  ///
  /// In en, this message translates to:
  /// **'Shifts'**
  String get shiftsTitle;

  /// No description provided for @shiftsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No shifts scheduled. Your supervisor sets these.'**
  String get shiftsEmpty;

  /// No description provided for @shiftUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get shiftUpcoming;

  /// No description provided for @shiftPast.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get shiftPast;

  /// No description provided for @shiftScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get shiftScheduled;

  /// No description provided for @shiftInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get shiftInProgress;

  /// No description provided for @shiftCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get shiftCompleted;

  /// No description provided for @shiftMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get shiftMissed;

  /// No description provided for @attendanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendanceTitle;

  /// No description provided for @attendanceEmpty.
  ///
  /// In en, this message translates to:
  /// **'No attendance records yet. Your hours show up here once you have been on duty.'**
  String get attendanceEmpty;

  /// No description provided for @hoursWeekLabel.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get hoursWeekLabel;

  /// No description provided for @hoursWeekTotal.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String hoursWeekTotal(int hours, int minutes);

  /// No description provided for @attendanceIn.
  ///
  /// In en, this message translates to:
  /// **'In {time}'**
  String attendanceIn(String time);

  /// No description provided for @attendanceOut.
  ///
  /// In en, this message translates to:
  /// **'Out {time}'**
  String attendanceOut(String time);

  /// No description provided for @attendanceMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min worked'**
  String attendanceMinutes(int minutes);

  /// No description provided for @attendanceCorrected.
  ///
  /// In en, this message translates to:
  /// **'Corrected by staff: {note}'**
  String attendanceCorrected(String note);

  /// No description provided for @attendanceWrong.
  ///
  /// In en, this message translates to:
  /// **'Think something is wrong?'**
  String get attendanceWrong;

  /// No description provided for @attendanceOnTime.
  ///
  /// In en, this message translates to:
  /// **'On time'**
  String get attendanceOnTime;

  /// No description provided for @attendanceLate.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get attendanceLate;

  /// No description provided for @attendanceAbsent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get attendanceAbsent;

  /// No description provided for @attendanceCorrectedChip.
  ///
  /// In en, this message translates to:
  /// **'Corrected'**
  String get attendanceCorrectedChip;

  /// No description provided for @salaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Salary history'**
  String get salaryTitle;

  /// No description provided for @salaryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No payments recorded yet. Your pay history shows up here.'**
  String get salaryEmpty;

  /// No description provided for @salaryYearLabel.
  ///
  /// In en, this message translates to:
  /// **'Paid in {year}'**
  String salaryYearLabel(int year);

  /// No description provided for @salaryNote.
  ///
  /// In en, this message translates to:
  /// **'This is a record. Payment is made by your employer outside the app.'**
  String get salaryNote;

  /// No description provided for @salaryPeriod.
  ///
  /// In en, this message translates to:
  /// **'{from} to {to}'**
  String salaryPeriod(String from, String to);

  /// No description provided for @salaryPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid {date}'**
  String salaryPaid(String date);

  /// No description provided for @salaryReference.
  ///
  /// In en, this message translates to:
  /// **'Reference {ref}'**
  String salaryReference(String ref);

  /// No description provided for @supportTitle.
  ///
  /// In en, this message translates to:
  /// **'Help and support'**
  String get supportTitle;

  /// No description provided for @supportNew.
  ///
  /// In en, this message translates to:
  /// **'Report an issue'**
  String get supportNew;

  /// No description provided for @supportMine.
  ///
  /// In en, this message translates to:
  /// **'My tickets'**
  String get supportMine;

  /// No description provided for @supportEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tickets yet. If something goes wrong, tell us here.'**
  String get supportEmpty;

  /// No description provided for @supportLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your tickets. Check your connection and try again.'**
  String get supportLoadFailed;

  /// No description provided for @supportAbout.
  ///
  /// In en, this message translates to:
  /// **'What is it about?'**
  String get supportAbout;

  /// No description provided for @catVehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get catVehicle;

  /// No description provided for @catStudent.
  ///
  /// In en, this message translates to:
  /// **'Student behaviour'**
  String get catStudent;

  /// No description provided for @catApp.
  ///
  /// In en, this message translates to:
  /// **'App problem'**
  String get catApp;

  /// No description provided for @catSafety.
  ///
  /// In en, this message translates to:
  /// **'Safety'**
  String get catSafety;

  /// No description provided for @catOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get catOther;

  /// No description provided for @supportSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get supportSubject;

  /// No description provided for @supportMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get supportMessage;

  /// No description provided for @supportSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get supportSend;

  /// No description provided for @supportSent.
  ///
  /// In en, this message translates to:
  /// **'Sent. We\'ll reply here.'**
  String get supportSent;

  /// No description provided for @supportNeedFields.
  ///
  /// In en, this message translates to:
  /// **'Choose a topic and write a short message.'**
  String get supportNeedFields;

  /// No description provided for @supportReplyHint.
  ///
  /// In en, this message translates to:
  /// **'Write a reply'**
  String get supportReplyHint;

  /// No description provided for @supportReply.
  ///
  /// In en, this message translates to:
  /// **'Send reply'**
  String get supportReply;

  /// No description provided for @supportFromStaff.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportFromStaff;

  /// No description provided for @supportFromYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get supportFromYou;

  /// No description provided for @supportReplyFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t send that. Try again.'**
  String get supportReplyFailed;

  /// No description provided for @supportStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get supportStatusOpen;

  /// No description provided for @supportStatusProgress.
  ///
  /// In en, this message translates to:
  /// **'Being looked at'**
  String get supportStatusProgress;

  /// No description provided for @supportStatusWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for you'**
  String get supportStatusWaiting;

  /// No description provided for @supportStatusResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get supportStatusResolved;

  /// No description provided for @supportStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get supportStatusClosed;

  /// No description provided for @supportCallSupervisor.
  ///
  /// In en, this message translates to:
  /// **'Supervisor'**
  String get supportCallSupervisor;
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
