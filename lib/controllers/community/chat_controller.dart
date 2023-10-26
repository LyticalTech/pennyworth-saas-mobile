import 'dart:developer';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:residents/components/text.dart';
import 'package:residents/controllers/auth/auth_controller.dart';
import 'package:residents/models/community/chat_message.dart';
import 'package:residents/models/estate_office/resident.dart';
import 'package:residents/models/other/firebase_resident.dart';
import 'package:residents/services/chat_service.dart';

class ChatController extends GetxController {
  @override
  void onInit() {
    resident.value = authController.resident.value!;
    super.onInit();
  }

  TextEditingController message = TextEditingController();

  late final FirebaseMessaging firebaseMessaging;

  final AuthController authController = Get.find();

  final hasCommunity = false.obs;
  late Rx<Resident> resident;

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static final CollectionReference userCollectionRef =
      _db.collection("residents");

  final userRef = userCollectionRef.withConverter<FirebaseResident>(
    fromFirestore: (snapshot, _) => FirebaseResident.fromSnapshot(snapshot),
    toFirestore: (resident, _) => resident.toSnapshot(),
  );

  final allUsers = <FirebaseResident>[].obs;
  final otherUsers = <FirebaseResident>[].obs;
  final isCommunityMessage = false.obs;

  // ChatController() {
  //   // resident(authController.resident.value);
  //   // fetchAllUsers();
  // }

  // Future<void> fetchAllUsers() async {
  //   // final res = resident.value;
  //   userRef.get().then((snapshot) {
  //     allUsers.value = snapshot.docs.map((snap) => snap.data()).toList();

  //     otherUsers.value = [...allUsers];

  //     otherUsers.retainWhere(
  //         (user) => user.uid != res.id && user.estateId == res.estateId);
  //   });
  // }

  Future<FirebaseResident?> getFirestoreUserBy(String uid) async {
    DocumentSnapshot snapshot =
        await userCollectionRef.doc(uid).snapshots().single;
    return FirebaseResident.fromSnapshot(snapshot);
  }

  Stream<List<FirebaseResident>> getUsersByList(List<String> usersIds) {
    final List<Stream<FirebaseResident>> streams = [];

    for (var id in usersIds) {
      streams.add(userRef.doc(id).snapshots().map(
          (DocumentSnapshot docSnapshot) =>
              FirebaseResident.fromSnapshot(docSnapshot)));
    }
    return StreamZip<FirebaseResident>(streams).asBroadcastStream();
  }

  Stream<QuerySnapshot<FirebaseResident>> getAvailableUsers() =>
      userRef.snapshots();

  Future<DocumentReference> sendChatMessage(
      String convoId, ChatMessage message, List<String> displayNames) async {
    List<String> users = [message.senderId];
    if (message.receiverId != null) users.add(message.receiverId!);

    DocumentReference ref = _db.collection("conversation").doc(convoId);

    DocumentReference docRef = await ref.set({
      'lastMessage': message.toJson(),
      'users': users,
      'displayNames': displayNames,
      'date': DateTime.now().toString()
    }).then((value) {
      return ref.collection("messages").add(message.toJson());
    });

    await docRef.snapshots().first.then((value) {
      if (value.exists) {
        log(value.id);
      }
    });

    return docRef;
  }

  Stream<QuerySnapshot> getChatMessagesBy(String conversationID) {
    return _db
        .collection("conversation")
        .doc(conversationID)
        .collection("messages")
        .orderBy("date", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getConversationsBy(String authUserId) {
    return _db
        .collection("conversation")
        .where("users", arrayContains: authUserId)
        .snapshots();
  }

  Future<DocumentSnapshot> getCommunityChat() {
    return _db.collection("conversation").doc("communityChatConvoID").get();
  }

  Future<String?> getConversationIdFor(
      {required String authUserId, required String remoteUserId}) async {
    QuerySnapshot querySnapshot = await _db
        .collection("conversation")
        .where("users", arrayContains: [authUserId, remoteUserId]).get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    }

    return null;
  }

  void registerPushNotification() async {
    firebaseMessaging = FirebaseMessaging.instance;

    NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true, badge: true, sound: true, provisional: false);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else {
      Get.defaultDialog(
          title: "Notification Permission",
          content:
              CustomText("Please grant permission to show notifications."));
    }
  }

  Stream<DatabaseEvent> fetchConvoMessages(String convoID) {
    return ChatService.fetchMessagesForConvo(convoID);
  }
}
