//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'invite_accept.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class InviteAccept {
  /// Returns a new [InviteAccept] instance.
  InviteAccept({

    required  this.token,

    required  this.password,
  });

  @JsonKey(
    
    name: r'token',
    required: true,
    includeIfNull: false,
  )


  final String token;



  @JsonKey(
    
    name: r'password',
    required: true,
    includeIfNull: false,
  )


  final String password;





    @override
    bool operator ==(Object other) => identical(this, other) || other is InviteAccept &&
      other.token == token &&
      other.password == password;

    @override
    int get hashCode =>
        token.hashCode +
        password.hashCode;

  factory InviteAccept.fromJson(Map<String, dynamic> json) => _$InviteAcceptFromJson(json);

  Map<String, dynamic> toJson() => _$InviteAcceptToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

