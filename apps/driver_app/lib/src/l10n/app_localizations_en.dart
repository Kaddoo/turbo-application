// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

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
  String get problemTopupRange =>
      'That amount isn\'t allowed. Choose a different amount.';

  @override
  String get problemPaymentProvider =>
      'The payment service isn\'t answering. Try again in a moment.';

  @override
  String get problemInsufficient =>
      'Your wallet doesn\'t have enough for this ride. Top up and try again.';

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
  String get termsReadTerms => 'Read the full terms';

  @override
  String get termsReadPrivacy => 'Read the privacy notice';

  @override
  String get termsLoadFailed =>
      'We couldn\'t load the terms. Check your connection and try again.';

  @override
  String get navProfile => 'Profile';

  @override
  String get welcomeTagline => 'Drive for the campus, one ride at a time';

  @override
  String welcomeAudience(String appName) {
    return 'For $appName drivers';
  }

  @override
  String termsBulletRules(String appName) {
    return '$appName assigns rides to you automatically. You accept or decline each one.';
  }

  @override
  String get termsBulletData =>
      'Your position is shared only while you are on duty. Your trips, shifts and attendance are recorded for payroll.';

  @override
  String get termsWhyLocationTitle => 'Why we need your location all the time';

  @override
  String get termsWhyLocation =>
      'So rides can be assigned to the nearest driver and students can see you arrive, even when the screen is locked. Sharing stops when you go off duty.';

  @override
  String get problemNotADriver =>
      'This number isn\'t registered as a driver. Contact your supervisor.';

  @override
  String get problemDocumentExpired =>
      'A document has expired. Contact your supervisor.';

  @override
  String get problemHasActiveRide => 'You can\'t go off duty during a ride.';

  @override
  String get problemPinLocked => 'Too many tries. Call your supervisor.';

  @override
  String get problemInvalidPin =>
      'That PIN isn\'t right. Ask the student again.';

  @override
  String get problemNoShowEarly =>
      'It\'s too early to mark the student as not here.';

  @override
  String get suspendedTitle => 'Your account is suspended';

  @override
  String get suspendedBody => 'Contact your supervisor to find out why.';

  @override
  String homeGreeting(String name) {
    return 'Hello, $name';
  }

  @override
  String homeVehicle(String colour, String make, String model, String plate) {
    return '$colour $make $model · $plate';
  }

  @override
  String get homeNoVehicle =>
      'No vehicle assigned yet. Contact your supervisor.';

  @override
  String get homeOffDuty => 'Off duty';

  @override
  String get homeGoOnDuty => 'Go on duty';

  @override
  String get homeGoOffDuty => 'Go off duty';

  @override
  String get homeOnDutyWaiting => 'On duty. Waiting for a ride.';

  @override
  String homeOnDutyFor(String time) {
    return 'On duty for $time';
  }

  @override
  String get homeOffDutyConfirmTitle => 'Go off duty?';

  @override
  String get homeOffDutyConfirmBody =>
      'You won\'t get new rides until you go on duty again.';

  @override
  String get homeOffDutyConfirm => 'Go off duty';

  @override
  String get homeStayOn => 'Stay on duty';

  @override
  String get readinessTitle => 'Before you go on duty';

  @override
  String get readinessLocation => 'Location set to Always';

  @override
  String get readinessBattery => 'Battery above 20% or charging';

  @override
  String get readinessInternet => 'Internet connected';

  @override
  String get readinessNotifications => 'Notifications on';

  @override
  String get readinessDocuments => 'Documents checked when you go on duty';

  @override
  String get readinessFix => 'Fix';

  @override
  String get readinessOk => 'Ready';

  @override
  String get readinessProblem => 'Needs attention';

  @override
  String get readinessLocationFix => 'Allow location always';

  @override
  String get readinessOpenSettings => 'Open Settings';

  @override
  String get dutyFailed =>
      'We couldn\'t change your duty. Check your connection and try again.';

  @override
  String get bannerNotSharing =>
      'Your location isn\'t being shared. Open the app.';

  @override
  String get bannerOffline =>
      'You\'re offline. You won\'t get rides until you\'re back online.';

  @override
  String get bannerServer =>
      'We can\'t reach the server. Your position is kept and will be sent.';

  @override
  String get indicatorGps => 'GPS';

  @override
  String get indicatorConnection => 'Connection';

  @override
  String indicatorBattery(int percent) {
    return 'Battery $percent%';
  }

  @override
  String notificationTitle(String appName) {
    return '$appName';
  }

  @override
  String notificationText(String appName) {
    return '$appName is sharing your location while you are on duty.';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navTrips => 'Trips';

  @override
  String get navMe => 'Me';

  @override
  String get shareStopped => 'Location sharing stopped';

  @override
  String get tripsTitle => 'Trips';

  @override
  String get tripsEmpty => 'No trips yet.';

  @override
  String get tripsLoadFailed =>
      'We couldn\'t load your trips. Check your connection and try again.';

  @override
  String get rideStatusSearching => 'Finding a driver';

  @override
  String get rideStatusAssigned => 'Assigned';

  @override
  String get rideStatusArrived => 'Arrived';

  @override
  String get rideStatusInProgress => 'On the way';

  @override
  String get rideStatusCompleted => 'Completed';

  @override
  String get rideStatusCancelled => 'Cancelled';

  @override
  String get meTitle => 'Me';

  @override
  String get meVehicle => 'Vehicle';

  @override
  String get meSignOut => 'Sign out';

  @override
  String get meVersion => 'App version';

  @override
  String get meTerms => 'Terms';

  @override
  String get mePrivacy => 'Privacy notice';

  @override
  String get meDevices => 'Signed-in devices';

  @override
  String get meThisDevice => 'This phone';

  @override
  String get meSignOutDevice => 'Sign out';

  @override
  String get meSignOutOthers => 'Sign out everywhere else';

  @override
  String meLastUsed(String when) {
    return 'Last used $when';
  }

  @override
  String get meLoadFailed =>
      'We couldn\'t load this. Check your connection and try again.';

  @override
  String get meShifts => 'Shifts';

  @override
  String get meAttendance => 'Attendance';

  @override
  String get meSalary => 'Salary history';

  @override
  String get meHelp => 'Help and support';
}
