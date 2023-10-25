import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:residents/models/estate_office/resident.dart';

class FirebaseResident {
  String? uid;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String? fcmToken;
  final String houseId;
  final String estateId;
  final String estateName;
  final bool isAdmin;

  set updateUid(String uid) => this.uid = uid;

  FirebaseResident({
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.houseId,
    required this.estateId,
    required this.estateName,
    this.uid,
    this.fcmToken,
    this.isAdmin = false,
  });

  factory FirebaseResident.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return FirebaseResident(
      uid: snapshot.id,
      fullName: data['fullName'],
      phoneNumber: data['phoneNumber'],
      email: data['email'],
      houseId: data['houseId'],
      estateId: data['estateId'],
      estateName: data['estateName'] ?? "",
      fcmToken: data['fcmToken'],
      isAdmin: data['isAdmin'] ?? false,
    );
  }

  factory FirebaseResident.fromJson(Map<String, dynamic> data) {
    return FirebaseResident(
      fullName: data['fullName'],
      phoneNumber: data['phoneNumber'],
      email: data['email'],
      houseId: data['houseId'],
      estateId: data['estateId'],
      estateName: data['estateName'] ?? "",
      fcmToken: data['fcmToken'],
      isAdmin: data['isAdmin'] ?? false,
    );
  }

  factory FirebaseResident.fromResident(Resident resident) {
    return FirebaseResident(
      fullName: resident.fullName,
      phoneNumber: resident.phone ?? "",
      email: resident.email ?? "",
      houseId: resident.houseId ?? "",
      estateId: resident.estateId ?? "",
      estateName: resident.estateName ?? "",
      uid: resident.id,
    );
  }

  Map<String, dynamic> toSnapshot() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'houseId': houseId,
      'estateId': estateId,
      'estateName': estateName,
      'isAdmin': isAdmin,
    };
  }
}
