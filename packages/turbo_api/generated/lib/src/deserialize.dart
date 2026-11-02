import 'package:turbo_api_generated/src/model/account_status_update.dart';
import 'package:turbo_api_generated/src/model/adjustment_decision.dart';
import 'package:turbo_api_generated/src/model/adjustment_request.dart';
import 'package:turbo_api_generated/src/model/adjustment_request_list.dart';
import 'package:turbo_api_generated/src/model/admin_cancel_request.dart';
import 'package:turbo_api_generated/src/model/admin_complete_request.dart';
import 'package:turbo_api_generated/src/model/admin_login.dart';
import 'package:turbo_api_generated/src/model/admin_ride_detail.dart';
import 'package:turbo_api_generated/src/model/admin_ride_summary.dart';
import 'package:turbo_api_generated/src/model/admin_ride_summary_list.dart';
import 'package:turbo_api_generated/src/model/announcement.dart';
import 'package:turbo_api_generated/src/model/announcement_create.dart';
import 'package:turbo_api_generated/src/model/app_config.dart';
import 'package:turbo_api_generated/src/model/app_config_maintenance.dart';
import 'package:turbo_api_generated/src/model/app_config_min_version.dart';
import 'package:turbo_api_generated/src/model/attendance_correction.dart';
import 'package:turbo_api_generated/src/model/attendance_record.dart';
import 'package:turbo_api_generated/src/model/attendance_record_list.dart';
import 'package:turbo_api_generated/src/model/audit_entry.dart';
import 'package:turbo_api_generated/src/model/audit_entry_list.dart';
import 'package:turbo_api_generated/src/model/auth_tokens.dart';
import 'package:turbo_api_generated/src/model/cancel_request.dart';
import 'package:turbo_api_generated/src/model/cancellation.dart';
import 'package:turbo_api_generated/src/model/decline_request.dart';
import 'package:turbo_api_generated/src/model/deletion_request.dart';
import 'package:turbo_api_generated/src/model/destination_change.dart';
import 'package:turbo_api_generated/src/model/destination_change_confirm.dart';
import 'package:turbo_api_generated/src/model/device_registration.dart';
import 'package:turbo_api_generated/src/model/driver_create.dart';
import 'package:turbo_api_generated/src/model/driver_detail.dart';
import 'package:turbo_api_generated/src/model/driver_detail_list.dart';
import 'package:turbo_api_generated/src/model/driver_document.dart';
import 'package:turbo_api_generated/src/model/driver_document_create.dart';
import 'package:turbo_api_generated/src/model/driver_document_expiry.dart';
import 'package:turbo_api_generated/src/model/driver_document_expiry_list.dart';
import 'package:turbo_api_generated/src/model/driver_document_status.dart';
import 'package:turbo_api_generated/src/model/driver_location.dart';
import 'package:turbo_api_generated/src/model/driver_location_point.dart';
import 'package:turbo_api_generated/src/model/driver_profile.dart';
import 'package:turbo_api_generated/src/model/driver_public.dart';
import 'package:turbo_api_generated/src/model/driver_ride.dart';
import 'package:turbo_api_generated/src/model/driver_ride_list.dart';
import 'package:turbo_api_generated/src/model/driver_ride_student.dart';
import 'package:turbo_api_generated/src/model/driver_update.dart';
import 'package:turbo_api_generated/src/model/duty_update.dart';
import 'package:turbo_api_generated/src/model/fare_band.dart';
import 'package:turbo_api_generated/src/model/fare_band_set.dart';
import 'package:turbo_api_generated/src/model/geo_json_polygon.dart';
import 'package:turbo_api_generated/src/model/geo_point.dart';
import 'package:turbo_api_generated/src/model/health.dart';
import 'package:turbo_api_generated/src/model/incident.dart';
import 'package:turbo_api_generated/src/model/incident_list.dart';
import 'package:turbo_api_generated/src/model/incident_update.dart';
import 'package:turbo_api_generated/src/model/ineligibility_reason.dart';
import 'package:turbo_api_generated/src/model/invite_accept.dart';
import 'package:turbo_api_generated/src/model/legal_versions.dart';
import 'package:turbo_api_generated/src/model/live_rides.dart';
import 'package:turbo_api_generated/src/model/live_rides_on_duty_drivers_inner.dart';
import 'package:turbo_api_generated/src/model/live_rides_rides_inner.dart';
import 'package:turbo_api_generated/src/model/location.dart';
import 'package:turbo_api_generated/src/model/location_batch.dart';
import 'package:turbo_api_generated/src/model/mfa_confirm.dart';
import 'package:turbo_api_generated/src/model/mfa_enrollment.dart';
import 'package:turbo_api_generated/src/model/operating_window.dart';
import 'package:turbo_api_generated/src/model/otp_challenge.dart';
import 'package:turbo_api_generated/src/model/otp_request.dart';
import 'package:turbo_api_generated/src/model/otp_verify.dart';
import 'package:turbo_api_generated/src/model/page_info.dart';
import 'package:turbo_api_generated/src/model/password_change.dart';
import 'package:turbo_api_generated/src/model/password_forgot.dart';
import 'package:turbo_api_generated/src/model/password_reset.dart';
import 'package:turbo_api_generated/src/model/phone_change.dart';
import 'package:turbo_api_generated/src/model/pickup_point.dart';
import 'package:turbo_api_generated/src/model/pickup_point_write.dart';
import 'package:turbo_api_generated/src/model/problem.dart';
import 'package:turbo_api_generated/src/model/problem_errors_inner.dart';
import 'package:turbo_api_generated/src/model/public_trip_share.dart';
import 'package:turbo_api_generated/src/model/quick_message.dart';
import 'package:turbo_api_generated/src/model/quick_message_list.dart';
import 'package:turbo_api_generated/src/model/quick_message_send.dart';
import 'package:turbo_api_generated/src/model/quote.dart';
import 'package:turbo_api_generated/src/model/quote_request.dart';
import 'package:turbo_api_generated/src/model/quote_wallet.dart';
import 'package:turbo_api_generated/src/model/rating_create.dart';
import 'package:turbo_api_generated/src/model/reassign_request.dart';
import 'package:turbo_api_generated/src/model/receipt.dart';
import 'package:turbo_api_generated/src/model/receipt_line.dart';
import 'package:turbo_api_generated/src/model/reconciliation_item.dart';
import 'package:turbo_api_generated/src/model/reconciliation_report.dart';
import 'package:turbo_api_generated/src/model/reconciliation_report_list.dart';
import 'package:turbo_api_generated/src/model/reconciliation_run.dart';
import 'package:turbo_api_generated/src/model/refresh_request.dart';
import 'package:turbo_api_generated/src/model/refund_request.dart';
import 'package:turbo_api_generated/src/model/ride.dart';
import 'package:turbo_api_generated/src/model/ride_create.dart';
import 'package:turbo_api_generated/src/model/ride_event.dart';
import 'package:turbo_api_generated/src/model/ride_list.dart';
import 'package:turbo_api_generated/src/model/ride_payment.dart';
import 'package:turbo_api_generated/src/model/salary_payment.dart';
import 'package:turbo_api_generated/src/model/salary_payment_create.dart';
import 'package:turbo_api_generated/src/model/salary_payment_list.dart';
import 'package:turbo_api_generated/src/model/salary_profile.dart';
import 'package:turbo_api_generated/src/model/salary_profile_write.dart';
import 'package:turbo_api_generated/src/model/saved_place.dart';
import 'package:turbo_api_generated/src/model/saved_place_collection.dart';
import 'package:turbo_api_generated/src/model/saved_place_create.dart';
import 'package:turbo_api_generated/src/model/service_area.dart';
import 'package:turbo_api_generated/src/model/service_area_write.dart';
import 'package:turbo_api_generated/src/model/session.dart';
import 'package:turbo_api_generated/src/model/session_list.dart';
import 'package:turbo_api_generated/src/model/session_user.dart';
import 'package:turbo_api_generated/src/model/settings.dart';
import 'package:turbo_api_generated/src/model/share_create.dart';
import 'package:turbo_api_generated/src/model/shift.dart';
import 'package:turbo_api_generated/src/model/shift_create.dart';
import 'package:turbo_api_generated/src/model/shift_list.dart';
import 'package:turbo_api_generated/src/model/sos_request.dart';
import 'package:turbo_api_generated/src/model/staff_create.dart';
import 'package:turbo_api_generated/src/model/staff_update.dart';
import 'package:turbo_api_generated/src/model/staff_user.dart';
import 'package:turbo_api_generated/src/model/staff_user_list.dart';
import 'package:turbo_api_generated/src/model/start_request.dart';
import 'package:turbo_api_generated/src/model/student.dart';
import 'package:turbo_api_generated/src/model/student_detail.dart';
import 'package:turbo_api_generated/src/model/student_summary.dart';
import 'package:turbo_api_generated/src/model/student_summary_list.dart';
import 'package:turbo_api_generated/src/model/student_update.dart';
import 'package:turbo_api_generated/src/model/support_message.dart';
import 'package:turbo_api_generated/src/model/support_message_create.dart';
import 'package:turbo_api_generated/src/model/support_ticket.dart';
import 'package:turbo_api_generated/src/model/support_ticket_create.dart';
import 'package:turbo_api_generated/src/model/support_ticket_list.dart';
import 'package:turbo_api_generated/src/model/terms_acceptance.dart';
import 'package:turbo_api_generated/src/model/ticket_update.dart';
import 'package:turbo_api_generated/src/model/topup.dart';
import 'package:turbo_api_generated/src/model/topup_checkout.dart';
import 'package:turbo_api_generated/src/model/topup_create.dart';
import 'package:turbo_api_generated/src/model/topup_list.dart';
import 'package:turbo_api_generated/src/model/topup_resolve.dart';
import 'package:turbo_api_generated/src/model/tracking.dart';
import 'package:turbo_api_generated/src/model/trip_location.dart';
import 'package:turbo_api_generated/src/model/trip_share.dart';
import 'package:turbo_api_generated/src/model/trusted_contact.dart';
import 'package:turbo_api_generated/src/model/trusted_contact_collection.dart';
import 'package:turbo_api_generated/src/model/trusted_contact_create.dart';
import 'package:turbo_api_generated/src/model/upload_request.dart';
import 'package:turbo_api_generated/src/model/upload_slot.dart';
import 'package:turbo_api_generated/src/model/vehicle.dart';
import 'package:turbo_api_generated/src/model/vehicle_list.dart';
import 'package:turbo_api_generated/src/model/vehicle_public.dart';
import 'package:turbo_api_generated/src/model/vehicle_write.dart';
import 'package:turbo_api_generated/src/model/verification_decision.dart';
import 'package:turbo_api_generated/src/model/verification_decision_record.dart';
import 'package:turbo_api_generated/src/model/verification_detail.dart';
import 'package:turbo_api_generated/src/model/verification_document.dart';
import 'package:turbo_api_generated/src/model/verification_state.dart';
import 'package:turbo_api_generated/src/model/verification_submission.dart';
import 'package:turbo_api_generated/src/model/verification_summary.dart';
import 'package:turbo_api_generated/src/model/verification_summary_list.dart';
import 'package:turbo_api_generated/src/model/verification_summary_student.dart';
import 'package:turbo_api_generated/src/model/wallet.dart';
import 'package:turbo_api_generated/src/model/wallet_adjustment.dart';
import 'package:turbo_api_generated/src/model/wallet_transaction.dart';
import 'package:turbo_api_generated/src/model/wallet_transaction_list.dart';
import 'package:turbo_api_generated/src/model/webhook_ack.dart';

