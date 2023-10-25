import 'dart:convert';

class ServiceCharge {
  final String? id;
  final String item;
  final String date;
  final String? remarks;
  final double amount;

  ServiceCharge(
      {this.id,
      required this.item,
      required this.date,
      this.remarks,
      required this.amount});

  factory ServiceCharge.fromJson(Map<String, dynamic> json) => ServiceCharge(
        id: json["id"],
        item: json["item"],
        date: json["date"],
        remarks: json["remarks"],
        amount: json["amount"],
      );
}

List<ServiceCharge> parseServiceCharges(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<ServiceCharge>((json) => ServiceCharge.fromJson(json)).toList();
}
