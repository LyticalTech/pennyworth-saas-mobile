import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:residents/models/community/chat_message.dart';
import 'package:residents/models/other/firebase_resident.dart';

class ChatService {
  static FirebaseDatabase database = FirebaseDatabase.instance;
  static const conversations = "conversations";
  static const messages = "messages";

  static Future<void> saveMessage({
    required FirebaseResident authUser,
    required FirebaseResident? recipient,
    required String convoId,
    required ChatMessage message,
    bool isCommunity = false,
  }) async {
    database.ref("$conversations/$convoId/$messages").push().set(message.toJson()).then((_) {
      if (recipient != null && !isCommunity) {
        addConversationInfoFor(authUser, recipient, message.text);
      } else {
        updateCommunityChat(authUser, convoId, message.text);
      }
    });
  }

  static Stream<DatabaseEvent> fetchUserConvoHistory(String userId) {
    final ref = database.ref("residents/$userId/recipients");
    return ref.onValue;
  }

  static Stream<DatabaseEvent> fetchCommunityConvoInfo(String estateId) {
    final ref = database.ref("communities/$estateId");
    return ref.onValue;
  }

  static Stream<DatabaseEvent> fetchMessagesForConvo(String convoId) {
    final ref = database.ref("$conversations/$convoId/$messages");
    return ref.orderByChild("date").onValue;
  }

  static Future<void> updateCommunityChat(
    FirebaseResident sender,
    String estateId,
    String lastMessage,
  ) async {
    database.ref("communities").child(estateId).set({
      "convo_id": estateId,
      "full_name": sender.fullName,
      "last_message": lastMessage,
      "date": DateTime.now().toString(),
    });
  }

  static Future<void> addConversationInfoFor(
      FirebaseResident authUser, FirebaseResident recipient, String lastMessage) async {
    final convoId = "${authUser.uid}_${recipient.uid}";
    final dateTime = DateTime.now().toString();
    final ownRef = database.ref("residents/${authUser.uid}/recipients").child("${recipient.uid}");
    ownRef.push();
    ownRef
        .set(({
      "convo_id": convoId,
      "full_name": recipient.fullName,
      "chatting_with": recipient.uid,
      "last_message": lastMessage,
      "date": dateTime,
    }))
        .then((value) {
      final recipientRef = database.ref("residents/${recipient.uid}/recipients").child(authUser.uid!);
      recipientRef.push();
      recipientRef.set({
        "convo_id": convoId,
        "full_name": authUser.fullName,
        "chatting_with": authUser.uid,
        "last_message": lastMessage,
        "date": dateTime,
      });
    });
  }

  static Future<void> updateConvoInfoFor(String authUserId, String recipientId, String lastMessage) async {
    if (lastMessage.isNotEmpty) {
      final update = {"last_message": lastMessage};
      final ownRef = database.ref("residents/$authUserId/recipients").child(recipientId);
      final recipientRef = database.ref("residents/$recipientId/recipients").child(authUserId);
      ownRef.update(update).then((_) => recipientRef.update(update));
    }
  }

  static Future<String?> fetchConversationIdFor(String authUserId, String recipientId) async {
    final ref = database.ref();
    final snapshot = await ref.child("residents/$authUserId/recipients/$recipientId").get();

    if (snapshot.exists) {
      final convoObject = snapshot.value as Map?;
      final convoIfo = convoObject?[recipientId] as Map?;
      if (convoIfo != null) {
        return convoIfo["convo_id"];
      } else {
        return convoObject?["convo_id"];
      }
    }
    return null;
  }
}
