import 'dart:convert';

class Message {
  String title;
  String body;
  String date;

  Message({required this.title, required this.body, required this.date});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(title: json["title"], body: json["body"], date: json["date"]);
  }
}

class Complaint {
  String? title;
  String? message;
  String? date;
  int? status;
  String? comment;
  String? residentEmail;

  Complaint();

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint()
      ..title = json['title']
      ..message = json['message']
      ..date = json['createdOn']
      ..status = json['status']
      ..comment = json['comment']
      ..residentEmail = json['residentEmail'];
  }
}

List<Complaint> parseComplaints(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Complaint>((json) => Complaint.fromJson(json)).toList();
}
