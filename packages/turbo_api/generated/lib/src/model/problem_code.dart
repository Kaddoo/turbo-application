//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

/// Stable machine-readable code. Clients switch on this, never on `title` or `detail`.
enum ProblemCode {
  @JsonValue(r'validation_failed')
  validationFailed(r'validation_failed'),
  @JsonValue(r'unauthenticated')
  unauthenticated(r'unauthenticated'),
  @JsonValue(r'forbidden')
  forbidden(r'forbidden'),
  @JsonValue(r'not_found')
  notFound(r'not_found'),
  @JsonValue(r'conflict')
  conflict(r'conflict'),
  @JsonValue(r'rate_limited')
  rateLimited(r'rate_limited'),
  @JsonValue(r'idempotency_key_reused')
  idempotencyKeyReused(r'idempotency_key_reused'),
  @JsonValue(r'otp_invalid')
  otpInvalid(r'otp_invalid'),
  @JsonValue(r'otp_expired')
  otpExpired(r'otp_expired'),
  @JsonValue(r'otp_rate_limited')
  otpRateLimited(r'otp_rate_limited'),
  @JsonValue(r'account_suspended')
  accountSuspended(r'account_suspended'),
  @JsonValue(r'invalid_credentials')
  invalidCredentials(r'invalid_credentials'),
  @JsonValue(r'mfa_required')
  mfaRequired(r'mfa_required'),
  @JsonValue(r'verification_required')
  verificationRequired(r'verification_required'),
  @JsonValue(r'verification_not_resubmittable')
  verificationNotResubmittable(r'verification_not_resubmittable'),
  @JsonValue(r'upload_expired')
  uploadExpired(r'upload_expired'),
  @JsonValue(r'outside_service_area')
  outsideServiceArea(r'outside_service_area'),
  @JsonValue(r'route_too_long')
  routeTooLong(r'route_too_long'),
  @JsonValue(r'route_unavailable')
  routeUnavailable(r'route_unavailable'),
  @JsonValue(r'no_drivers_on_duty')
  noDriversOnDuty(r'no_drivers_on_duty'),
  @JsonValue(r'quote_expired')
  quoteExpired(r'quote_expired'),
  @JsonValue(r'quote_ineligible')
  quoteIneligible(r'quote_ineligible'),
  @JsonValue(r'insufficient_balance')
  insufficientBalance(r'insufficient_balance'),
  @JsonValue(r'active_ride_exists')
  activeRideExists(r'active_ride_exists'),
  @JsonValue(r'ride_not_cancellable')
  rideNotCancellable(r'ride_not_cancellable'),
  @JsonValue(r'invalid_ride_state')
  invalidRideState(r'invalid_ride_state'),
  @JsonValue(r'invalid_pin')
  invalidPin(r'invalid_pin'),
  @JsonValue(r'pin_locked')
  pinLocked(r'pin_locked'),
  @JsonValue(r'driver_has_active_ride')
  driverHasActiveRide(r'driver_has_active_ride'),
  @JsonValue(r'driver_not_assigned')
  driverNotAssigned(r'driver_not_assigned'),
  @JsonValue(r'topup_amount_out_of_range')
  topupAmountOutOfRange(r'topup_amount_out_of_range'),
  @JsonValue(r'payment_provider_error')
  paymentProviderError(r'payment_provider_error'),
  @JsonValue(r'refund_exceeds_charge')
  refundExceedsCharge(r'refund_exceeds_charge'),
  @JsonValue(r'shift_overlap')
  shiftOverlap(r'shift_overlap'),
  @JsonValue(r'sms_budget_exceeded')
  smsBudgetExceeded(r'sms_budget_exceeded'),
  @JsonValue(r'terms_not_accepted')
  termsNotAccepted(r'terms_not_accepted'),
  @JsonValue(r'duplicate_identity')
  duplicateIdentity(r'duplicate_identity'),
  @JsonValue(r'upgrade_required')
  upgradeRequired(r'upgrade_required'),
  @JsonValue(r'document_expired')
  documentExpired(r'document_expired'),
  @JsonValue(r'bookings_paused')
  bookingsPaused(r'bookings_paused'),
  @JsonValue(r'self_adjustment_forbidden')
  selfAdjustmentForbidden(r'self_adjustment_forbidden'),
  @JsonValue(r'approval_by_requester_forbidden')
  approvalByRequesterForbidden(r'approval_by_requester_forbidden'),
  @JsonValue(r'invalid_token')
  invalidToken(r'invalid_token'),
  @JsonValue(r'account_locked')
  accountLocked(r'account_locked'),
  @JsonValue(r'mfa_enrollment_required')
  mfaEnrollmentRequired(r'mfa_enrollment_required'),
  @JsonValue(r'no_show_too_early')
  noShowTooEarly(r'no_show_too_early'),
  @JsonValue(r'account_owes')
  accountOwes(r'account_owes'),
  @JsonValue(r'verification_claimed')
  verificationClaimed(r'verification_claimed'),
  @JsonValue(r'duplicate_phone')
  duplicatePhone(r'duplicate_phone'),
  @JsonValue(r'duplicate_email')
  duplicateEmail(r'duplicate_email'),
  @JsonValue(r'duplicate_plate')
  duplicatePlate(r'duplicate_plate'),
  @JsonValue(r'vehicle_already_assigned')
  vehicleAlreadyAssigned(r'vehicle_already_assigned'),
  @JsonValue(r'verification_not_pending')
  verificationNotPending(r'verification_not_pending'),
  @JsonValue(r'ticket_state_invalid')
  ticketStateInvalid(r'ticket_state_invalid'),
  @JsonValue(r'topup_not_resolvable')
  topupNotResolvable(r'topup_not_resolvable'),
  @JsonValue(r'incident_state_invalid')
  incidentStateInvalid(r'incident_state_invalid'),
  @JsonValue(r'service_busy')
  serviceBusy(r'service_busy'),
  @JsonValue(r'link_expired')
  linkExpired(r'link_expired'),
  @JsonValue(r'link_invalid')
  linkInvalid(r'link_invalid');

  const ProblemCode(this.value);

  final String value;

  @override
  String toString() => value;
}
