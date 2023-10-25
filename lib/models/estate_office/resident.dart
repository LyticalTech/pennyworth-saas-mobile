class Resident {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? gender;
  String? maritalStatus;
  bool? isDependant;
  String? accessToken;
  List<dynamic>? dependants;
  String? houseId;
  String? houseAddress;
  String? estateId;
  String? estateAddress;
  String? estateName;

  Resident({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.gender,
    this.maritalStatus,
    this.isDependant,
    this.accessToken,
    this.dependants,
    this.houseId,
    this.houseAddress,
    this.estateId,
    this.estateAddress,
    this.estateName,
  });

  String get fullName => "${firstName ?? ""} ${lastName ?? ""}";

  Resident.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phone = json['phone'];
    gender = json['gender'];
    maritalStatus = json['maritalStatus'];
    isDependant = json['isDependant'];
    accessToken = json['accessToken'];
    dependants = json['dependants'];
    houseId = json['houseId'];
    houseAddress = json['houseAddress'];
    estateId = json['estateId'];
    estateAddress = json['estateAddress'];
    estateName = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['gender'] = gender;
    data['maritalStatus'] = maritalStatus;
    data['isDependant'] = isDependant;
    data['accessToken'] = accessToken;
    data['dependants'] = dependants;
    data['houseId'] = houseId;
    data['houseAddress'] = houseAddress;
    data['estateId'] = estateId;
    data['estateAddress'] = estateAddress;
    data['name'] = estateName;

    return data;
  }
}