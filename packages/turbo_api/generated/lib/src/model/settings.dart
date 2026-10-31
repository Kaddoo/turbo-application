//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/operating_window.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Settings {
  /// Returns a new [Settings] instance.
  Settings({

     this.maxTripDistanceMeters = 18000,

     this.quoteTtlSeconds = 300,

     this.driverAckTimeoutSeconds = 45,

     this.noDriverTimeoutSeconds = 300,

    required  this.minTopupPesewas,

    required  this.maxTopupPesewas,

     this.operatingHours,

     this.driverSilenceSeconds = 180,

     this.noShowWaitSeconds = 300,

     this.quoteLimitPerMinute = 10,

     this.smsDailyLimit = 500,

     this.adjustmentApprovalThresholdPesewas = 5000,

     this.locationRetentionDays = 90,

     this.bookingsPaused = false,

     this.pauseMessage,
  });

          // minimum: 1000
  @JsonKey(
    defaultValue: 18000,
    name: r'maxTripDistanceMeters',
    required: true,
    includeIfNull: false,
  )


  final int maxTripDistanceMeters;



          // minimum: 30
  @JsonKey(
    defaultValue: 300,
    name: r'quoteTtlSeconds',
    required: true,
    includeIfNull: false,
  )


  final int quoteTtlSeconds;



          // minimum: 10
  @JsonKey(
    defaultValue: 45,
    name: r'driverAckTimeoutSeconds',
    required: true,
    includeIfNull: false,
  )


  final int driverAckTimeoutSeconds;



          // minimum: 30
  @JsonKey(
    defaultValue: 300,
    name: r'noDriverTimeoutSeconds',
    required: true,
    includeIfNull: false,
  )


  final int noDriverTimeoutSeconds;



      /// Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
          // minimum: 0
  @JsonKey(
    
    name: r'minTopupPesewas',
    required: true,
    includeIfNull: false,
  )


  final int minTopupPesewas;



      /// Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
          // minimum: 0
  @JsonKey(
    
    name: r'maxTopupPesewas',
    required: true,
    includeIfNull: false,
  )


  final int maxTopupPesewas;



  @JsonKey(
    
    name: r'operatingHours',
    required: false,
    includeIfNull: false,
  )


  final List<OperatingWindow>? operatingHours;



          // minimum: 1
  @JsonKey(
    defaultValue: 180,
    name: r'driverSilenceSeconds',
    required: false,
    includeIfNull: false,
  )


  final int? driverSilenceSeconds;



          // minimum: 1
  @JsonKey(
    defaultValue: 300,
    name: r'noShowWaitSeconds',
    required: false,
    includeIfNull: false,
  )


  final int? noShowWaitSeconds;



          // minimum: 1
  @JsonKey(
    defaultValue: 10,
    name: r'quoteLimitPerMinute',
    required: false,
    includeIfNull: false,
  )


  final int? quoteLimitPerMinute;



          // minimum: 1
  @JsonKey(
    defaultValue: 500,
    name: r'smsDailyLimit',
    required: false,
    includeIfNull: false,
  )


  final int? smsDailyLimit;



          // minimum: 1
  @JsonKey(
    defaultValue: 5000,
    name: r'adjustmentApprovalThresholdPesewas',
    required: false,
    includeIfNull: false,
  )


  final int? adjustmentApprovalThresholdPesewas;



          // minimum: 1
  @JsonKey(
    defaultValue: 90,
    name: r'locationRetentionDays',
    required: false,
    includeIfNull: false,
  )


  final int? locationRetentionDays;



      /// When true, quotes return ineligible with code bookings_paused and the message below. Rides already underway continue.
  @JsonKey(
    defaultValue: false,
    name: r'bookingsPaused',
    required: false,
    includeIfNull: false,
  )


  final bool? bookingsPaused;



  @JsonKey(
    
    name: r'pauseMessage',
    required: false,
    includeIfNull: false,
  )


  final String? pauseMessage;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Settings &&
      other.maxTripDistanceMeters == maxTripDistanceMeters &&
      other.quoteTtlSeconds == quoteTtlSeconds &&
      other.driverAckTimeoutSeconds == driverAckTimeoutSeconds &&
      other.noDriverTimeoutSeconds == noDriverTimeoutSeconds &&
      other.minTopupPesewas == minTopupPesewas &&
      other.maxTopupPesewas == maxTopupPesewas &&
      other.operatingHours == operatingHours &&
      other.driverSilenceSeconds == driverSilenceSeconds &&
      other.noShowWaitSeconds == noShowWaitSeconds &&
      other.quoteLimitPerMinute == quoteLimitPerMinute &&
      other.smsDailyLimit == smsDailyLimit &&
      other.adjustmentApprovalThresholdPesewas == adjustmentApprovalThresholdPesewas &&
      other.locationRetentionDays == locationRetentionDays &&
      other.bookingsPaused == bookingsPaused &&
      other.pauseMessage == pauseMessage;

    @override
    int get hashCode =>
        maxTripDistanceMeters.hashCode +
        quoteTtlSeconds.hashCode +
        driverAckTimeoutSeconds.hashCode +
        noDriverTimeoutSeconds.hashCode +
        minTopupPesewas.hashCode +
        maxTopupPesewas.hashCode +
        (operatingHours == null ? 0 : operatingHours.hashCode) +
        driverSilenceSeconds.hashCode +
        noShowWaitSeconds.hashCode +
        quoteLimitPerMinute.hashCode +
        smsDailyLimit.hashCode +
        adjustmentApprovalThresholdPesewas.hashCode +
        locationRetentionDays.hashCode +
        bookingsPaused.hashCode +
        (pauseMessage == null ? 0 : pauseMessage.hashCode);

  factory Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

