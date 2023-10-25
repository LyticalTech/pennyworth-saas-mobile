class Service {
  String title;
  String? remarks;
  double? quarterlyCharge;
  double? monthCharge;
  double? actualSpend;
  double? variance;
  double? totalAmount;

  Service(this.title,
      {this.remarks,
      this.quarterlyCharge,
      this.monthCharge,
      this.actualSpend,
      this.variance,
      this.totalAmount});

  factory Service.fromJson(Map<String, dynamic> json) => Service(json["title"],
      remarks: json['remarks'],
      quarterlyCharge: json['quarterly_charge'],
      monthCharge: json['monthly_charge'],
      actualSpend: json['actual_spend'],
      variance: json['variance'],
      totalAmount: json['total_amount']);
}
