import 'package:cloud_firestore/cloud_firestore.dart';

enum ChatMessageType { text, audio, image, video }
enum MessageStatus { notSent, unread, read }

extension TypeExtension on ChatMessageType {
  String get value {
    switch (this) {
      case ChatMessageType.text:
        return "text";
      case ChatMessageType.image:
        return "image";
      case ChatMessageType.audio:
        return "audio";
      case ChatMessageType.video:
        return "video";
    }
  }
}

extension StatusExtension on MessageStatus {
  String get value {
    switch (this) {
      case MessageStatus.read:
        return "read";
      case MessageStatus.unread:
        return "unread";
      case MessageStatus.notSent:
        return "not_sent";
    }
  }
}

class ChatMessage {
  final String? id;
  final String text;
  final String messageType;
  final String messageStatus;
  final String senderId;
  final String? receiverId;
  final String? mediaUrl;
  final String date;

  ChatMessage({
    this.id,
    required this.senderId,
    required this.text,
    required this.messageType,
    required this.messageStatus,
    required this.date,
    this.mediaUrl,
    this.receiverId,
  });

  factory ChatMessage.fromFireStore(DocumentSnapshot doc) => ChatMessage(
      id: doc.id,
      senderId: doc["sender_id"],
      text: doc["text"],
      messageType: doc["type"],
      messageStatus: doc["status"],
      mediaUrl: doc["media_url"],
      receiverId: doc["receiver_id"],
      date: doc["date"],
  );

  factory ChatMessage.fromJson(Map<dynamic, dynamic> doc) => ChatMessage(
    senderId: doc["sender_id"],
    text: doc["text"],
    messageType: doc["type"],
    messageStatus: doc["status"],
    mediaUrl: doc["media_url"],
    receiverId: doc["receiver_id"],
    date: doc["date"],
  );

  Map<String, dynamic> toJson() => {
     "sender_id": senderId,
     "text": text,
     "type": messageType,
     "status": messageStatus,
     "media_url": mediaUrl,
     "receiver_id": receiverId,
     "date": date,
  };
}