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

  /// No description provided for @verifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm you\'re a student'**
  String get verifyTitle;

  /// No description provided for @verifyIntro.
  ///
  /// In en, this message translates to:
  /// **'You only do this once. It takes about two minutes and you\'ll need your Ghana Card and student ID.'**
  String get verifyIntro;

  /// No description provided for @verifyPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Only our verification team sees these. They are deleted after review.'**
  String get verifyPrivacyNote;

  /// No description provided for @verifyFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name as on your Ghana Card'**
  String get verifyFullName;

  /// No description provided for @verifyGhanaCard.
  ///
  /// In en, this message translates to:
  /// **'Ghana Card number'**
  String get verifyGhanaCard;

  /// No description provided for @verifyGhanaCardHelper.
  ///
  /// In en, this message translates to:
  /// **'Looks like GHA-123456789-0'**
  String get verifyGhanaCardHelper;

  /// No description provided for @verifyGhanaCardInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter the number as shown on the card, like GHA-123456789-0.'**
  String get verifyGhanaCardInvalid;

  /// No description provided for @verifyStudentId.
  ///
  /// In en, this message translates to:
  /// **'Student ID number'**
  String get verifyStudentId;

  /// No description provided for @verifyFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This is needed.'**
  String get verifyFieldRequired;

  /// No description provided for @verifyPhotosTitle.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get verifyPhotosTitle;

  /// No description provided for @verifySubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get verifySubmit;

  /// No description provided for @verifySubmitting.
  ///
  /// In en, this message translates to:
  /// **'Sending'**
  String get verifySubmitting;

  /// No description provided for @verifyDetailsKept.
  ///
  /// In en, this message translates to:
  /// **'We keep what you\'ve typed if you close the app.'**
  String get verifyDetailsKept;

  /// No description provided for @docGhanaCardFront.
  ///
  /// In en, this message translates to:
  /// **'Ghana Card, front'**
  String get docGhanaCardFront;

  /// No description provided for @docGhanaCardBack.
  ///
  /// In en, this message translates to:
  /// **'Ghana Card, back'**
  String get docGhanaCardBack;

  /// No description provided for @docStudentId.
  ///
  /// In en, this message translates to:
  /// **'Student ID'**
  String get docStudentId;

  /// No description provided for @docSelfie.
  ///
  /// In en, this message translates to:
  /// **'Selfie holding your Ghana Card'**
  String get docSelfie;

  /// No description provided for @docTake.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get docTake;

  /// No description provided for @docRetake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get docRetake;

  /// No description provided for @docUploading.
  ///
  /// In en, this message translates to:
  /// **'Sending {percent}%'**
  String docUploading(Object percent);

  /// No description provided for @docUploaded.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get docUploaded;

  /// No description provided for @docNotTaken.
  ///
  /// In en, this message translates to:
  /// **'Not taken yet'**
  String get docNotTaken;

  /// No description provided for @docFailed.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t send'**
  String get docFailed;

  /// No description provided for @docRetry.
  ///
  /// In en, this message translates to:
  /// **'Try sending again'**
  String get docRetry;

  /// No description provided for @captureGuideCard.
  ///
  /// In en, this message translates to:
  /// **'Fit the card inside the frame, flat and in good light.'**
  String get captureGuideCard;

  /// No description provided for @captureGuideSelfie.
  ///
  /// In en, this message translates to:
  /// **'Hold your Ghana Card next to your face and look at the camera.'**
  String get captureGuideSelfie;

  /// No description provided for @captureShutter.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get captureShutter;

  /// No description provided for @captureUsePhoto.
  ///
  /// In en, this message translates to:
  /// **'Use this photo'**
  String get captureUsePhoto;

  /// No description provided for @captureCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get captureCancel;

  /// No description provided for @captureIssueBlurry.
  ///
  /// In en, this message translates to:
  /// **'This looks blurry. Hold still and try again.'**
  String get captureIssueBlurry;

  /// No description provided for @captureIssueGlare.
  ///
  /// In en, this message translates to:
  /// **'There is glare on the photo. Tilt the card away from the light.'**
  String get captureIssueGlare;

  /// No description provided for @captureIssueDark.
  ///
  /// In en, this message translates to:
  /// **'It\'s too dark. Move to a brighter place.'**
  String get captureIssueDark;

  /// No description provided for @captureIssueUnreadable.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t read that photo. Please take it again.'**
  String get captureIssueUnreadable;

  /// No description provided for @captureLooksGood.
  ///
  /// In en, this message translates to:
  /// **'This looks clear.'**
  String get captureLooksGood;

  /// No description provided for @captureCameraDenied.
  ///
  /// In en, this message translates to:
  /// **'{appName} needs the camera to photograph your documents. Turn it on in Settings.'**
  String captureCameraDenied(Object appName);

  /// No description provided for @captureOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get captureOpenSettings;

  /// No description provided for @captureCameraFailed.
  ///
  /// In en, this message translates to:
  /// **'The camera didn\'t start. Close other apps that use it and try again.'**
  String get captureCameraFailed;

  /// No description provided for @verifyDuplicate.
  ///
  /// In en, this message translates to:
  /// **'This Ghana Card is already linked to another account. Contact support.'**
  String get verifyDuplicate;

  /// No description provided for @verifyResubmitNote.
  ///
  /// In en, this message translates to:
  /// **'Some documents were no longer valid. Please photograph them again.'**
  String get verifyResubmitNote;

  /// No description provided for @statusPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'We\'re checking your documents'**
  String get statusPendingTitle;

  /// No description provided for @statusPendingBody.
  ///
  /// In en, this message translates to:
  /// **'This usually takes a day. We\'ll text you.'**
  String get statusPendingBody;

  /// No description provided for @statusNeedsAttentionTitle.
  ///
  /// In en, this message translates to:
  /// **'We need a little more'**
  String get statusNeedsAttentionTitle;

  /// No description provided for @statusNeedsAttentionFallback.
  ///
  /// In en, this message translates to:
  /// **'Some of your documents couldn\'t be read. Please send them again.'**
  String get statusNeedsAttentionFallback;

  /// No description provided for @statusResubmit.
  ///
  /// In en, this message translates to:
  /// **'Send again'**
  String get statusResubmit;

  /// No description provided for @statusRejectedTitle.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t confirm you'**
  String get statusRejectedTitle;

  /// No description provided for @statusRejectedFallback.
  ///
  /// In en, this message translates to:
  /// **'Your documents didn\'t meet our checks.'**
  String get statusRejectedFallback;

  /// No description provided for @statusRejectedContact.
  ///
  /// In en, this message translates to:
  /// **'Contact support if you think this is a mistake.'**
  String get statusRejectedContact;

  /// No description provided for @statusApprovedTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re verified'**
  String get statusApprovedTitle;

  /// No description provided for @statusApprovedBody.
  ///
  /// In en, this message translates to:
  /// **'You can now book rides.'**
  String get statusApprovedBody;

  /// No description provided for @statusRefreshFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t check just now. Pull down to try again.'**
  String get statusRefreshFailed;

  /// No description provided for @statusSubmittedAt.
  ///
  /// In en, this message translates to:
  /// **'Sent {date}'**
  String statusSubmittedAt(Object date);

  /// No description provided for @homeWhereTo.
  ///
  /// In en, this message translates to:
  /// **'Where to?'**
  String get homeWhereTo;

  /// No description provided for @homeWalletChip.
  ///
  /// In en, this message translates to:
  /// **'Wallet {amount}'**
  String homeWalletChip(Object amount);

  /// No description provided for @homeWalletLow.
  ///
  /// In en, this message translates to:
  /// **'Wallet {amount}, low'**
  String homeWalletLow(Object amount);

  /// No description provided for @homeSavedPlaces.
  ///
  /// In en, this message translates to:
  /// **'Saved places'**
  String get homeSavedPlaces;

  /// No description provided for @homeOfflineMap.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. The map and prices may be out of date.'**
  String get homeOfflineMap;

  /// No description provided for @homeBookingsPaused.
  ///
  /// In en, this message translates to:
  /// **'Booking is paused for now.'**
  String get homeBookingsPaused;

  /// No description provided for @homeLocationDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Location is off'**
  String get homeLocationDeniedTitle;

  /// No description provided for @homeLocationDeniedBody.
  ///
  /// In en, this message translates to:
  /// **'{appName} uses your location to find the nearest pickup point. You can also choose a pickup point from the list.'**
  String homeLocationDeniedBody(Object appName);

  /// No description provided for @homeAllowLocation.
  ///
  /// In en, this message translates to:
  /// **'Allow location'**
  String get homeAllowLocation;

  /// No description provided for @homeChoosePickup.
  ///
  /// In en, this message translates to:
  /// **'Choose a pickup point'**
  String get homeChoosePickup;

  /// No description provided for @homeLocationServicesOff.
  ///
  /// In en, this message translates to:
  /// **'Switch on location in your phone\'s settings to find the nearest pickup point.'**
  String get homeLocationServicesOff;

  /// No description provided for @homeLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load the map details. Check your connection and try again.'**
  String get homeLoadFailed;

  /// No description provided for @destTitle.
  ///
  /// In en, this message translates to:
  /// **'Where to?'**
  String get destTitle;

  /// No description provided for @destPickupLabel.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get destPickupLabel;

  /// No description provided for @destPickupCurrent.
  ///
  /// In en, this message translates to:
  /// **'Nearest pickup point'**
  String get destPickupCurrent;

  /// No description provided for @destPickupChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose a pickup point'**
  String get destPickupChoose;

  /// No description provided for @destPickupNone.
  ///
  /// In en, this message translates to:
  /// **'Using your location'**
  String get destPickupNone;

  /// No description provided for @destSearchLabel.
  ///
  /// In en, this message translates to:
  /// **'Search for a place'**
  String get destSearchLabel;

  /// No description provided for @destSearchUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Place search isn\'t available in this version. Pick a saved place instead.'**
  String get destSearchUnavailable;

  /// No description provided for @destSearchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No places found. Try different words.'**
  String get destSearchNoResults;

  /// No description provided for @destSearchFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t search just now. Try again.'**
  String get destSearchFailed;

  /// No description provided for @destSavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved places'**
  String get destSavedTitle;

  /// No description provided for @destSavedEmpty.
  ///
  /// In en, this message translates to:
  /// **'You have no saved places yet.'**
  String get destSavedEmpty;

  /// No description provided for @destContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get destContinue;

  /// No description provided for @destNeedPickup.
  ///
  /// In en, this message translates to:
  /// **'Choose where we pick you up first.'**
  String get destNeedPickup;

  /// No description provided for @quoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Your ride'**
  String get quoteTitle;

  /// No description provided for @quoteFixed.
  ///
  /// In en, this message translates to:
  /// **'Fixed. It won\'t change.'**
  String get quoteFixed;

  /// No description provided for @quoteRoute.
  ///
  /// In en, this message translates to:
  /// **'{km} km · about {minutes} min'**
  String quoteRoute(String km, int minutes);

  /// No description provided for @quotePickupEta.
  ///
  /// In en, this message translates to:
  /// **'Driver reaches you in about {minutes} min'**
  String quotePickupEta(Object minutes);

  /// No description provided for @quoteWalletLine.
  ///
  /// In en, this message translates to:
  /// **'Wallet {balance}, {after} after this ride'**
  String quoteWalletLine(String balance, String after);

  /// No description provided for @quoteCancelRule.
  ///
  /// In en, this message translates to:
  /// **'Cancel for free until you\'re in the car.'**
  String get quoteCancelRule;

  /// No description provided for @quoteBook.
  ///
  /// In en, this message translates to:
  /// **'Book for {fare}'**
  String quoteBook(Object fare);

  /// No description provided for @quoteTopUp.
  ///
  /// In en, this message translates to:
  /// **'Top up {amount}'**
  String quoteTopUp(Object amount);

  /// No description provided for @quoteShortfall.
  ///
  /// In en, this message translates to:
  /// **'Your wallet is short by {amount}.'**
  String quoteShortfall(Object amount);

  /// No description provided for @quoteBookingSoon.
  ///
  /// In en, this message translates to:
  /// **'Booking opens in the next update.'**
  String get quoteBookingSoon;

  /// No description provided for @quoteIneligibleTitle.
  ///
  /// In en, this message translates to:
  /// **'We can\'t book this trip'**
  String get quoteIneligibleTitle;

  /// No description provided for @quoteChangeLocation.
  ///
  /// In en, this message translates to:
  /// **'Change location'**
  String get quoteChangeLocation;

  /// No description provided for @quoteExpired.
  ///
  /// In en, this message translates to:
  /// **'That price expired, so we got you a new one.'**
  String get quoteExpired;

  /// No description provided for @quoteLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t get a price. Check your connection and try again.'**
  String get quoteLoadFailed;

  /// No description provided for @quoteGettingPrice.
  ///
  /// In en, this message translates to:
  /// **'Getting your price'**
  String get quoteGettingPrice;
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
