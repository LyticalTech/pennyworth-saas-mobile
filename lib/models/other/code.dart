import 'package:cloud_firestore/cloud_firestore.dart';

class Code {

  late final String houseId;

  late String status;

  late final String createdBy;

  late final DateTime createdAt;

  late DateTime expires;

  late final String code;

  late final bool visitorsImage;

  late final bool vehicleImage;

  late final bool idCard;

  Code({

    required this.houseId,

    required this.status,

    required this.createdBy,

    required this.createdAt,

    required this.expires,

    required this.code,

    required this.visitorsImage,

    required this.vehicleImage,

    required this.idCard

 });

  factory Code.fromSnapshot(DocumentSnapshot snap){

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

    );
  }

  Map<String, dynamic> toSnapshot () {
    return {

      'houseId': houseId,

      'status': status,

      'createdBy': createdBy,

      'createdAt': createdAt,

      'expires': expires,

      'code': code,

      'visitorsImage': visitorsImage,

      'vehicleImage': vehicleImage,

      'idCard': idCard,

    };
  }
}