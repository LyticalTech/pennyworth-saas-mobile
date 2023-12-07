// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderName;
  final String receiverId;
  final String receiverName;
  final String message;
  final DateTime date;
  List<String> get parties {
    // return [senderId, receiverId];
    var sendId = int.parse(senderId);
    var recId = int.tryParse(receiverId);

    if (recId == null) return [senderId, receiverId];
    if (sendId > recId) return [receiverId, senderId];
    return [senderId, receiverId];
  }

  Message(
      {required this.senderName,
      required this.receiverName,
      required this.senderId,
      required this.receiverId,
      required this.message,
      required this.date});

  factory Message.fromFirestore(DocumentSnapshot snapshot) {
    return Message(
      senderId: snapshot['senderId'],
      receiverName: snapshot['receiverName'],
      receiverId: snapshot['receiverId'],
      date: (snapshot['date'] as Timestamp).toDate(),
      message: snapshot['message'],
      senderName: snapshot['senderName'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverName': receiverName,
      "receiverId": receiverId,
      "date": Timestamp.fromDate(date),
      "message": message,
      "senderName": senderName,
      "parties": parties
    };
  }

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) return true;

    return other.senderName == senderName &&
        other.receiverId == receiverId &&
        other.senderId == senderId &&
        other.receiverId != senderId &&
        other.receiverName == receiverName;
  }

  @override
  int get hashCode {
    return senderId.hashCode ^
        senderName.hashCode ^
        receiverId.hashCode ^
        receiverName.hashCode ^
        message.hashCode ^
        date.hashCode;
  }

  @override
  String toString() {
    return 'Message(senderId: $senderId, senderName: $senderName, receiverId: $receiverId, receiverName: $receiverName, message: $message, date: $date)';
  }
}
