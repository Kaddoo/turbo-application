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
  String get suspendedTitle => 'Your account is suspended';

  @override
  String get suspendedTag => 'Suspended';

  @override
  String get suspendedBody =>
      'You can\'t book rides for now. Contact support to find out why and what happens next.';

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
  String get welcomeTaglineAccent => 'wallet';

  @override
  String get welcomeFixedFares => 'Fixed fares';

  @override
  String get welcomeContinue => 'Continue';

  @override
  String get welcomeAudience => 'For Central University students at Miotso';

  @override
  String get phoneTitle => 'Sign in with your phone';

  @override
  String get phoneTitleAccent => 'phone';

  @override
  String get phoneLead => 'New or returning, it\'s the same step.';

  @override
  String get phoneLegal =>
      'By continuing you agree to the terms and privacy notice.';

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
  String get codeTitle => 'Enter the code';

  @override
  String get codeTitleAccent => 'code';

  @override
  String codeSentTo(Object phone) {
    return 'We sent a 6-digit code to $phone';
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
  String get problemServiceBusy =>
      'We\'re busy right now. Try again in a moment.';

  @override
  String problemServiceBusyWait(int seconds) {
    return 'We\'re busy right now. Try again in $seconds seconds.';
  }

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
  String get homeYourPickup => 'Your pickup point';

  @override
  String get homeBookRide => 'Book a ride';

  @override
  String get homeSafetyLabel => 'Safety';

  @override
  String get homeSafetyTile => 'SOS and trip sharing';

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
  String homeHello(String name) {
    return 'Hello, $name';
  }

  @override
  String get homeHelloNoName => 'Hello';

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
  String get txToday => 'Today';

  @override
  String get txYesterday => 'Yesterday';

  @override
  String get topupWaitLeft => 'left to approve';

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
  String get activityFilterAll => 'All rides';

  @override
  String get activityTitle => 'Activity';

  @override
  String get activityThisWeek => 'This week';

  @override
  String get activityEarlier => 'Earlier';

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

  @override
  String get rideTileFareHeld => 'Fare is held';

  @override
  String get rideTileTo => 'To';

  @override
  String rideSearchingFrom(String place) {
    return 'Pickup: $place';
  }

  @override
  String get rideSearchingTitle => 'Finding your driver';

  @override
  String rideFareHeld(Object amount) {
    return 'Your fare is held. $amount';
  }

  @override
  String get rideCancel => 'Cancel ride';

  @override
  String get rideCancelTitle => 'Cancel this ride?';

  @override
  String get rideCancelFree =>
      'It\'s free to cancel before you\'re in the car.';

  @override
  String get rideKeep => 'Keep ride';

  @override
  String get cancelWaitTooLong => 'Waiting too long';

  @override
  String get cancelChangedMind => 'I changed my mind';

  @override
  String get cancelWrongLocation => 'Wrong pickup or drop-off';

  @override
  String get cancelOther => 'Another reason';

  @override
  String get rideCancelFailed =>
      'We couldn\'t cancel just now. Check your connection and try again.';

  @override
  String get ridePinLabel => 'Your start PIN';

  @override
  String get ridePinHint =>
      'Tell this to your driver when you\'re in the car. Never share it earlier.';

  @override
  String ridePinDigit(int position, String digit) {
    return 'Digit $position: $digit';
  }

  @override
  String get ridePlate => 'Plate';

  @override
  String rideVehicleLine(String colour, String make, String model) {
    return '$colour $make $model';
  }

  @override
  String get rideDriverOnWay => 'Your driver is on the way';

  @override
  String get rideDriverArrived => 'Your driver has arrived';

  @override
  String rideEtaMinutes(Object minutes) {
    return 'About $minutes min away';
  }

  @override
  String ridePickupAt(Object name) {
    return 'Pickup: $name';
  }

  @override
  String get rideLocationDelayed => 'Your driver\'s location is delayed.';

  @override
  String get rideMessagesTitle => 'Quick messages';

  @override
  String get qmImHere => 'I\'m here';

  @override
  String get qmRunningLate => 'Running late';

  @override
  String get qmAtTheGate => 'At the gate';

  @override
  String get qmCannotFindYou => 'I can\'t find you';

  @override
  String get qmPleaseComeOut => 'Please come out';

  @override
  String get qmOnMyWay => 'On my way';

  @override
  String get rideMessageFailed => 'That message didn\'t send. Try again.';

  @override
  String rideDriverSaid(String name, String message) {
    return '$name: $message';
  }

  @override
  String get rideInTripTitle => 'On your way';

  @override
  String rideFareLocked(Object amount) {
    return 'Fare locked at $amount';
  }

  @override
  String get rideShareTrip => 'Share trip';

  @override
  String get rideSafety => 'Safety';

  @override
  String get rideSosHold => 'Hold for SOS';

  @override
  String get rideNoCancelNote =>
      'Need to stop the ride? Contact support from Safety.';

  @override
  String rideArrivingIn(Object minutes) {
    return 'About $minutes min left';
  }

  @override
  String get rideDoneTitle => 'You\'ve arrived';

  @override
  String get rideFareCharged => 'Fare charged';

  @override
  String get rideDistanceTime => 'Distance and time';

  @override
  String rideDistanceTimeValue(String km, int minutes) {
    return '$km km · $minutes min';
  }

  @override
  String get rideViewReceipt => 'View receipt';

  @override
  String rideRateTitle(Object name) {
    return 'How was your ride with $name?';
  }

  @override
  String get rideRateComment => 'Anything we should know?';

  @override
  String get rideRateSubmit => 'Send rating';

  @override
  String get rideRated => 'Thanks. Your rating was sent.';

  @override
  String get rideDone => 'Done';

  @override
  String get rideReport => 'Report a problem with this ride';

  @override
  String get rideRateFailed => 'We couldn\'t send your rating. Try again.';

  @override
  String get rideCancelledYou => 'You cancelled this ride';

  @override
  String get rideCancelledDriver => 'Your driver couldn\'t make it';

  @override
  String get rideCancelledNoDriver => 'We couldn\'t find a driver';

  @override
  String get rideCancelledService => 'We had to cancel this ride';

  @override
  String get rideCancelledNoShow => 'The driver couldn\'t find you';

  @override
  String get rideCancelledNoDriverBody =>
      'No driver was free. You haven\'t been charged.';

  @override
  String get rideCancelledDriverBody =>
      'Your driver had a problem and couldn\'t come.';

  @override
  String get rideCancelledServiceBody =>
      'Something on our side stopped this ride.';

  @override
  String get rideCancelledNoShowBody =>
      'The driver waited at the pickup point and couldn\'t find you.';

  @override
  String get rideCancelledYouBody => 'You cancelled before the trip started.';

  @override
  String get rideNotCharged => 'You haven\'t been charged.';

  @override
  String rideRefunded(Object amount) {
    return '$amount was put back in your wallet.';
  }

  @override
  String rideCharged(Object amount) {
    return 'You were charged $amount.';
  }

  @override
  String get rideBackHome => 'Back to home';

  @override
  String get rideTryAgain => 'Try again';

  @override
  String get receiptTitle => 'Receipt';

  @override
  String receiptNumber(Object number) {
    return 'Receipt $number';
  }

  @override
  String get receiptTotal => 'Total';

  @override
  String get rideLoadFailed =>
      'We couldn\'t load your ride. Check your connection and try again.';

  @override
  String get bookFailedInsufficient =>
      'Your wallet is short. Top up and book again.';

  @override
  String get homeActiveRide => 'Ride in progress';

  @override
  String get homeActiveOpen => 'Open ride';

  @override
  String get homeActiveDisabled =>
      'Finish or cancel your ride to book another.';

  @override
  String get sosHold => 'Hold for SOS';

  @override
  String get sosHoldSeconds => 'Hold for 3 seconds';

  @override
  String get sosKeepHolding => 'Keep holding to send SOS';

  @override
  String get sosLetGo => 'Let go to stop. Nothing is sent yet.';

  @override
  String sosSecondsLeft(int seconds) {
    return '$seconds seconds';
  }

  @override
  String get sosAlerted => 'Help has been alerted';

  @override
  String sosAlertedBody(String appName) {
    return 'Staff at $appName can see your location and will call you. Stay where it is safe.';
  }

  @override
  String get sosFailed => 'We couldn\'t send the alert';

  @override
  String get sosFailedBody => 'Call the emergency number now.';

  @override
  String sosCall(Object number) {
    return 'Call $number';
  }

  @override
  String get sosNoLocation =>
      'We couldn\'t find your location. Call the emergency number now.';

  @override
  String get sosDismiss => 'Close';

  @override
  String get safetyTitle => 'Safety';

  @override
  String get safetySosNote =>
      'Staff see your live location and call you at once. They can alert campus security.';

  @override
  String get safetyShareTrip => 'Share my trip';

  @override
  String get safetyShareNoRide => 'Start a ride to share it with someone.';

  @override
  String get safetyContacts => 'Trusted contacts';

  @override
  String safetyContactsCount(int count) {
    return '$count of 3';
  }

  @override
  String get safetyContactsEmpty =>
      'Add someone who should know when you travel.';

  @override
  String get safetyAddContact => 'Add a contact';

  @override
  String get safetyContactName => 'Name';

  @override
  String get safetyContactPhone => 'Phone number';

  @override
  String get safetyContactRelation => 'Relationship (optional)';

  @override
  String get safetyContactSave => 'Save contact';

  @override
  String get safetyContactRemove => 'Remove';

  @override
  String get safetyContactRemoveTitle => 'Remove this contact?';

  @override
  String get safetyContactRemoveBody =>
      'They won\'t be told about your trips any more.';

  @override
  String get safetyContactLimit => 'You can add up to 3 contacts.';

  @override
  String get safetyContactInvalid => 'Enter a Ghana number like 24 123 4567.';

  @override
  String get safetyCallForHelp => 'Call for help';

  @override
  String get safetyHowSosWorks => 'How SOS works';

  @override
  String get safetyHowSosBody =>
      'Hold the button for three seconds. We send your location and ride to our staff, who call you and can alert campus security. Letting go before three seconds sends nothing.';

  @override
  String get safetyReport => 'Report a safety concern';

  @override
  String get safetyLoadFailed =>
      'We couldn\'t load your contacts. Check your connection and try again.';

  @override
  String get shareTitle => 'Share this trip';

  @override
  String get shareChoose => 'Choose who should follow your ride';

  @override
  String get shareSend => 'Send link';

  @override
  String shareSendTo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Send to $count contacts',
      one: 'Send to 1 contact',
    );
    return '$_temp0';
  }

  @override
  String get sharePreviewTitle => 'What they get';

  @override
  String get sharePreviewBody =>
      'A link to follow your ride live, with your pickup, drop-off, driver and car. It stops working when the ride ends.';

  @override
  String get shareSent => 'Link sent';

  @override
  String get shareSentBody =>
      'They can follow your ride without an account. The link stops working when the ride ends.';

  @override
  String get shareCopy => 'Copy link';

  @override
  String get shareCopied => 'Link copied';

  @override
  String get shareNeedContact => 'Add a trusted contact first.';

  @override
  String get shareFailed => 'We couldn\'t share the trip. Try again.';

  @override
  String get navProfile => 'Profile';

  @override
  String get supportTitle => 'Support';

  @override
  String get supportNew => 'New ticket';

  @override
  String get supportMine => 'My tickets';

  @override
  String get supportEmpty =>
      'No tickets yet. If something goes wrong, tell us here.';

  @override
  String get supportLoadFailed =>
      'We couldn\'t load your tickets. Check your connection and try again.';

  @override
  String get supportAbout => 'What is it about?';

  @override
  String get catSafety => 'Safety';

  @override
  String get catDriver => 'Driver';

  @override
  String get catVehicle => 'Vehicle';

  @override
  String get catWrongCharge => 'Wrong charge';

  @override
  String get catPayment => 'Payment';

  @override
  String get catLostItem => 'Lost item';

  @override
  String get catAccount => 'Account';

  @override
  String get catPhoneChange => 'Change my phone number';

  @override
  String get catOther => 'Other';

  @override
  String get supportSubject => 'Subject';

  @override
  String get supportMessage => 'Message';

  @override
  String get supportRide => 'About a ride';

  @override
  String get supportAddPhoto => 'Add a photo';

  @override
  String supportPhotos(int count) {
    return '$count of 5 photos';
  }

  @override
  String get supportSend => 'Send';

  @override
  String get supportSent => 'Sent. We\'ll reply here.';

  @override
  String get supportNeedFields => 'Choose a topic and write a short message.';

  @override
  String get supportStatusOpen => 'Open';

  @override
  String get supportStatusProgress => 'Being looked at';

  @override
  String get supportStatusWaiting => 'Waiting for you';

  @override
  String get supportStatusResolved => 'Resolved';

  @override
  String get supportStatusClosed => 'Closed';

  @override
  String get supportReplyHint => 'Write a reply';

  @override
  String get supportReply => 'Send reply';

  @override
  String get supportFromStaff => 'Support';

  @override
  String get supportFromYou => 'You';

  @override
  String get supportReplyFailed => 'We couldn\'t send that. Try again.';

  @override
  String get supportPhotoFailed => 'That photo didn\'t upload. Try again.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileEmailAdd => 'Add';

  @override
  String get profileEmailSave => 'Save email';

  @override
  String get profileEmailInvalid => 'Enter a valid email address.';

  @override
  String get profileSavedPlaces => 'Saved places';

  @override
  String get profileSavedPlacesEmpty => 'No saved places yet.';

  @override
  String get profileDevices => 'Signed-in devices';

  @override
  String get profileSignOutOthers => 'Sign out everywhere else';

  @override
  String get profileThisDevice => 'This phone';

  @override
  String profileDeviceLastUsed(Object when) {
    return 'Last used $when';
  }

  @override
  String get profileSignOutDevice => 'Sign out';

  @override
  String get profileTerms => 'Terms';

  @override
  String get profilePrivacy => 'Privacy notice';

  @override
  String get profileVersion => 'App version';

  @override
  String get profileSignOut => 'Sign out';

  @override
  String get profileDelete => 'Delete my account';

  @override
  String get profileDeleteTitle => 'Delete your account?';

  @override
  String get profileDeleteBody =>
      'Our team will handle any money left in your wallet and anonymise your ride records. This can\'t be undone.';

  @override
  String get profileDeleteConfirmLabel => 'Delete';

  @override
  String get profileDeleteRequested =>
      'We\'ve received your request. We\'ll be in touch about your wallet.';

  @override
  String get profileLoadFailed =>
      'We couldn\'t load your profile. Check your connection and try again.';

  @override
  String get profileChangePhone =>
      'To change your phone number, contact support.';

  @override
  String get profileRemovePlace => 'Remove place';
}
