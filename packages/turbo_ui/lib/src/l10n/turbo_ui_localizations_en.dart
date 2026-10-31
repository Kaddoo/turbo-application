// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'turbo_ui_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class TurboUiLocalizationsEn extends TurboUiLocalizations {
  TurboUiLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tryAgain => 'Try again';

  @override
  String get cancel => 'Cancel';

  @override
  String get paste => 'Paste';

  @override
  String get loading => 'Loading';

  @override
  String get errorDefault =>
      'Something went wrong. Check your connection and try again.';

  @override
  String otpDigit(int position, int total) {
    return 'Digit $position of $total';
  }

  @override
  String get mapUnavailable => 'The map isn\'t available right now.';

  @override
  String typeToConfirm(String phrase) {
    return 'Type $phrase to confirm';
  }

  @override
  String get timelineDone => 'Done';

  @override
  String get timelineCurrent => 'In progress';

  @override
  String get timelineUpcoming => 'Not yet';

  @override
  String lastUpdated(String time) {
    return 'Last updated $time';
  }
}
