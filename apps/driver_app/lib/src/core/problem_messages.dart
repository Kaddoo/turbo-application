import 'package:turbo_api/turbo_api.dart';

import '../l10n/app_localizations.dart';

/// The one place that turns a problem `code` into words for a person.
/// Never show the server's message or the raw code.
String problemMessage(
  AppLocalizations l10n,
  ApiProblem p, {
  int maxTripKm = 18,
}) {
  final retry = p.retryAfter?.inSeconds;
  if (p.code == ApiProblem.network) return l10n.problemNetwork;
  if (p.isRateLimited && p.code != ProblemCode.otpRateLimited.value) {
    return retry == null
        ? l10n.problemRateLimited
        : l10n.problemRateLimitedWait(retry);
  }
  final code = ProblemCode.values.where((c) => c.value == p.code).firstOrNull;
  return switch (code) {
    ProblemCode.otpInvalid => l10n.problemOtpInvalid,
    ProblemCode.otpExpired => l10n.problemOtpExpired,
    ProblemCode.otpRateLimited => l10n.problemOtpRateLimited,
    ProblemCode.smsBudgetExceeded => l10n.problemSmsBudget,
    ProblemCode.serviceBusy => retry == null
        ? l10n.problemServiceBusy
        : l10n.problemServiceBusyWait(retry),
    ProblemCode.accountSuspended => l10n.problemAccountSuspended,
    ProblemCode.upgradeRequired => l10n.problemUpgradeRequired,
    ProblemCode.duplicateIdentity => l10n.problemDuplicateIdentity,
    ProblemCode.verificationRequired => l10n.problemVerificationRequired,
    ProblemCode.verificationNotResubmittable =>
      l10n.problemVerificationNotResubmittable,
    ProblemCode.uploadExpired => l10n.problemUploadExpired,
    ProblemCode.validationFailed => l10n.problemValidation,
    ProblemCode.noDriversOnDuty => l10n.problemNoDrivers,
    ProblemCode.outsideServiceArea => l10n.problemOutsideArea,
    ProblemCode.routeTooLong => l10n.problemRouteTooLong(maxTripKm),
    ProblemCode.routeUnavailable => l10n.problemRouteUnavailable,
    ProblemCode.bookingsPaused => l10n.problemBookingsPaused,
    ProblemCode.accountOwes => l10n.problemAccountOwes,
    ProblemCode.activeRideExists => l10n.problemActiveRide,
    ProblemCode.quoteExpired => l10n.problemQuoteExpired,
    ProblemCode.documentExpired => l10n.problemDocumentExpired,
    ProblemCode.driverHasActiveRide => l10n.problemHasActiveRide,
    ProblemCode.pinLocked => l10n.problemPinLocked,
    ProblemCode.invalidPin => l10n.problemInvalidPin,
    ProblemCode.noShowTooEarly => l10n.problemNoShowEarly,
    ProblemCode.forbidden => l10n.problemNotADriver,
    _ => l10n.problemGeneric,
  };
}
