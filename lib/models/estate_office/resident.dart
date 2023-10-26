class Resident {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final bool isDependant;
  final int houseId;
  final String houseAddress;
  final String estateAddress;
  final String estateName;
  final int estateId;
  final int userType;
  final String address;
  final String? tenantTheme;
  final String accessToken;
  final int role;

  Resident({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.isDependant,
    required this.houseId,
    required this.houseAddress,
    required this.estateAddress,
    required this.estateName,
    required this.estateId,
    required this.userType,
    required this.address,
    required this.tenantTheme,
    required this.accessToken,
    required this.role,
  });

  factory Resident.fromJson(Map<String, dynamic> json) {
    return Resident(
      id: json['data']['id'],
      firstName: json['data']['firstName'],
      lastName: json['data']['lastName'],
      email: json['data']['email'],
      phone: json['data']['phone'],
      isDependant: json['data']['isDependant'],
      houseId: json['data']['houseId'],
      houseAddress: json['data']['houseAddress'],
      estateAddress: json['data']['estateAddress'],
      estateName: json['data']['estateName'],
      estateId: json['data']['estateId'],
      userType: json['data']['userType'],
      address: json['data']['estateAddress'],
      tenantTheme: json['data']['tenantTheme'],
      accessToken: json['data']['accessToken'],
      role: json['data']['role'],
    );
  }

  String get fullName {
    return '$firstName $lastName';
  }
}