final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

  ReturnType deserialize<ReturnType, BaseType>(dynamic value, String targetType, {bool growable= true}) {
      switch (targetType) {
        case 'String':
          return '$value' as ReturnType;
        case 'int':
          return (value is int ? value : int.parse('$value')) as ReturnType;
        case 'bool':
          if (value is bool) {
            return value as ReturnType;
          }
          final valueString = '$value'.toLowerCase();
          return (valueString == 'true' || valueString == '1') as ReturnType;
        case 'double':
          return (value is double ? value : double.parse('$value')) as ReturnType;
        case 'AccountStatus':
          
          
        case 'AccountStatusUpdate':
          return AccountStatusUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdjustmentDecision':
          return AdjustmentDecision.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdjustmentRequest':
          return AdjustmentRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdjustmentRequestList':
          return AdjustmentRequestList.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminCancelRequest':
          return AdminCancelRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminCompleteRequest':
          return AdminCompleteRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminLogin':
          return AdminLogin.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminRideDetail':
          return AdminRideDetail.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminRideSummary':
          return AdminRideSummary.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AdminRideSummaryList':
          return AdminRideSummaryList.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Announcement':
          return Announcement.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AnnouncementCreate':
          return AnnouncementCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AppConfig':
          return AppConfig.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AppConfigMaintenance':
          return AppConfigMaintenance.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AppConfigMinVersion':
          return AppConfigMinVersion.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AttendanceCorrection':
          return AttendanceCorrection.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AttendanceRecord':
          return AttendanceRecord.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AttendanceRecordList':
          return AttendanceRecordList.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuditEntry':
          return AuditEntry.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuditEntryList':
          return AuditEntryList.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'AuthTokens':
          return AuthTokens.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CancelRequest':
          return CancelRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Cancellation':
          return Cancellation.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeclineRequest':
          return DeclineRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeletionRequest':
          return DeletionRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DestinationChange':
          return DestinationChange.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DestinationChangeConfirm':
          return DestinationChangeConfirm.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DeviceRegistration':
          return DeviceRegistration.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DriverCreate':
          return DriverCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DriverDetail':
          return DriverDetail.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DriverDetailList':
          return DriverDetailList.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DriverDocument':
          return DriverDocument.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DriverDocumentCreate':
          return DriverDocumentCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DriverDocumentExpiry':
          return DriverDocumentExpiry.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DriverDocumentExpiryList':
          return DriverDocumentExpiryList.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DriverDocumentKind':
          
          
        case 'DriverDocumentStatus':
          return DriverDocumentStatus.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DriverLocation':
          return DriverLocation.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DriverLocationPoint':
          return DriverLocationPoint.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DriverProfile':
          return DriverProfile.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DriverPublic':
          return DriverPublic.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DriverRide':
          return DriverRide.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DriverRideList':
          return DriverRideList.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DriverRideStudent':
          return DriverRideStudent.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DriverUpdate':
          return DriverUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'DutyUpdate':
          return DutyUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'FareBand':
          return FareBand.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'FareBandSet':
          return FareBandSet.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GeoJsonPolygon':
          return GeoJsonPolygon.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'GeoPoint':
          return GeoPoint.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Health':
          return Health.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Incident':
          return Incident.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'IncidentList':
          return IncidentList.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'IncidentUpdate':
          return IncidentUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'IneligibilityReason':
          return IneligibilityReason.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'InviteAccept':
          return InviteAccept.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LegalVersions':
          return LegalVersions.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LiveRides':
          return LiveRides.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LiveRidesOnDutyDriversInner':
          return LiveRidesOnDutyDriversInner.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LiveRidesRidesInner':
          return LiveRidesRidesInner.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Location':
          return Location.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'LocationBatch':
          return LocationBatch.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MfaConfirm':
          return MfaConfirm.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'MfaEnrollment':
          return MfaEnrollment.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OperatingWindow':
          return OperatingWindow.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OtpChallenge':
          return OtpChallenge.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OtpRequest':
          return OtpRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OtpVerify':
          return OtpVerify.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PageInfo':
          return PageInfo.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PasswordChange':
          return PasswordChange.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PasswordForgot':
          return PasswordForgot.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PasswordReset':
          return PasswordReset.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PhoneChange':
          return PhoneChange.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PickupPoint':
          return PickupPoint.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PickupPointWrite':
          return PickupPointWrite.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Problem':
          return Problem.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ProblemCode':
          
          
        case 'ProblemErrorsInner':
          return ProblemErrorsInner.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PublicTripShare':
          return PublicTripShare.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'QuickMessage':
          return QuickMessage.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'QuickMessageCode':
          
          
        case 'QuickMessageList':
          return QuickMessageList.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'QuickMessageSend':
          return QuickMessageSend.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Quote':
          return Quote.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'QuoteRequest':
          return QuoteRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'QuoteWallet':
          return QuoteWallet.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RatingCreate':
          return RatingCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReassignRequest':
          return ReassignRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Receipt':
          return Receipt.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReceiptLine':
          return ReceiptLine.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReconciliationItem':
          return ReconciliationItem.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReconciliationReport':
          return ReconciliationReport.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReconciliationReportList':
          return ReconciliationReportList.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ReconciliationRun':
          return ReconciliationRun.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RefreshRequest':
          return RefreshRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RefundRequest':
          return RefundRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Ride':
          return Ride.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RideCreate':
          return RideCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RideEvent':
          return RideEvent.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RideFlag':
          
          
        case 'RideList':
          return RideList.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RidePayment':
          return RidePayment.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'RideStatus':
          
          
        case 'SalaryPayment':
          return SalaryPayment.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SalaryPaymentCreate':
          return SalaryPaymentCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SalaryPaymentList':
          return SalaryPaymentList.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SalaryProfile':
          return SalaryProfile.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SalaryProfileWrite':
          return SalaryProfileWrite.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SavedPlace':
          return SavedPlace.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SavedPlaceCollection':
          return SavedPlaceCollection.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SavedPlaceCreate':
          return SavedPlaceCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ServiceArea':
          return ServiceArea.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ServiceAreaWrite':
          return ServiceAreaWrite.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Session':
          return Session.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SessionList':
          return SessionList.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SessionUser':
          return SessionUser.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Settings':
          return Settings.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ShareCreate':
          return ShareCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Shift':
          return Shift.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ShiftCreate':
          return ShiftCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ShiftList':
          return ShiftList.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SosRequest':
          return SosRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StaffCreate':
          return StaffCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StaffRole':
          
          
        case 'StaffUpdate':
          return StaffUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StaffUser':
          return StaffUser.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StaffUserList':
          return StaffUserList.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StartRequest':
          return StartRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Student':
          return Student.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StudentDetail':
          return StudentDetail.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StudentSummary':
          return StudentSummary.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StudentSummaryList':
          return StudentSummaryList.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'StudentUpdate':
          return StudentUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SupportMessage':
          return SupportMessage.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SupportMessageCreate':
          return SupportMessageCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SupportTicket':
          return SupportTicket.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SupportTicketCreate':
          return SupportTicketCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SupportTicketList':
          return SupportTicketList.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TermsAcceptance':
          return TermsAcceptance.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TicketUpdate':
          return TicketUpdate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Topup':
          return Topup.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TopupCheckout':
          return TopupCheckout.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TopupCreate':
          return TopupCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TopupList':
          return TopupList.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TopupResolve':
          return TopupResolve.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Tracking':
          return Tracking.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TransactionType':
          
          
        case 'TripLocation':
          return TripLocation.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TripShare':
          return TripShare.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TrustedContact':
          return TrustedContact.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TrustedContactCollection':
          return TrustedContactCollection.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'TrustedContactCreate':
          return TrustedContactCreate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UploadRequest':
          return UploadRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UploadSlot':
          return UploadSlot.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserRole':
          
          
        case 'Vehicle':
          return Vehicle.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'VehicleList':
          return VehicleList.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'VehiclePublic':
          return VehiclePublic.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'VehicleWrite':
          return VehicleWrite.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'VerificationDecision':
          return VerificationDecision.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'VerificationDecisionRecord':
          return VerificationDecisionRecord.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'VerificationDetail':
          return VerificationDetail.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'VerificationDocument':
          return VerificationDocument.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'VerificationState':
          return VerificationState.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'VerificationStatus':
          
          
        case 'VerificationSubmission':
          return VerificationSubmission.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'VerificationSummary':
          return VerificationSummary.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'VerificationSummaryList':
          return VerificationSummaryList.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'VerificationSummaryStudent':
          return VerificationSummaryStudent.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Wallet':
          return Wallet.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'WalletAdjustment':
          return WalletAdjustment.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'WalletTransaction':
          return WalletTransaction.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'WalletTransactionList':
          return WalletTransactionList.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'WebhookAck':
          return WebhookAck.fromJson(value as Map<String, dynamic>) as ReturnType;
        default:
          RegExpMatch? match;

          if (value is List && (match = _regList.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toList(growable: growable) as ReturnType;
          }
          if (value is Set && (match = _regSet.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toSet() as ReturnType;
          }
          if (value is Map && (match = _regMap.firstMatch(targetType)) != null) {
            targetType = match![1]!.trim(); // ignore: parameter_assignments
            return Map<String, BaseType>.fromIterables(
              value.keys as Iterable<String>,
              value.values.map((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable)),
            ) as ReturnType;
          }
          break;
    }
    throw Exception('Cannot deserialize');
  }