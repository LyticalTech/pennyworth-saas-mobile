import 'dart:convert';

class BookedFacility {
  BookedFacility({
    this.bookingDate,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.paymentDate,
    this.payment,
    this.bookingAmount,
    this.ratePerHour,
    this.totalHours,
    this.bookingStatus,
    this.paymentStatus,
    this.asset,
    this.id,
    this.description,
  });

  BookedFacility.fromJson(dynamic json) {
    bookingDate = json['bookingDate'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    paymentDate = json['paymentDate'];
    payment = json['payment'];
    bookingAmount = json['bookingAmount'];
    ratePerHour = json['ratePerHour'];
    totalHours = json['totalHours'] != null ? double.parse(json['totalHours'].toStringAsFixed(2)) : 0;
    bookingStatus = json['bookingStatus'];
    paymentStatus = json['paymentStatus'];
    asset = json['asset'];
    id = json['id'];
    description = json['description'];
  }

  String? bookingDate;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  String? paymentDate;
  double? payment;
  double? bookingAmount;
  double? ratePerHour;
  double? totalHours;
  int? bookingStatus;
  int? paymentStatus;
  String? asset;
  String? id;
  String? description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['bookingDate'] = bookingDate;
    map['startDate'] = startDate;
    map['endDate'] = endDate;
    map['startTime'] = startTime;
    map['endTime'] = endTime;
    map['paymentDate'] = paymentDate;
    map['payment'] = payment;
    map['bookingAmount'] = bookingAmount;
    map['ratePerHour'] = ratePerHour;
    map['totalHours'] = totalHours != null ? double.parse(totalHours!.toStringAsFixed(2)) : 0;
    map['bookingStatus'] = bookingStatus;
    map['paymentStatus'] = paymentStatus;
    map['asset'] = asset;
    map['id'] = id;
    map['description'] = description;
    return map;
  }
}

List<BookedFacility> parseBookedFacilities(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<BookedFacility>((json) => BookedFacility.fromJson(json)).toList();
}
