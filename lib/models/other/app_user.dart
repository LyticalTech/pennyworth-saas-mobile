import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:residents/models/other/house.dart';

class AppUser {
  String? uid;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String gender;
  final String maritalStatus;
  final String? fcmToken;
  final House? houseInfo;
  final String? relationship;
  final List<AppUser> dependants;
  final bool isAdmin;

  set updateUid(String uid) => this.uid = uid;

  String get fullName => "$firstName $lastName";

  AppUser({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.gender,
    required this.maritalStatus,
    this.uid,
    this.houseInfo,
    this.fcmToken,
    this.dependants = const [],
    this.isAdmin = false,
    this.relationship
  });

  factory AppUser.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return AppUser(
      uid: snapshot.id,
      firstName: data['firstName'],
      lastName: data['lastName'],
      phoneNumber: data['phoneNumber'],
      email: data['email'],
      gender: data['gender'],
      houseInfo: House.fromJson(data['houseInfo']),
      maritalStatus: data['maritalStatus'],
      fcmToken: data['fcmToken'],
      isAdmin: data['isAdmin'] ?? false,
      dependants: (data['dependants'] as List?)?.map((e) => AppUser.fromJson(e)).toList() ?? []
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      gender: json['gender'],
      maritalStatus: json['maritalStatus'],
      houseInfo: House.fromJson(json['houseInfo']),
      dependants: (json['dependants'] as List).map((e) => AppUser.fromJson(e)).toList(),
      fcmToken: json['fcmToken'],
    );
  }

  Map<String, dynamic> toSnapshot() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'gender': gender,
      'maritalStatus': maritalStatus,
      'houseInfo': houseInfo?.toJson(),
      'dependants': dependants.map((user) => user.toSnapshot()).toList(),
      if (relationship != null) 'relationship': relationship,
    };
  }
}

class Estate {
  String? id;
  String? name;
  String? address;

  Estate({this.id, this.name, this.address});

  factory Estate.fromJson(Map<String, dynamic> json) => Estate(
        id: json['estateId'],
        name: json['name'],
        address: json['address'],
      );

  Map<String, dynamic> toJson() => {"estateId": id, "name": name, "address": address};
}

class HouseType {
  final String? id;
  final String? title;

  HouseType(this.id, this.title);

  factory HouseType.fromJson(Map<String, dynamic> json) => HouseType(json['typeId'], json['title']);

  Map<String, dynamic> toJson() {
    return {"typeId": id, "title": title};
  }
}
