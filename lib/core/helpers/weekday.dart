import 'package:intl/intl.dart';

extension Weekday on DateTime {
  String get engWeekday {
    return DateFormat('EEEE').format(this);
  }
}
