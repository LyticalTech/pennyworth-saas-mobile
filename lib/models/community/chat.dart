import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:residents/models/community/chat_message.dart';

class Chat {
  final String name, lastMessage, time;

  Chat({
    required this.name,
    required this.lastMessage,
    required this.time,
  });
}

class Conversation {
  final String id;
  final List<String> displayNames;
  final List<String> users;
  final ChatMessage lastMessage;
  final DateTime date;

  Conversation(
      {required this.id,
      required this.displayNames,
      required this.users,
      required this.lastMessage,
      required this.date});

  factory Conversation.fromFirestore(DocumentSnapshot snapshot) {
    return Conversation(
      id: snapshot.id,
      displayNames: (snapshot["displayNames"] as List)
          .map((item) => item as String)
          .toList(),
      users: (snapshot["users"] as List).map((item) => item as String).toList(),
      lastMessage: ChatMessage.fromJson(snapshot["lastMessage"]),
      date: (snapshot['date'] as Timestamp).toDate(),
    );
  }
}
