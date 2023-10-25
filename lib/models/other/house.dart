import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:residents/models/other/app_user.dart';

class House {
  String? id;

  String? reservedKey;

  String? address;

  List<dynamic>? authorizedEmails;

  int? allowedAccounts;

  int? remainingAccounts;

  HouseType? houseType;

  Estate? estate;

  String? estateId;

  House();

  factory House.fromSnapshot(DocumentSnapshot snap) {
    return House()
      ..id = snap['houseId']
      ..address = snap['address']
      ..reservedKey = snap['house_reserved_key']
      ..authorizedEmails = snap['emails']
      ..houseType = HouseType.fromJson(snap['houseType'])
      ..estate = Estate.fromJson(snap['estate'])
      ..estateId = snap['estateId'];
  }

  factory House.fromJson(Map<String, dynamic> json) {
    return House()
      ..id = json['houseId']
      ..address = json['address']
      ..reservedKey = json['house_reserved_key']
      ..authorizedEmails = json['emails']
      ..houseType = HouseType.fromJson(json['houseType'])
      ..estate = Estate.fromJson(json['estate'])
      ..estateId = json['estateId'];
  }

  Map<String, dynamic> toJson() {
    return {
      'houseId': id,
      'house_reserved_key': reservedKey,
      'address': address,
      'emails': authorizedEmails ?? [],
      'estate': estate?.toJson(),
      'houseType': houseType?.toJson(),
      'allowed_accounts': allowedAccounts,
      'remaining_accounts': remainingAccounts
    };
  }
}
