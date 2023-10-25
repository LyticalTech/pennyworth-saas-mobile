class Payment {
  String invoiceId;
  String residentId;
  String resident;
  double amountPaid;
  double outstanding;
  String remarks;
  String paymentMethod;
  DateTime paymentDate;

  Payment({
    required this.invoiceId, required this.residentId,
    required this.resident, required this.amountPaid,
    required this.outstanding, required this.remarks,
    required this.paymentMethod, required this.paymentDate
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
      invoiceId: json['invoiceId'],
      residentId: json['residentId'],
      resident: json['resident'],
      amountPaid: json['amountPaid'],
      outstanding: json['outstanding'],
      remarks: json['remarks'],
      paymentMethod: json['paymentMethod'],
      paymentDate: json['paymentDate']
  );
}

class PettyCash {
  String id;
  DateTime date;
  String item;
  double debit;
  double credit;
  String remarks;

  PettyCash({
    required this.id, required this.date, required this.item,
    required this.debit, required this.credit, required this.remarks
  });

  factory PettyCash.fromJson(Map<String, dynamic> json) => PettyCash(
      id: json['id'],
      date: json['date'],
      item: json['item'],
      debit: json['debit'],
      credit: json['credit'],
      remarks: json['remarks']
  );
}