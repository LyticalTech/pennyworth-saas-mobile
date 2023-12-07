class Contact {
  final int residentId;
  final String houseNumber;
  final String email;
  final int houseId;
  final bool isDependant;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String address;

  final String estate;
  final int estateId;
  final int tenantId;
  final int serviceChargeId;
  final int accountStatus;

  Contact({
    required this.residentId,
    required this.houseNumber,
    required this.email,
    required this.houseId,
    required this.isDependant,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.address,
    required this.estate,
    required this.estateId,
    required this.tenantId,
    required this.serviceChargeId,
    required this.accountStatus,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      residentId: json['residentId'],
      houseNumber: json['houseNumber'],
      email: json['email'],
      houseId: json['houseId'],
      isDependant: json['isDependant'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      estate: json['estate'],
      estateId: json['estateId'],
      tenantId: json['tenantId'],
      serviceChargeId: json['serviceChargeId'],
      accountStatus: json['accountStatus'],
    );
  }
}
