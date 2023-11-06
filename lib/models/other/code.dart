import 'package:cloud_firestore/cloud_firestore.dart';

class Code {
  int houseId;
  int codeId;
  String status;
  String createdBy;
  DateTime createdAt;
  DateTime expires;
  String code;
  bool visitorsImage;
  bool vehicleImage;
  bool idCard;

  Code({
    required this.codeId,
    required this.houseId,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.expires,
    required this.code,
    required this.visitorsImage,
    required this.vehicleImage,
    required this.idCard,
  });

  factory Code.fromJson(Map<String, dynamic> json) {
    return Code(
      houseId: json['houseId'] as int,
      status: json['status'] as String,
      codeId: json['codeId'] as int,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      expires: DateTime.parse(json['expires']),
      code: json['code'] as String,
      visitorsImage: json['visitorsImage'] as bool,
      vehicleImage: json['vehicleImage'] as bool,
      idCard: json['idCard'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'houseId': houseId,
      'status': status,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'expires': expires.toIso8601String(),
      'code': code,
      'visitorsImage': visitorsImage,
      'vehicleImage': vehicleImage,
      'idCard': idCard,
    };
  }

  factory Code.fromSnapshot(DocumentSnapshot snap) {
    return Code(
      houseId: snap['houseId'],
      status: snap['status'],
      createdBy: snap['createdBy'],
      createdAt: snap['createdAt'].toDate(),
      expires: snap['expires'].toDate(),
      code: snap['code'],
      visitorsImage: snap['visitorsImage'],
      vehicleImage: snap['vehicleImage'],
      idCard: snap['idCard'],
      codeId: snap['null'],
    );
  }
}
