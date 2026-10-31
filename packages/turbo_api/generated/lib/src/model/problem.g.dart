// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'problem.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ProblemCWProxy {
  Problem type(String type);

  Problem title(String title);

  Problem status(int status);

  Problem detail(String? detail);

  Problem instance(String? instance);

  Problem code(ProblemCode code);

  Problem errors(List<ProblemErrorsInner>? errors);

  Problem retryAfterSeconds(int? retryAfterSeconds);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Problem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Problem(...).copyWith(id: 12, name: "My name")
  /// ````
  Problem call({
    String type,
    String title,
    int status,
    String? detail,
    String? instance,
    ProblemCode code,
    List<ProblemErrorsInner>? errors,
    int? retryAfterSeconds,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfProblem.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfProblem.copyWith.fieldName(...)`
class _$ProblemCWProxyImpl implements _$ProblemCWProxy {
  const _$ProblemCWProxyImpl(this._value);

  final Problem _value;

  @override
  Problem type(String type) => this(type: type);

  @override
  Problem title(String title) => this(title: title);

  @override
  Problem status(int status) => this(status: status);

  @override
  Problem detail(String? detail) => this(detail: detail);

  @override
  Problem instance(String? instance) => this(instance: instance);

  @override
  Problem code(ProblemCode code) => this(code: code);

  @override
  Problem errors(List<ProblemErrorsInner>? errors) => this(errors: errors);

  @override
  Problem retryAfterSeconds(int? retryAfterSeconds) =>
      this(retryAfterSeconds: retryAfterSeconds);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Problem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Problem(...).copyWith(id: 12, name: "My name")
  /// ````
  Problem call({
    Object? type = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? detail = const $CopyWithPlaceholder(),
    Object? instance = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
    Object? errors = const $CopyWithPlaceholder(),
    Object? retryAfterSeconds = const $CopyWithPlaceholder(),
  }) {
    return Problem(
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as String,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as int,
      detail: detail == const $CopyWithPlaceholder()
          ? _value.detail
          // ignore: cast_nullable_to_non_nullable
          : detail as String?,
      instance: instance == const $CopyWithPlaceholder()
          ? _value.instance
          // ignore: cast_nullable_to_non_nullable
          : instance as String?,
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as ProblemCode,
      errors: errors == const $CopyWithPlaceholder()
          ? _value.errors
          // ignore: cast_nullable_to_non_nullable
          : errors as List<ProblemErrorsInner>?,
      retryAfterSeconds: retryAfterSeconds == const $CopyWithPlaceholder()
          ? _value.retryAfterSeconds
          // ignore: cast_nullable_to_non_nullable
          : retryAfterSeconds as int?,
    );
  }
}

extension $ProblemCopyWith on Problem {
  /// Returns a callable class that can be used as follows: `instanceOfProblem.copyWith(...)` or like so:`instanceOfProblem.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ProblemCWProxy get copyWith => _$ProblemCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Problem _$ProblemFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('Problem', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['type', 'title', 'status', 'code']);
  final val = Problem(
    type: $checkedConvert('type', (v) => v as String? ?? 'about:blank'),
    title: $checkedConvert('title', (v) => v as String),
    status: $checkedConvert('status', (v) => (v as num).toInt()),
    detail: $checkedConvert('detail', (v) => v as String?),
    instance: $checkedConvert('instance', (v) => v as String?),
    code: $checkedConvert('code', (v) => $enumDecode(_$ProblemCodeEnumMap, v)),
    errors: $checkedConvert(
      'errors',
      (v) => (v as List<dynamic>?)
          ?.map((e) => ProblemErrorsInner.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    retryAfterSeconds: $checkedConvert(
      'retryAfterSeconds',
      (v) => (v as num?)?.toInt(),
    ),
  );
  return val;
});

Map<String, dynamic> _$ProblemToJson(Problem instance) => <String, dynamic>{
  'type': instance.type,
  'title': instance.title,
  'status': instance.status,
  'detail': ?instance.detail,
  'instance': ?instance.instance,
  'code': _$ProblemCodeEnumMap[instance.code]!,
  'errors': ?instance.errors?.map((e) => e.toJson()).toList(),
  'retryAfterSeconds': ?instance.retryAfterSeconds,
};

const _$ProblemCodeEnumMap = {
  ProblemCode.validationFailed: 'validation_failed',
  ProblemCode.unauthenticated: 'unauthenticated',
  ProblemCode.forbidden: 'forbidden',
  ProblemCode.notFound: 'not_found',
  ProblemCode.conflict: 'conflict',
  ProblemCode.rateLimited: 'rate_limited',
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
};
