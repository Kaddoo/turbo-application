// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ineligibility_reason.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$IneligibilityReasonCWProxy {
  IneligibilityReason code(ProblemCode code);

  IneligibilityReason message(String message);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `IneligibilityReason(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// IneligibilityReason(...).copyWith(id: 12, name: "My name")
  /// ````
  IneligibilityReason call({ProblemCode code, String message});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfIneligibilityReason.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfIneligibilityReason.copyWith.fieldName(...)`
class _$IneligibilityReasonCWProxyImpl implements _$IneligibilityReasonCWProxy {
  const _$IneligibilityReasonCWProxyImpl(this._value);

  final IneligibilityReason _value;

  @override
  IneligibilityReason code(ProblemCode code) => this(code: code);

  @override
  IneligibilityReason message(String message) => this(message: message);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `IneligibilityReason(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// IneligibilityReason(...).copyWith(id: 12, name: "My name")
  /// ````
  IneligibilityReason call({
    Object? code = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
  }) {
    return IneligibilityReason(
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as ProblemCode,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String,
    );
  }
}

extension $IneligibilityReasonCopyWith on IneligibilityReason {
  /// Returns a callable class that can be used as follows: `instanceOfIneligibilityReason.copyWith(...)` or like so:`instanceOfIneligibilityReason.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$IneligibilityReasonCWProxy get copyWith =>
      _$IneligibilityReasonCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IneligibilityReason _$IneligibilityReasonFromJson(Map<String, dynamic> json) =>
    $checkedCreate('IneligibilityReason', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['code', 'message']);
      final val = IneligibilityReason(
        code: $checkedConvert(
          'code',
          (v) => $enumDecode(_$ProblemCodeEnumMap, v),
        ),
        message: $checkedConvert('message', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$IneligibilityReasonToJson(
  IneligibilityReason instance,
) => <String, dynamic>{
  'code': _$ProblemCodeEnumMap[instance.code]!,
  'message': instance.message,
};

const _$ProblemCodeEnumMap = {
  ProblemCode.validationFailed: 'validation_failed',
  ProblemCode.unauthenticated: 'unauthenticated',
  ProblemCode.forbidden: 'forbidden',
  ProblemCode.notFound: 'not_found',
  ProblemCode.conflict: 'conflict',
  ProblemCode.rateLimited: 'rate_limited',
  ProblemCode.networkUnknown: 'network_unknown',
  ProblemCode.idempotencyKeyReused: 'idempotency_key_reused',
  ProblemCode.otpInvalid: 'otp_invalid',
  ProblemCode.otpExpired: 'otp_expired',
  ProblemCode.otpRateLimited: 'otp_rate_limited',
  ProblemCode.accountSuspended: 'account_suspended',
  ProblemCode.invalidCredentials: 'invalid_credentials',
  ProblemCode.mfaRequired: 'mfa_required',
  ProblemCode.verificationRequired: 'verification_required',
  ProblemCode.verificationNotResubmittable: 'verification_not_resubmittable',
  ProblemCode.uploadExpired: 'upload_expired',
  ProblemCode.outsideServiceArea: 'outside_service_area',
  ProblemCode.routeTooLong: 'route_too_long',
  ProblemCode.routeUnavailable: 'route_unavailable',
  ProblemCode.noDriversOnDuty: 'no_drivers_on_duty',
  ProblemCode.quoteExpired: 'quote_expired',
  ProblemCode.quoteIneligible: 'quote_ineligible',
  ProblemCode.insufficientBalance: 'insufficient_balance',
  ProblemCode.activeRideExists: 'active_ride_exists',
  ProblemCode.rideNotCancellable: 'ride_not_cancellable',
  ProblemCode.invalidRideState: 'invalid_ride_state',
  ProblemCode.invalidPin: 'invalid_pin',
  ProblemCode.pinLocked: 'pin_locked',
  ProblemCode.driverHasActiveRide: 'driver_has_active_ride',
  ProblemCode.driverNotAssigned: 'driver_not_assigned',
  ProblemCode.topupAmountOutOfRange: 'topup_amount_out_of_range',
  ProblemCode.paymentProviderError: 'payment_provider_error',
  ProblemCode.refundExceedsCharge: 'refund_exceeds_charge',
  ProblemCode.shiftOverlap: 'shift_overlap',
  ProblemCode.smsBudgetExceeded: 'sms_budget_exceeded',
  ProblemCode.termsNotAccepted: 'terms_not_accepted',
  ProblemCode.duplicateIdentity: 'duplicate_identity',
  ProblemCode.upgradeRequired: 'upgrade_required',
  ProblemCode.documentExpired: 'document_expired',
  ProblemCode.bookingsPaused: 'bookings_paused',
  ProblemCode.selfAdjustmentForbidden: 'self_adjustment_forbidden',
  ProblemCode.approvalByRequesterForbidden: 'approval_by_requester_forbidden',
  ProblemCode.invalidToken: 'invalid_token',
  ProblemCode.accountLocked: 'account_locked',
  ProblemCode.mfaEnrollmentRequired: 'mfa_enrollment_required',
  ProblemCode.noShowTooEarly: 'no_show_too_early',
  ProblemCode.accountOwes: 'account_owes',
  ProblemCode.verificationClaimed: 'verification_claimed',
  ProblemCode.duplicatePhone: 'duplicate_phone',
  ProblemCode.duplicateEmail: 'duplicate_email',
  ProblemCode.duplicatePlate: 'duplicate_plate',
  ProblemCode.vehicleAlreadyAssigned: 'vehicle_already_assigned',
  ProblemCode.verificationNotPending: 'verification_not_pending',
  ProblemCode.ticketStateInvalid: 'ticket_state_invalid',
  ProblemCode.topupNotResolvable: 'topup_not_resolvable',
  ProblemCode.incidentStateInvalid: 'incident_state_invalid',
  ProblemCode.serviceBusy: 'service_busy',
  ProblemCode.linkExpired: 'link_expired',
  ProblemCode.linkInvalid: 'link_invalid',
};
