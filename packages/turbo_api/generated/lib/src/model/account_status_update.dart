//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:turbo_api_generated/src/model/account_status.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_status_update.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AccountStatusUpdate {
  /// Returns a new [AccountStatusUpdate] instance.
  AccountStatusUpdate({

    required  this.accountStatus,

    required  this.reason,
  });

  @JsonKey(
    
    name: r'accountStatus',
    required: true,
    includeIfNull: false,
  )


  final AccountStatus accountStatus;



  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AccountStatusUpdate &&
      other.accountStatus == accountStatus &&
      other.reason == reason;

    @override
    int get hashCode =>
        accountStatus.hashCode +
        reason.hashCode;

  factory AccountStatusUpdate.fromJson(Map<String, dynamic> json) => _$AccountStatusUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$AccountStatusUpdateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

