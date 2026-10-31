// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get continueAction => 'Continue';

  @override
  String get tryAgain => 'Try again';

  @override
  String get back => 'Back';

  @override
  String get offlineBanner =>
      'You\'re offline. Some things may be out of date.';

  @override
  String get bootErrorTitle => 'We couldn\'t start up';

  @override
  String get bootErrorBody => 'Check your connection and try again.';

  @override
  String get updateRequiredTitle => 'Please update the app';

  @override
  String updateRequiredBody(Object appName) {
    return 'This version of $appName is too old to keep working. Update it from the store to carry on.';
  }

  @override
  String get maintenanceTitle => 'We\'re doing some maintenance';

  @override
  String maintenanceBody(Object appName) {
    return '$appName is paused for a short while. Please try again soon.';
  }

  @override
  String get maintenanceCheckAgain => 'Check again';

  @override
  String get welcomeTagline => 'Campus rides, paid from your wallet';

  @override
  String get welcomeAudience => 'For Central University students at Miotso';

  @override
  String get phoneTitle => 'Your phone number';

  @override
  String get phoneFieldLabel => 'Phone number';

  @override
  String get phoneHelper => 'We\'ll text you a 6-digit code';

  @override
  String get phoneSendCode => 'Send code';

  @override
  String get phoneInvalid =>
      'Enter your 9-digit number, for example 24 123 4567.';

  @override
  String get codeTitle => 'Enter your code';

  @override
  String codeSentTo(Object phone) {
    return 'We sent a 6-digit code to $phone.';
  }

  @override
  String get codeVerify => 'Verify';

  @override
  String get codeResend => 'Send a new code';

  @override
  String codeResendIn(Object seconds) {
    return 'Send a new code in $seconds s';
  }

  @override
  String get codeWrongNumber => 'Wrong number?';

  @override
  String get termsTitle => 'Before you start';

  @override
  String get termsAgree => 'I agree';

  @override
  String termsBulletRules(Object appName) {
    return '$appName is for verified Central University students. You pay from a wallet, and fares are fixed before you book.';
  }

  @override
  String get termsBulletData =>
      'We keep your ride records and your verification documents only as long as we need to. Documents are deleted after review.';

  @override
  String get termsWhyLocationTitle => 'Why we need your location';

  @override
  String get termsWhyLocation =>
      'To show your pickup point on the map and help your driver find you. We only use it while the app is open.';

  @override
  String get termsWhyCameraTitle => 'Why we need your camera';

  @override
  String get termsWhyCamera =>
      'To take photos of your Ghana Card and student ID once, so we can confirm you are a student.';

  @override
  String get termsReadTerms => 'Read the full terms';

  @override
  String get termsReadPrivacy => 'Read the privacy notice';

  @override
  String get termsLoadFailed =>
      'We couldn\'t load the terms. Check your connection and try again.';

  @override
  String get problemGeneric => 'Something went wrong. Please try again.';

  @override
  String get problemNetwork =>
      'No connection. Check your internet and try again.';

  @override
  String get problemRateLimited =>
      'Too many tries. Please wait a moment and try again.';

  @override
  String problemRateLimitedWait(Object seconds) {
    return 'Too many tries. Please wait $seconds s and try again.';
  }

  @override
  String get problemOtpInvalid =>
      'That code isn\'t right. Check it and try again.';

  @override
  String get problemOtpExpired => 'That code has expired. Ask for a new one.';

  @override
  String get problemOtpRateLimited =>
      'Too many codes asked for. Please wait before asking again.';

  @override
  String get problemSmsBudget =>
      'We can\'t send codes right now. Try again soon.';

  @override
  String get problemAccountSuspended =>
      'This account is suspended. Contact support for help.';

  @override
  String get problemUpgradeRequired => 'Please update the app to carry on.';

  @override
  String get problemDuplicateIdentity =>
      'This Ghana Card is already linked to another account. Contact support.';

  @override
  String get problemVerificationRequired =>
      'Your student check isn\'t finished yet.';

  @override
  String get problemVerificationNotResubmittable =>
      'Your documents can\'t be sent again right now.';

  @override
  String get problemUploadExpired =>
      'That upload took too long. Please try the photo again.';

  @override
  String get problemValidation =>
      'Some details aren\'t right. Check them and try again.';

  @override
  String get problemNoDrivers =>
      'No drivers are available right now. Try again soon.';

  @override
  String get problemOutsideArea => 'That place is outside the area we cover.';

  @override
  String problemRouteTooLong(Object km) {
    return 'This trip is over $km km, which is the longest we do.';
  }

  @override
  String get problemRouteUnavailable =>
      'We couldn\'t find a route between those places.';

  @override
  String get problemBookingsPaused =>
      'Booking is paused for now. Please try again later.';

  @override
  String get problemAccountOwes =>
      'You owe money on your wallet. Top up to book again.';

  @override
  String get problemActiveRide => 'You already have a ride in progress.';

  @override
  String get problemQuoteExpired =>
      'That price has expired. We\'ll get you a new one.';

  @override
  String get verifyTitle => 'Confirm you\'re a student';

  @override
  String get verifyIntro =>
      'You only do this once. It takes about two minutes and you\'ll need your Ghana Card and student ID.';

  @override
  String get verifyPrivacyNote =>
      'Only our verification team sees these. They are deleted after review.';

  @override
  String get verifyFullName => 'Full name as on your Ghana Card';

  @override
  String get verifyGhanaCard => 'Ghana Card number';

  @override
  String get verifyGhanaCardHelper => 'Looks like GHA-123456789-0';

  @override
  String get verifyGhanaCardInvalid =>
      'Enter the number as shown on the card, like GHA-123456789-0.';

  @override
  String get verifyStudentId => 'Student ID number';

  @override
  String get verifyFieldRequired => 'This is needed.';

  @override
  String get verifyPhotosTitle => 'Photos';

  @override
  String get verifySubmit => 'Submit';

  @override
  String get verifySubmitting => 'Sending';

  @override
  String get verifyDetailsKept =>
      'We keep what you\'ve typed if you close the app.';

  @override
  String get docGhanaCardFront => 'Ghana Card, front';

  @override
  String get docGhanaCardBack => 'Ghana Card, back';

  @override
  String get docStudentId => 'Student ID';

  @override
  String get docSelfie => 'Selfie holding your Ghana Card';

  @override
  String get docTake => 'Take photo';

  @override
  String get docRetake => 'Retake';

  @override
  String docUploading(Object percent) {
    return 'Sending $percent%';
  }

  @override
  String get docUploaded => 'Sent';

  @override
  String get docNotTaken => 'Not taken yet';

  @override
  String get docFailed => 'Didn\'t send';

  @override
  String get docRetry => 'Try sending again';

  @override
  String get captureGuideCard =>
      'Fit the card inside the frame, flat and in good light.';

  @override
  String get captureGuideSelfie =>
      'Hold your Ghana Card next to your face and look at the camera.';

  @override
  String get captureShutter => 'Take photo';

  @override
  String get captureUsePhoto => 'Use this photo';

  @override
  String get captureCancel => 'Cancel';

  @override
  String get captureIssueBlurry =>
      'This looks blurry. Hold still and try again.';

  @override
  String get captureIssueGlare =>
      'There is glare on the photo. Tilt the card away from the light.';

  @override
  String get captureIssueDark => 'It\'s too dark. Move to a brighter place.';

  @override
  String get captureIssueUnreadable =>
      'We couldn\'t read that photo. Please take it again.';

  @override
  String get captureLooksGood => 'This looks clear.';

  @override
  String captureCameraDenied(Object appName) {
    return '$appName needs the camera to photograph your documents. Turn it on in Settings.';
  }

  @override
  String get captureOpenSettings => 'Open Settings';

  @override
  String get captureCameraFailed =>
      'The camera didn\'t start. Close other apps that use it and try again.';

  @override
  String get verifyDuplicate =>
      'This Ghana Card is already linked to another account. Contact support.';

  @override
  String get verifyResubmitNote =>
      'Some documents were no longer valid. Please photograph them again.';

  @override
  String get statusPendingTitle => 'We\'re checking your documents';

  @override
  String get statusPendingBody => 'This usually takes a day. We\'ll text you.';

  @override
  String get statusNeedsAttentionTitle => 'We need a little more';

  @override
  String get statusNeedsAttentionFallback =>
      'Some of your documents couldn\'t be read. Please send them again.';

  @override
  String get statusResubmit => 'Send again';

  @override
  String get statusRejectedTitle => 'We couldn\'t confirm you';

  @override
  String get statusRejectedFallback =>
      'Your documents didn\'t meet our checks.';

  @override
  String get statusRejectedContact =>
      'Contact support if you think this is a mistake.';

  @override
  String get statusApprovedTitle => 'You\'re verified';

  @override
  String get statusApprovedBody => 'You can now book rides.';

  @override
  String get statusRefreshFailed =>
      'We couldn\'t check just now. Pull down to try again.';

  @override
  String statusSubmittedAt(Object date) {
    return 'Sent $date';
  }

  @override
  String get homeWhereTo => 'Where to?';

  @override
  String homeWalletChip(Object amount) {
    return 'Wallet $amount';
  }

  @override
  String homeWalletLow(Object amount) {
    return 'Wallet $amount, low';
  }

  @override
  String get homeSavedPlaces => 'Saved places';

  @override
  String get homeOfflineMap =>
      'You\'re offline. The map and prices may be out of date.';

  @override
  String get homeBookingsPaused => 'Booking is paused for now.';

  @override
  String get homeLocationDeniedTitle => 'Location is off';

  @override
  String homeLocationDeniedBody(Object appName) {
    return '$appName uses your location to find the nearest pickup point. You can also choose a pickup point from the list.';
  }

  @override
  String get homeAllowLocation => 'Allow location';

  @override
  String get homeChoosePickup => 'Choose a pickup point';

  @override
  String get homeLocationServicesOff =>
      'Switch on location in your phone\'s settings to find the nearest pickup point.';

  @override
  String get homeLoadFailed =>
      'We couldn\'t load the map details. Check your connection and try again.';

  @override
  String get destTitle => 'Where to?';

  @override
  String get destPickupLabel => 'Pickup';

  @override
  String get destPickupCurrent => 'Nearest pickup point';

  @override
  String get destPickupChoose => 'Choose a pickup point';

  @override
  String get destPickupNone => 'Using your location';

  @override
  String get destSearchLabel => 'Search for a place';

  @override
  String get destSearchNoResults => 'No places found. Try different words.';

  @override
  String get destSearchFailed => 'We couldn\'t search just now. Try again.';

  @override
  String get destSavedTitle => 'Saved places';

  @override
  String get destSavedEmpty => 'You have no saved places yet.';

  @override
  String get destContinue => 'Continue';

  @override
  String get destNeedPickup => 'Choose where we pick you up first.';

  @override
  String get quoteTitle => 'Your ride';

  @override
  String get quoteFixed => 'Fixed. It won\'t change.';

  @override
  String quoteRoute(String km, int minutes) {
    return '$km km · about $minutes min';
  }

  @override
  String quotePickupEta(Object minutes) {
    return 'Driver reaches you in about $minutes min';
  }

  @override
  String quoteWalletLine(String balance, String after) {
    return 'Wallet $balance, $after after this ride';
  }

  @override
  String get quoteCancelRule => 'Cancel for free until you\'re in the car.';

  @override
  String quoteBook(Object fare) {
    return 'Book for $fare';
  }

  @override
  String quoteTopUp(Object amount) {
    return 'Top up $amount';
  }

  @override
  String quoteShortfall(Object amount) {
    return 'Your wallet is short by $amount.';
  }

  @override
  String get quoteBookingSoon => 'Booking opens in the next update.';

  @override
  String get quoteIneligibleTitle => 'We can\'t book this trip';

  @override
  String get quoteChangeLocation => 'Change location';

  @override
  String get quoteExpired => 'That price expired, so we got you a new one.';

  @override
  String get quoteLoadFailed =>
      'We couldn\'t get a price. Check your connection and try again.';

  @override
  String get quoteGettingPrice => 'Getting your price';

  @override
  String get destPlacesTitle => 'Campus and popular places';

  @override
  String get destPlacesEmpty => 'No places are set up yet.';

  @override
  String get navRide => 'Ride';

  @override
  String get navWallet => 'Wallet';

  @override
  String get navActivity => 'Activity';

  @override
  String get walletTitle => 'Wallet';

  @override
  String get walletAvailable => 'Available';

  @override
  String walletHeld(Object amount) {
    return '$amount held for your ride';
  }

  @override
  String walletOwed(Object amount) {
    return 'You owe $amount. Top up to book again.';
  }

  @override
  String get walletTopUp => 'Top up';

  @override
  String get walletRecent => 'Recent activity';

  @override
  String get walletSeeAll => 'See all';

  @override
  String get walletNoTransactions => 'No transactions yet.';

  @override
  String get walletLoadFailed =>
      'We couldn\'t load your wallet. Check your connection and try again.';

  @override
  String get transactionsTitle => 'Transactions';

  @override
  String get transactionsLoadMore => 'Show more';

  @override
  String get txTopUp => 'Top-up';

  @override
  String get txHeld => 'Held';

  @override
  String get txReleased => 'Released';

  @override
  String get txRide => 'Ride';

  @override
  String get txRefund => 'Refund';

  @override
  String get txAdjustment => 'Adjustment';

  @override
  String get txReversal => 'Reversed';

  @override
  String get topupTitle => 'Top up';

  @override
  String get topupAmount => 'Choose an amount';

  @override
  String get topupCustom => 'Other amount in cedis';

  @override
  String topupCustomHint(String min, String max) {
    return 'Between $min and $max';
  }

  @override
  String topupPay(Object amount) {
    return 'Pay $amount';
  }

  @override
  String topupPhoneNote(Object phone) {
    return 'We\'ll send a payment prompt to $phone.';
  }

  @override
  String get topupPendingTitle => 'A top-up is still waiting';

  @override
  String get topupPendingBody =>
      'You started a top-up that hasn\'t finished. If you start another, you could pay twice.';

  @override
  String get topupPendingWait => 'Go back';

  @override
  String get topupPendingAnother => 'Start another';

  @override
  String get topupWaitTitle => 'Approve the payment on your phone';

  @override
  String get topupStep1 => 'A prompt appears on your phone.';

  @override
  String get topupStep2 => 'Enter your mobile money PIN to approve.';

  @override
  String get topupStep3 => 'Come back here. This updates by itself.';

  @override
  String topupWaitSeconds(Object seconds) {
    return 'Checking for $seconds more seconds';
  }

  @override
  String get topupCheckStatus => 'Check status';

  @override
  String get topupLeave => 'Leave this screen';

  @override
  String get topupSuccessTitle => 'Money added';

  @override
  String topupSuccessBody(Object amount) {
    return 'Your wallet now has $amount available.';
  }

  @override
  String get topupDone => 'Done';

  @override
  String get topupFailedTitle => 'The payment didn\'t go through';

  @override
  String get topupFailedBody => 'You haven\'t been charged. You can try again.';

  @override
  String get topupSlowTitle => 'Still waiting';

  @override
  String get topupSlowBody =>
      'We\'ll add the money when it arrives. You don\'t need to pay again.';

  @override
  String get topupTryAgain => 'Try again';

  @override
  String topupAmountRange(String min, String max) {
    return 'Choose an amount between $min and $max.';
  }

  @override
  String get problemTopupRange =>
      'That amount isn\'t allowed. Choose a different amount.';

  @override
  String get problemPaymentProvider =>
      'The payment service isn\'t answering. Try again in a moment.';

  @override
  String get problemInsufficient =>
      'Your wallet doesn\'t have enough for this ride. Top up and try again.';

  @override
  String get activityTitle => 'Activity';

  @override
  String get activityEmpty => 'Your rides will appear here.';

  @override
  String get activityLoadFailed =>
      'We couldn\'t load your rides. Check your connection and try again.';

  @override
  String get rideStatusSearching => 'Finding a driver';

  @override
  String get rideStatusAssigned => 'Driver on the way';

  @override
  String get rideStatusArrived => 'Driver has arrived';

  @override
  String get rideStatusInProgress => 'On the way';

  @override
  String get rideStatusCompleted => 'Completed';

  @override
  String get rideStatusCancelled => 'Cancelled';
}
