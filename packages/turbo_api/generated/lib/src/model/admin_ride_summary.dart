//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/ride_status.dart';
import 'package:turbo_api_generated/src/model/ride_flag.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_ride_summary.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminRideSummary {
  /// Returns a new [AdminRideSummary] instance.
  AdminRideSummary({

    required  this.id,

    required  this.status,

    required  this.studentId,

     this.studentName,

     this.driverId,

     this.driverName,

    required  this.routeDistanceMeters,

    required  this.farePesewas,

    required  this.requestedAt,

     this.flags,
  });

      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final RideStatus status;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'studentId',
    required: true,
    includeIfNull: false,
  )


  final String studentId;



  @JsonKey(
    
    name: r'studentName',
    required: false,
    includeIfNull: false,
  )


  final String? studentName;



      /// UUID (v7 recommended so ids sort by creation time).
  @JsonKey(
    
    name: r'driverId',
    required: false,
    includeIfNull: false,
  )


  final String? driverId;



  @JsonKey(
    
    name: r'driverName',
    required: false,
    includeIfNull: false,
  )


  final String? driverName;



  @JsonKey(
    
    name: r'routeDistanceMeters',
    required: true,
    includeIfNull: false,
  )


  final int routeDistanceMeters;



      /// Money as an integer number of pesewas (GH₵1 = 100 pesewas). Never a float. GH₵35.00 = 3500.
          // minimum: 0
  @JsonKey(
    
    name: r'farePesewas',
    required: true,
    includeIfNull: false,
  )


  final int farePesewas;



  @JsonKey(
    
    name: r'requestedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime requestedAt;



  @JsonKey(
    
    name: r'flags',
    required: false,
    includeIfNull: false,
  )


  final List<RideFlag>? flags;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminRideSummary &&
      other.id == id &&
      other.status == status &&
      other.studentId == studentId &&
      other.studentName == studentName &&
      other.driverId == driverId &&
      other.driverName == driverName &&
      other.routeDistanceMeters == routeDistanceMeters &&
      other.farePesewas == farePesewas &&
      other.requestedAt == requestedAt &&
      other.flags == flags;

    @override
    int get hashCode =>
        id.hashCode +
        status.hashCode +
        studentId.hashCode +
        (studentName == null ? 0 : studentName.hashCode) +
        (driverId == null ? 0 : driverId.hashCode) +
        (driverName == null ? 0 : driverName.hashCode) +
        routeDistanceMeters.hashCode +
        farePesewas.hashCode +
        requestedAt.hashCode +
        flags.hashCode;

  factory AdminRideSummary.fromJson(Map<String, dynamic> json) => _$AdminRideSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$AdminRideSummaryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

