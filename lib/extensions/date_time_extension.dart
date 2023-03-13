import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {

  static const String datePattern = 'dd/MM/yyyy HH:mm';

  String format(String datePattern) {
    return DateFormat(datePattern).format(this);
  }

  static DateTime parseFromService(String dateString) {
    return DateFormat(datePattern).parse(dateString);
  }

}