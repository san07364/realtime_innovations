import 'package:intl/intl.dart';

class DateHelper {
  static String getFormattedDate({required DateTime? dateTime}) {
    if (dateTime == null) return "";
    return DateFormat("dd MMM yyyy").format(dateTime);
  }
}
