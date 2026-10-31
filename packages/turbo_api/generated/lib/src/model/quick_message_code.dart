//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

enum QuickMessageCode {
  @JsonValue(r'im_here')
  imHere(r'im_here'),
  @JsonValue(r'running_late')
  runningLate(r'running_late'),
  @JsonValue(r'at_the_gate')
  atTheGate(r'at_the_gate'),
  @JsonValue(r'cannot_find_you')
  cannotFindYou(r'cannot_find_you'),
  @JsonValue(r'please_come_out')
  pleaseComeOut(r'please_come_out'),
  @JsonValue(r'on_my_way')
  onMyWay(r'on_my_way');

  const QuickMessageCode(this.value);

  final String value;

  @override
  String toString() => value;
}
