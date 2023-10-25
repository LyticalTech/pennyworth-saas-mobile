import 'dart:convert';

class Invoice {
  String id;
  String residentId;
  // String resident;
  double bill;
  String invoiceDate;
  String? paymentDate;
  double amountPaid;
  double outstanding;
  String? remarks;
  String? invoiceNumber;
  String? paymentMethod;
  int? totalPaid;
  int? totalUnpaid;
  final double totalAmountCreated;
  final double totalAmountPaid;
  final double totalAmountUnPaid;

  Invoice({
    required this.id,
    required this.residentId,
    // required this.resident,
    required this.bill,
    required this.amountPaid,
    required this.outstanding,
    required this.invoiceDate,
    required this.totalAmountCreated,
    required this.totalAmountPaid,
    required this.totalAmountUnPaid,
    this.paymentDate,
    this.remarks,
    this.invoiceNumber,
    this.paymentMethod,
    this.totalPaid,
    this.totalUnpaid,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
      id: json['id'],
      residentId: json['houseId'],
      bill: (json['bill'] != null) ? json['bill'].toDouble() : null,
      invoiceDate: json['invoiceDate'],
      outstanding: (json['outstanding'] != null) ? json['outstanding'].toDouble() : null,
      remarks: json['remarks'],
      amountPaid: (json['amountPaid'] != null) ? json['amountPaid'].toDouble() : null,
      invoiceNumber: json['invoiceNumber'],
      totalAmountCreated: json['totalAmountCreated'],
      totalAmountUnPaid: (json['totalAmountUnPaid'] != null) ? json['totalAmountUnPaid'].toDouble() : null,
      totalAmountPaid: (json['totalAmountPaid'] != null) ? json['totalAmountPaid'].toDouble() : null,
      paymentDate: json['paymentDate'],
      paymentMethod: json['paymentMethod'],
      totalPaid: (json['totalPaid'] != null) ? json['totalPaid'].toInt() : null,
      totalUnpaid: (json['totalUnPaid'] != null) ? json['totalUnPaid'].toInt() : null,
  );
}

List<Invoice> parseInvoices(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Invoice>((json) => Invoice.fromJson(json)).toList();
}

