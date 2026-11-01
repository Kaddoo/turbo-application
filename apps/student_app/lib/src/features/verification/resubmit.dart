import 'package:flutter_riverpod/flutter_riverpod.dart';

/// True while a student whose documents need attention is sending them again.
class ResubmitController extends Notifier<bool> {
  @override
  bool build() => false;

  void start() => state = true;
  void finish() => state = false;
}

final resubmitProvider = NotifierProvider<ResubmitController, bool>(ResubmitController.new);
