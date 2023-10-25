import 'dart:convert';

class Attendance {
  String? date;
  String? timeIn;
  String? timeOut;
  String? staff;
  String? title;
  String? id;

  Attendance({
    required this.date,
    required this.timeIn,
    required this.timeOut,
    required this.staff,
    required this.title,
    required this.id
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
      date: json["date"],
      timeIn: json["timeIn"],
      timeOut: json["timeOut"],
      staff: json["staff"],
      title: json["title"],
      id: json["id"]
  );
}

List<Attendance> parseAttendance(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Attendance>((json) => Attendance.fromJson(json)).toList();
}
