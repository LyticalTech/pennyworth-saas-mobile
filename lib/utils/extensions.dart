import 'package:intl/intl.dart';

extension DateExt on DateTime {
  String formattedTime() {
    return DateFormat('h:mm a').format(this);
  }

  String formattedDate() {
    var formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(this);
  }

  String formattedDateTime() {
    return DateFormat('EEE, MMM d').add_jm().format(this);
  }

  String formattedVerboseDate() {
    var formatter = DateFormat('EEE dd MMM, yyyy');
    return formatter.format(this);
  }
}

extension StringExt on String {
  String toSentenceCase() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
