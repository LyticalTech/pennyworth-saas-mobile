class Staff {
  String id;
  String fullName;
  String phoneNumber;
  String address;
  String email;

  Staff({required this.id, required this.fullName, required this.phoneNumber, required this.address, required this.email});

  factory Staff.fromJson(Map<String, dynamic> json) => Staff(
      id: json['id'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      email: json['email']
  );
}