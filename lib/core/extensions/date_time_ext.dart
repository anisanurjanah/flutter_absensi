import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String toFormattedDate() {
    return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(this);
  }

  String toFormattedTime() {
    final now = DateTime.now();
    final timeZoneOffset = now.timeZoneOffset;
    final correctedTime = toUtc().add(timeZoneOffset);
    return DateFormat('HH:mm', 'id_ID').format(correctedTime) + ' WIB';
  }
}
