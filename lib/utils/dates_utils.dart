import 'package:intl/intl.dart';

String formatDateTime(dynamic dateTime) {
  final dateFormat = DateFormat('d MMMM, y hh:mm a');
  return dateFormat.format(dateTime);
}

String formatTime(DateTime? dateTime) {
  if (dateTime == null) return "";
  final dateFormat = DateFormat('hh:mm a');
  return dateFormat.format(dateTime);
}

String formatDateDMY(DateTime? dateTime) {
  if (dateTime == null) return "";
  final dateFormat = DateFormat('d MMMM, y');
  return dateFormat.format(dateTime);
}

String formatDayMonth(DateTime date) {
  final weekday = DateFormat.EEEE().format(date); // Get the full weekday name
  final day = DateFormat.d().format(date); // Get the day of the month
  final month = DateFormat.MMMM().format(date); // Get the full month name
  return '$weekday $day $month';
}
