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

  /// No description provided for @suspendedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your account is suspended'**
  String get suspendedTitle;

  /// No description provided for @suspendedTag.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get suspendedTag;

  /// No description provided for @suspendedBody.
  ///
  /// In en, this message translates to:
  /// **'You can\'t book rides for now. Contact support to find out why and what happens next.'**
  String get suspendedBody;

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

  /// No description provided for @welcomeTaglineAccent.
  ///
  /// In en, this message translates to:
  /// **'wallet'**
  String get welcomeTaglineAccent;

  /// No description provided for @welcomeFixedFares.
  ///
  /// In en, this message translates to:
  /// **'Fixed fares'**
  String get welcomeFixedFares;

  /// No description provided for @welcomeContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get welcomeContinue;

  /// No description provided for @welcomeAudience.
  ///
  /// In en, this message translates to:
  /// **'For Central University students at Miotso'**
  String get welcomeAudience;

  /// No description provided for @phoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your phone'**
  String get phoneTitle;

  /// No description provided for @phoneTitleAccent.
  ///
  /// In en, this message translates to:
  /// **'phone'**
  String get phoneTitleAccent;

  /// No description provided for @phoneLead.
  ///
  /// In en, this message translates to:
  /// **'New or returning, it\'s the same step.'**
  String get phoneLead;

  /// No description provided for @phoneLegal.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to the terms and privacy notice.'**
  String get phoneLegal;

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

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'24 123 4567'**
  String get phoneHint;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter your 9-digit number, for example 24 123 4567.'**
  String get phoneInvalid;

  /// No description provided for @codeTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code'**
  String get codeTitle;

  /// No description provided for @codeTitleAccent.
  ///
  /// In en, this message translates to:
  /// **'code'**
  String get codeTitleAccent;

  /// No description provided for @codeSentTo.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to {phone}'**
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

  /// No description provided for @homeYourPickup.
  ///
  /// In en, this message translates to:
  /// **'Your pickup point'**
  String get homeYourPickup;

  /// No description provided for @homeBookRide.
  ///
  /// In en, this message translates to:
  /// **'Book a ride'**
  String get homeBookRide;

  /// No description provided for @homeTabNearest.
  ///
  /// In en, this message translates to:
  /// **'Nearest point'**
  String get homeTabNearest;

  /// No description provided for @homeTabChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose point'**
  String get homeTabChoose;

  /// No description provided for @homeTileClosest.
  ///
  /// In en, this message translates to:
  /// **'Closest to you'**
  String get homeTileClosest;

  /// No description provided for @homeAway.
  ///
  /// In en, this message translates to:
  /// **'{distance} away'**
  String homeAway(String distance);

  /// No description provided for @homeTileHours.
  ///
  /// In en, this message translates to:
  /// **'Ride hours'**
  String get homeTileHours;

  /// No description provided for @homeHoursClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed today'**
  String get homeHoursClosed;

  /// No description provided for @homeTileLast.
  ///
  /// In en, this message translates to:
  /// **'Last ride'**
  String get homeTileLast;

  /// No description provided for @homeSafetyLabel.
  ///
  /// In en, this message translates to:
  /// **'Safety'**
  String get homeSafetyLabel;

  /// No description provided for @homeSafetyTile.
  ///
  /// In en, this message translates to:
  /// **'SOS and trip sharing'**
  String get homeSafetyTile;

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

  /// No description provided for @homeHello.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String homeHello(String name);

  /// No description provided for @homeHelloNoName.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get homeHelloNoName;

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

  /// No description provided for @quoteFareLabel.
  ///
  /// In en, this message translates to:
  /// **'Fixed fare'**
  String get quoteFareLabel;

  /// No description provided for @quoteWontChange.
  ///
  /// In en, this message translates to:
  /// **'It won\'t change'**
  String get quoteWontChange;

  /// No description provided for @quoteTileWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get quoteTileWallet;

  /// No description provided for @quoteTileAfter.
  ///
  /// In en, this message translates to:
  /// **'After this ride'**
  String get quoteTileAfter;

  /// No description provided for @quoteTileShort.
  ///
  /// In en, this message translates to:
  /// **'Short by'**
  String get quoteTileShort;

  /// No description provided for @quoteTopUpHint.
  ///
  /// In en, this message translates to:
  /// **'Top up with mobile money, then book this ride.'**
  String get quoteTopUpHint;

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

  /// No description provided for @destPlacesTitle.
  ///
  /// In en, this message translates to:
  /// **'Campus and popular places'**
  String get destPlacesTitle;

  /// No description provided for @destPlacesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No places are set up yet.'**
  String get destPlacesEmpty;

  /// No description provided for @navRide.
  ///
  /// In en, this message translates to:
  /// **'Ride'**
  String get navRide;

  /// No description provided for @navWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get navWallet;

  /// No description provided for @navActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get navActivity;

  /// No description provided for @walletTitle.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get walletTitle;

  /// No description provided for @walletAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get walletAvailable;

  /// No description provided for @walletHeld.
  ///
  /// In en, this message translates to:
  /// **'{amount} held for your ride'**
  String walletHeld(Object amount);

  /// No description provided for @walletTileBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get walletTileBalance;

  /// No description provided for @walletTileHeld.
  ///
  /// In en, this message translates to:
  /// **'Held for your ride'**
  String get walletTileHeld;

  /// No description provided for @walletOwed.
  ///
  /// In en, this message translates to:
  /// **'You owe {amount}. Top up to book again.'**
  String walletOwed(Object amount);

  /// No description provided for @walletTopUp.
  ///
  /// In en, this message translates to:
  /// **'Top up'**
  String get walletTopUp;

  /// No description provided for @walletRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get walletRecent;

  /// No description provided for @walletSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get walletSeeAll;

  /// No description provided for @txToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get txToday;

  /// No description provided for @txYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get txYesterday;

  /// No description provided for @topupWaitLeft.
  ///
  /// In en, this message translates to:
  /// **'left to approve'**
  String get topupWaitLeft;

  /// No description provided for @walletNoTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet.'**
  String get walletNoTransactions;

  /// No description provided for @walletLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your wallet. Check your connection and try again.'**
  String get walletLoadFailed;

  /// No description provided for @transactionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactionsTitle;

  /// No description provided for @transactionsLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get transactionsLoadMore;

  /// No description provided for @txFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get txFilterAll;

  /// No description provided for @txFilterTopups.
  ///
  /// In en, this message translates to:
  /// **'Top-ups'**
  String get txFilterTopups;

  /// No description provided for @txFilterRides.
  ///
  /// In en, this message translates to:
  /// **'Rides'**
  String get txFilterRides;

  /// No description provided for @txFilterRefunds.
  ///
  /// In en, this message translates to:
  /// **'Refunds'**
  String get txFilterRefunds;

  /// No description provided for @txTopUp.
  ///
  /// In en, this message translates to:
  /// **'Top-up'**
  String get txTopUp;

  /// No description provided for @txHeld.
  ///
  /// In en, this message translates to:
  /// **'Held'**
  String get txHeld;

  /// No description provided for @txReleased.
  ///
  /// In en, this message translates to:
  /// **'Released'**
  String get txReleased;

  /// No description provided for @txRide.
  ///
  /// In en, this message translates to:
  /// **'Ride'**
  String get txRide;

  /// No description provided for @txRefund.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get txRefund;

  /// No description provided for @txAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Adjustment'**
  String get txAdjustment;

  /// No description provided for @txReversal.
  ///
  /// In en, this message translates to:
  /// **'Reversed'**
  String get txReversal;

  /// No description provided for @topupTitle.
  ///
  /// In en, this message translates to:
  /// **'Top up'**
  String get topupTitle;

  /// No description provided for @topupAmount.
  ///
  /// In en, this message translates to:
  /// **'Choose an amount'**
  String get topupAmount;

  /// No description provided for @topupCustom.
  ///
  /// In en, this message translates to:
  /// **'Other amount in cedis'**
  String get topupCustom;

  /// No description provided for @topupCustomHint.
  ///
  /// In en, this message translates to:
  /// **'Between {min} and {max}'**
  String topupCustomHint(String min, String max);

  /// No description provided for @topupPay.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount}'**
  String topupPay(Object amount);

  /// No description provided for @topupNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile money number'**
  String get topupNumberLabel;

  /// No description provided for @topupPhoneNote.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a payment prompt to {phone}.'**
  String topupPhoneNote(Object phone);

  /// No description provided for @topupPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'A top-up is still waiting'**
  String get topupPendingTitle;

  /// No description provided for @topupPendingBody.
  ///
  /// In en, this message translates to:
  /// **'You started a top-up that hasn\'t finished. If you start another, you could pay twice.'**
  String get topupPendingBody;

  /// No description provided for @topupPendingWait.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get topupPendingWait;

  /// No description provided for @topupPendingAnother.
  ///
  /// In en, this message translates to:
  /// **'Start another'**
  String get topupPendingAnother;

  /// No description provided for @topupWaitTitle.
  ///
  /// In en, this message translates to:
  /// **'Approve the payment on your phone'**
  String get topupWaitTitle;

  /// No description provided for @topupStep1.
  ///
  /// In en, this message translates to:
  /// **'A prompt appears on your phone.'**
  String get topupStep1;

  /// No description provided for @topupStep2.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile money PIN to approve.'**
  String get topupStep2;

  /// No description provided for @topupStep3.
  ///
  /// In en, this message translates to:
  /// **'Come back here. This updates by itself.'**
  String get topupStep3;

  /// No description provided for @topupWaitSeconds.
  ///
  /// In en, this message translates to:
  /// **'Checking for {seconds} more seconds'**
  String topupWaitSeconds(Object seconds);

  /// No description provided for @topupCheckStatus.
  ///
  /// In en, this message translates to:
  /// **'Check status'**
  String get topupCheckStatus;

  /// No description provided for @topupLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave this screen'**
  String get topupLeave;

  /// No description provided for @topupSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Top-up complete'**
  String get topupSuccessTitle;

  /// No description provided for @topupSuccessAdded.
  ///
  /// In en, this message translates to:
  /// **'{amount} was added to your wallet.'**
  String topupSuccessAdded(String amount);

  /// No description provided for @topupTileBalance.
  ///
  /// In en, this message translates to:
  /// **'New balance'**
  String get topupTileBalance;

  /// No description provided for @topupTileReference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get topupTileReference;

  /// No description provided for @topupPendingChip.
  ///
  /// In en, this message translates to:
  /// **'Pending · {amount}'**
  String topupPendingChip(String amount);

  /// No description provided for @topupWaitLeftAmount.
  ///
  /// In en, this message translates to:
  /// **'left to approve {amount}'**
  String topupWaitLeftAmount(String amount);

  /// No description provided for @topupNeverPin.
  ///
  /// In en, this message translates to:
  /// **'{appName} never asks for your PIN. Not by call, text or WhatsApp.'**
  String topupNeverPin(String appName);

  /// No description provided for @topupSuccessBody.
  ///
  /// In en, this message translates to:
  /// **'Your wallet now has {amount} available.'**
  String topupSuccessBody(Object amount);

  /// No description provided for @topupDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get topupDone;

  /// No description provided for @topupFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'The payment didn\'t go through'**
  String get topupFailedTitle;

  /// No description provided for @topupFailedBody.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t been charged. You can try again.'**
  String get topupFailedBody;

  /// No description provided for @topupSlowTitle.
  ///
  /// In en, this message translates to:
  /// **'Still waiting'**
  String get topupSlowTitle;

  /// No description provided for @topupSlowBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ll add the money when it arrives. You don\'t need to pay again.'**
  String get topupSlowBody;

  /// No description provided for @topupTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get topupTryAgain;

  /// No description provided for @topupAmountRange.
  ///
  /// In en, this message translates to:
  /// **'Choose an amount between {min} and {max}.'**
  String topupAmountRange(String min, String max);

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

  /// No description provided for @activityFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All rides'**
  String get activityFilterAll;

  /// No description provided for @activityTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activityTitle;

  /// No description provided for @activityThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get activityThisWeek;

  /// No description provided for @activityEarlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get activityEarlier;

  /// No description provided for @activityEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your rides will appear here.'**
  String get activityEmpty;

  /// No description provided for @activityLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your rides. Check your connection and try again.'**
  String get activityLoadFailed;

  /// No description provided for @rideStatusSearching.
  ///
  /// In en, this message translates to:
  /// **'Finding a driver'**
  String get rideStatusSearching;

  /// No description provided for @rideStatusAssigned.
  ///
  /// In en, this message translates to:
  /// **'Driver on the way'**
  String get rideStatusAssigned;

  /// No description provided for @rideStatusArrived.
  ///
  /// In en, this message translates to:
  /// **'Driver has arrived'**
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

  /// No description provided for @rideTileFareHeld.
  ///
  /// In en, this message translates to:
  /// **'Fare is held'**
  String get rideTileFareHeld;

  /// No description provided for @rideTileTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get rideTileTo;

  /// No description provided for @rideSearchingFrom.
  ///
  /// In en, this message translates to:
  /// **'Pickup: {place}'**
  String rideSearchingFrom(String place);

  /// No description provided for @rideSearchingTitle.
  ///
  /// In en, this message translates to:
  /// **'Finding your driver'**
  String get rideSearchingTitle;

  /// No description provided for @rideFareHeld.
  ///
  /// In en, this message translates to:
  /// **'Your fare is held. {amount}'**
  String rideFareHeld(Object amount);

  /// No description provided for @rideCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel ride'**
  String get rideCancel;

  /// No description provided for @rideCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this ride?'**
  String get rideCancelTitle;

  /// No description provided for @rideCancelFree.
  ///
  /// In en, this message translates to:
  /// **'It\'s free to cancel before you\'re in the car.'**
  String get rideCancelFree;

  /// No description provided for @rideKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep ride'**
  String get rideKeep;

  /// No description provided for @cancelWaitTooLong.
  ///
  /// In en, this message translates to:
  /// **'Waiting too long'**
  String get cancelWaitTooLong;

  /// No description provided for @cancelChangedMind.
  ///
  /// In en, this message translates to:
  /// **'I changed my mind'**
  String get cancelChangedMind;

  /// No description provided for @cancelWrongLocation.
  ///
  /// In en, this message translates to:
  /// **'Wrong pickup or drop-off'**
  String get cancelWrongLocation;

  /// No description provided for @cancelOther.
  ///
  /// In en, this message translates to:
  /// **'Another reason'**
  String get cancelOther;

  /// No description provided for @rideCancelFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t cancel just now. Check your connection and try again.'**
  String get rideCancelFailed;

  /// No description provided for @ridePinLabel.
  ///
  /// In en, this message translates to:
  /// **'Your start PIN'**
  String get ridePinLabel;

  /// No description provided for @ridePinHint.
  ///
  /// In en, this message translates to:
  /// **'Tell this to your driver when you\'re in the car. Never share it earlier.'**
  String get ridePinHint;

  /// No description provided for @ridePinDigit.
  ///
  /// In en, this message translates to:
  /// **'Digit {position}: {digit}'**
  String ridePinDigit(int position, String digit);

  /// No description provided for @ridePlate.
  ///
  /// In en, this message translates to:
  /// **'Plate'**
  String get ridePlate;

  /// No description provided for @rideVehicleLine.
  ///
  /// In en, this message translates to:
  /// **'{colour} {make} {model}'**
  String rideVehicleLine(String colour, String make, String model);

  /// No description provided for @rideDriverOnWay.
  ///
  /// In en, this message translates to:
  /// **'Your driver is on the way'**
  String get rideDriverOnWay;

  /// No description provided for @rideDriverArrived.
  ///
  /// In en, this message translates to:
  /// **'Your driver has arrived'**
  String get rideDriverArrived;

  /// No description provided for @rideEtaMinutes.
  ///
  /// In en, this message translates to:
  /// **'About {minutes} min away'**
  String rideEtaMinutes(Object minutes);

  /// No description provided for @ridePickupAt.
  ///
  /// In en, this message translates to:
  /// **'Pickup: {name}'**
  String ridePickupAt(Object name);

  /// No description provided for @rideLocationDelayed.
  ///
  /// In en, this message translates to:
  /// **'Your driver\'s location is delayed.'**
  String get rideLocationDelayed;

  /// No description provided for @rideMessagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick messages'**
  String get rideMessagesTitle;

  /// No description provided for @qmImHere.
  ///
  /// In en, this message translates to:
  /// **'I\'m here'**
  String get qmImHere;

  /// No description provided for @qmRunningLate.
  ///
  /// In en, this message translates to:
  /// **'Running late'**
  String get qmRunningLate;

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

  /// No description provided for @qmPleaseComeOut.
  ///
  /// In en, this message translates to:
  /// **'Please come out'**
  String get qmPleaseComeOut;

  /// No description provided for @qmOnMyWay.
  ///
  /// In en, this message translates to:
  /// **'On my way'**
  String get qmOnMyWay;

  /// No description provided for @rideMessageFailed.
  ///
  /// In en, this message translates to:
  /// **'That message didn\'t send. Try again.'**
  String get rideMessageFailed;

  /// No description provided for @rideDriverSaid.
  ///
  /// In en, this message translates to:
  /// **'{name}: {message}'**
  String rideDriverSaid(String name, String message);

  /// No description provided for @rideInTripTitle.
  ///
  /// In en, this message translates to:
  /// **'On your way'**
  String get rideInTripTitle;

  /// No description provided for @rideFareLocked.
  ///
  /// In en, this message translates to:
  /// **'Fare locked at {amount}'**
  String rideFareLocked(Object amount);

  /// No description provided for @rideShareTrip.
  ///
  /// In en, this message translates to:
  /// **'Share trip'**
  String get rideShareTrip;

  /// No description provided for @rideSafety.
  ///
  /// In en, this message translates to:
  /// **'Safety'**
  String get rideSafety;

  /// No description provided for @rideSosHold.
  ///
  /// In en, this message translates to:
  /// **'Hold for SOS'**
  String get rideSosHold;

  /// No description provided for @rideNoCancelNote.
  ///
  /// In en, this message translates to:
  /// **'Need to stop the ride? Contact support from Safety.'**
  String get rideNoCancelNote;

  /// No description provided for @rideArrivingIn.
  ///
  /// In en, this message translates to:
  /// **'About {minutes} min left'**
  String rideArrivingIn(Object minutes);

  /// No description provided for @rideDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'ve arrived'**
  String get rideDoneTitle;

  /// No description provided for @rideFareCharged.
  ///
  /// In en, this message translates to:
  /// **'Fare charged'**
  String get rideFareCharged;

  /// No description provided for @rideDistanceTime.
  ///
  /// In en, this message translates to:
  /// **'Distance and time'**
  String get rideDistanceTime;

  /// No description provided for @rideDistanceTimeValue.
  ///
  /// In en, this message translates to:
  /// **'{km} km · {minutes} min'**
  String rideDistanceTimeValue(String km, int minutes);

  /// No description provided for @rideViewReceipt.
  ///
  /// In en, this message translates to:
  /// **'View receipt'**
  String get rideViewReceipt;

  /// No description provided for @rideRateTitle.
  ///
  /// In en, this message translates to:
  /// **'How was your ride with {name}?'**
  String rideRateTitle(Object name);

  /// No description provided for @rideRateComment.
  ///
  /// In en, this message translates to:
  /// **'Anything we should know?'**
  String get rideRateComment;

  /// No description provided for @rideRateSubmit.
  ///
  /// In en, this message translates to:
  /// **'Send rating'**
  String get rideRateSubmit;

  /// No description provided for @rideRated.
  ///
  /// In en, this message translates to:
  /// **'Thanks. Your rating was sent.'**
  String get rideRated;

  /// No description provided for @rideDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get rideDone;

  /// No description provided for @rideReport.
  ///
  /// In en, this message translates to:
  /// **'Report a problem with this ride'**
  String get rideReport;

  /// No description provided for @rideRateFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t send your rating. Try again.'**
  String get rideRateFailed;

  /// No description provided for @rideCancelledYou.
  ///
  /// In en, this message translates to:
  /// **'You cancelled this ride'**
  String get rideCancelledYou;

  /// No description provided for @rideCancelledDriver.
  ///
  /// In en, this message translates to:
  /// **'Your driver couldn\'t make it'**
  String get rideCancelledDriver;

  /// No description provided for @rideCancelledNoDriver.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find a driver'**
  String get rideCancelledNoDriver;

  /// No description provided for @rideCancelledService.
  ///
  /// In en, this message translates to:
  /// **'We had to cancel this ride'**
  String get rideCancelledService;

  /// No description provided for @rideCancelledNoShow.
  ///
  /// In en, this message translates to:
  /// **'The driver couldn\'t find you'**
  String get rideCancelledNoShow;

  /// No description provided for @rideCancelledNoDriverBody.
  ///
  /// In en, this message translates to:
  /// **'No driver was free. You haven\'t been charged.'**
  String get rideCancelledNoDriverBody;

  /// No description provided for @rideCancelledDriverBody.
  ///
  /// In en, this message translates to:
  /// **'Your driver had a problem and couldn\'t come.'**
  String get rideCancelledDriverBody;

  /// No description provided for @rideCancelledServiceBody.
  ///
  /// In en, this message translates to:
  /// **'Something on our side stopped this ride.'**
  String get rideCancelledServiceBody;

  /// No description provided for @rideCancelledNoShowBody.
  ///
  /// In en, this message translates to:
  /// **'The driver waited at the pickup point and couldn\'t find you.'**
  String get rideCancelledNoShowBody;

  /// No description provided for @rideCancelledYouBody.
  ///
  /// In en, this message translates to:
  /// **'You cancelled before the trip started.'**
  String get rideCancelledYouBody;

  /// No description provided for @rideNotCharged.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t been charged.'**
  String get rideNotCharged;

  /// No description provided for @rideRefunded.
  ///
  /// In en, this message translates to:
  /// **'{amount} was put back in your wallet.'**
  String rideRefunded(Object amount);

  /// No description provided for @rideCharged.
  ///
  /// In en, this message translates to:
  /// **'You were charged {amount}.'**
  String rideCharged(Object amount);

  /// No description provided for @rideBackHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get rideBackHome;

  /// No description provided for @rideTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get rideTryAgain;

  /// No description provided for @receiptTitle.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get receiptTitle;

  /// No description provided for @receiptNumber.
  ///
  /// In en, this message translates to:
  /// **'Receipt {number}'**
  String receiptNumber(Object number);

  /// No description provided for @receiptDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get receiptDistance;

  /// No description provided for @receiptDriver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get receiptDriver;

  /// No description provided for @receiptKm.
  ///
  /// In en, this message translates to:
  /// **'{km} km'**
  String receiptKm(String km);

  /// No description provided for @receiptTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get receiptTotal;

  /// No description provided for @rideLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your ride. Check your connection and try again.'**
  String get rideLoadFailed;

  /// No description provided for @bookFailedInsufficient.
  ///
  /// In en, this message translates to:
  /// **'Your wallet is short. Top up and book again.'**
  String get bookFailedInsufficient;

  /// No description provided for @homeActiveRide.
  ///
  /// In en, this message translates to:
  /// **'Ride in progress'**
  String get homeActiveRide;

  /// No description provided for @homeActiveOpen.
  ///
  /// In en, this message translates to:
  /// **'Open ride'**
  String get homeActiveOpen;

  /// No description provided for @homeActiveDisabled.
  ///
  /// In en, this message translates to:
  /// **'Finish or cancel your ride to book another.'**
  String get homeActiveDisabled;

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

  /// No description provided for @sosKeepHolding.
  ///
  /// In en, this message translates to:
  /// **'Keep holding to send SOS'**
  String get sosKeepHolding;

  /// No description provided for @sosLetGo.
  ///
  /// In en, this message translates to:
  /// **'Let go to stop. Nothing is sent yet.'**
  String get sosLetGo;

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

  /// No description provided for @sosCallSecurity.
  ///
  /// In en, this message translates to:
  /// **'Call campus security'**
  String get sosCallSecurity;

  /// No description provided for @safetyTileSecurity.
  ///
  /// In en, this message translates to:
  /// **'Campus security'**
  String get safetyTileSecurity;

  /// No description provided for @safetyTileEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get safetyTileEmergency;

  /// No description provided for @sosCall.
  ///
  /// In en, this message translates to:
  /// **'Call {number}'**
  String sosCall(Object number);

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

  /// No description provided for @safetyTitle.
  ///
  /// In en, this message translates to:
  /// **'Safety'**
  String get safetyTitle;

  /// No description provided for @safetySosNote.
  ///
  /// In en, this message translates to:
  /// **'Staff see your live location and call you at once. They can alert campus security.'**
  String get safetySosNote;

  /// No description provided for @safetyShareTrip.
  ///
  /// In en, this message translates to:
  /// **'Share my trip'**
  String get safetyShareTrip;

  /// No description provided for @safetyShareNoRide.
  ///
  /// In en, this message translates to:
  /// **'Start a ride to share it with someone.'**
  String get safetyShareNoRide;

  /// No description provided for @safetyContacts.
  ///
  /// In en, this message translates to:
  /// **'Trusted contacts'**
  String get safetyContacts;

  /// No description provided for @safetyContactsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} of 3'**
  String safetyContactsCount(int count);

  /// No description provided for @safetyContactsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add someone who should know when you travel.'**
  String get safetyContactsEmpty;

  /// No description provided for @safetyAddContact.
  ///
  /// In en, this message translates to:
  /// **'Add a contact'**
  String get safetyAddContact;

  /// No description provided for @safetyContactName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get safetyContactName;

  /// No description provided for @safetyContactPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get safetyContactPhone;

  /// No description provided for @safetyContactRelation.
  ///
  /// In en, this message translates to:
  /// **'Relationship (optional)'**
  String get safetyContactRelation;

  /// No description provided for @safetyContactSave.
  ///
  /// In en, this message translates to:
  /// **'Save contact'**
  String get safetyContactSave;

  /// No description provided for @safetyContactRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get safetyContactRemove;

  /// No description provided for @safetyContactRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove this contact?'**
  String get safetyContactRemoveTitle;

  /// No description provided for @safetyContactRemoveBody.
  ///
  /// In en, this message translates to:
  /// **'They won\'t be told about your trips any more.'**
  String get safetyContactRemoveBody;

  /// No description provided for @safetyContactLimit.
  ///
  /// In en, this message translates to:
  /// **'You can add up to 3 contacts.'**
  String get safetyContactLimit;

  /// No description provided for @safetyContactInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a Ghana number like 24 123 4567.'**
  String get safetyContactInvalid;

  /// No description provided for @safetyCallForHelp.
  ///
  /// In en, this message translates to:
  /// **'Call for help'**
  String get safetyCallForHelp;

  /// No description provided for @safetyHowSosWorks.
  ///
  /// In en, this message translates to:
  /// **'How SOS works'**
  String get safetyHowSosWorks;

  /// No description provided for @safetyHowSosBody.
  ///
  /// In en, this message translates to:
  /// **'Hold the button for three seconds. We send your location and ride to our staff, who call you and can alert campus security. Letting go before three seconds sends nothing.'**
  String get safetyHowSosBody;

  /// No description provided for @safetyReport.
  ///
  /// In en, this message translates to:
  /// **'Report a safety concern'**
  String get safetyReport;

  /// No description provided for @safetyLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your contacts. Check your connection and try again.'**
  String get safetyLoadFailed;

  /// No description provided for @shareTitle.
  ///
  /// In en, this message translates to:
  /// **'Share this trip'**
  String get shareTitle;

  /// No description provided for @shareChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose who should follow your ride'**
  String get shareChoose;

  /// No description provided for @shareSend.
  ///
  /// In en, this message translates to:
  /// **'Send link'**
  String get shareSend;

  /// No description provided for @shareSendTo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Send to 1 contact} other{Send to {count} contacts}}'**
  String shareSendTo(int count);

  /// No description provided for @sharePreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'What they get'**
  String get sharePreviewTitle;

  /// No description provided for @sharePreviewBody.
  ///
  /// In en, this message translates to:
  /// **'A link to follow your ride live, with your pickup, drop-off, driver and car. It stops working when the ride ends.'**
  String get sharePreviewBody;

  /// No description provided for @shareSent.
  ///
  /// In en, this message translates to:
  /// **'Link sent'**
  String get shareSent;

  /// No description provided for @shareSentBody.
  ///
  /// In en, this message translates to:
  /// **'They can follow your ride without an account. The link stops working when the ride ends.'**
  String get shareSentBody;

  /// No description provided for @shareCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get shareCopy;

  /// No description provided for @shareCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get shareCopied;

  /// No description provided for @shareNeedContact.
  ///
  /// In en, this message translates to:
  /// **'Add a trusted contact first.'**
  String get shareNeedContact;

  /// No description provided for @shareFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t share the trip. Try again.'**
  String get shareFailed;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @supportTitle.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportTitle;

  /// No description provided for @supportNew.
  ///
  /// In en, this message translates to:
  /// **'New ticket'**
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

  /// No description provided for @catSafety.
  ///
  /// In en, this message translates to:
  /// **'Safety'**
  String get catSafety;

  /// No description provided for @catDriver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get catDriver;

  /// No description provided for @catVehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get catVehicle;

  /// No description provided for @catWrongCharge.
  ///
  /// In en, this message translates to:
  /// **'Wrong charge'**
  String get catWrongCharge;

  /// No description provided for @catPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get catPayment;

  /// No description provided for @catLostItem.
  ///
  /// In en, this message translates to:
  /// **'Lost item'**
  String get catLostItem;

  /// No description provided for @catAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get catAccount;

  /// No description provided for @catPhoneChange.
  ///
  /// In en, this message translates to:
  /// **'Change my phone number'**
  String get catPhoneChange;

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

  /// No description provided for @supportRide.
  ///
  /// In en, this message translates to:
  /// **'About a ride'**
  String get supportRide;

  /// No description provided for @supportAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a photo'**
  String get supportAddPhoto;

  /// No description provided for @supportPhotos.
  ///
  /// In en, this message translates to:
  /// **'{count} of 5 photos'**
  String supportPhotos(int count);

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

  /// No description provided for @supportPhotoFailed.
  ///
  /// In en, this message translates to:
  /// **'That photo didn\'t upload. Try again.'**
  String get supportPhotoFailed;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profileEmailAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get profileEmailAdd;

  /// No description provided for @profileEmailSave.
  ///
  /// In en, this message translates to:
  /// **'Save email'**
  String get profileEmailSave;

  /// No description provided for @profileEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get profileEmailInvalid;

  /// No description provided for @profileSavedPlaces.
  ///
  /// In en, this message translates to:
  /// **'Saved places'**
  String get profileSavedPlaces;

  /// No description provided for @profileSavedPlacesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No saved places yet.'**
  String get profileSavedPlacesEmpty;

  /// No description provided for @profileDevices.
  ///
  /// In en, this message translates to:
  /// **'Signed-in devices'**
  String get profileDevices;

  /// No description provided for @profileSignOutOthers.
  ///
  /// In en, this message translates to:
  /// **'Sign out everywhere else'**
  String get profileSignOutOthers;

  /// No description provided for @profileThisDevice.
  ///
  /// In en, this message translates to:
  /// **'This phone'**
  String get profileThisDevice;

  /// No description provided for @profileDeviceLastUsed.
  ///
  /// In en, this message translates to:
  /// **'Last used {when}'**
  String profileDeviceLastUsed(Object when);

  /// No description provided for @profileSignOutDevice.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get profileSignOutDevice;

  /// No description provided for @profileTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get profileTerms;

  /// No description provided for @profilePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy notice'**
  String get profilePrivacy;

  /// No description provided for @profileVersion.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get profileVersion;

  /// No description provided for @profileSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get profileSignOut;

  /// No description provided for @profileDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get profileDelete;

  /// No description provided for @profileDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get profileDeleteTitle;

  /// No description provided for @profileDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Our team will handle any money left in your wallet and anonymise your ride records. This can\'t be undone.'**
  String get profileDeleteBody;

  /// No description provided for @profileDeleteConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get profileDeleteConfirmLabel;

  /// No description provided for @profileDeleteRequested.
  ///
  /// In en, this message translates to:
  /// **'We\'ve received your request. We\'ll be in touch about your wallet.'**
  String get profileDeleteRequested;

  /// No description provided for @profileLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your profile. Check your connection and try again.'**
  String get profileLoadFailed;

  /// No description provided for @profileChangePhone.
  ///
  /// In en, this message translates to:
  /// **'To change your phone number, contact support.'**
  String get profileChangePhone;

  /// No description provided for @profileRemovePlace.
  ///
  /// In en, this message translates to:
  /// **'Remove place'**
  String get profileRemovePlace;
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
