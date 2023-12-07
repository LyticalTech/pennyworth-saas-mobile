import 'dart:developer';
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:residents/components/text.dart';
import 'package:residents/controllers/auth/auth_controller.dart';
import 'package:residents/helpers/snackbar.dart';
import 'package:residents/models/chat/message.dart';
import 'package:residents/models/community/chat_message.dart';
import 'package:residents/models/estate_office/resident.dart';
import 'package:residents/models/other/firebase_resident.dart';
import 'package:residents/services/chat_service.dart';
import '../../models/chat/contact.dart';

class ChatController extends GetxController {
  @override
  void onInit() {
    resident = authController.resident;
    _groupChatCollection = _db
        .collection("GroupChat")
        .doc(resident.value.estateName)
        .collection('messages');
    _privateChatCollection = _db
        .collection("PrivateChat")
        .doc(resident.value.estateName)
        .collection('messages');
    _getAllContacts();
    super.onInit();
  }

  TextEditingController message = TextEditingController();

  late final FirebaseMessaging firebaseMessaging;

  final AuthController authController = Get.find();

  final hasCommunity = false.obs;
  late Rx<Resident> resident;
  var groupTextController = TextEditingController();
  var privateTextController = TextEditingController();

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static final CollectionReference userCollectionRef =
      _db.collection("residents");
  late CollectionReference _groupChatCollection;
  late CollectionReference _privateChatCollection;

  final userRef = userCollectionRef.withConverter<FirebaseResident>(
    fromFirestore: (snapshot, _) => FirebaseResident.fromSnapshot(snapshot),
    toFirestore: (resident, _) => resident.toSnapshot(),
  );

  final allUsers = <FirebaseResident>[].obs;
  final otherUsers = <FirebaseResident>[].obs;
  final isCommunityMessage = false.obs;
  final _service = ChatService();
  var contacts = Rx<List<Contact>>([]);

  List<String> _comparParties(String senderId, String receiverId) {
    // return [senderId, receiverId];
    var sendId = int.parse(senderId);
    var recId = int.parse(receiverId);

    if (sendId > recId) return [receiverId, senderId];
    return [senderId, receiverId];
  }

  getGroupChatStream() {
    return _groupChatCollection.orderBy("date", descending: true).snapshots();
  }

  getPrivateChat(int receiverId) {
    var parties = _comparParties(
      resident.value.id.toString(),
      receiverId.toString(),
    );
    return _privateChatCollection
        .where('parties', isEqualTo: parties)
        .orderBy('date', descending: true)
        .snapshots();
  }

  getRecentChat() {
    return _privateChatCollection
        .where('parties', arrayContains: resident.value.id.toString())
        .orderBy("date", descending: true)
        .snapshots();
  }

  sendGroupMessage() async {
    var message = Message(
      receiverName: resident.value.estateName,
      senderName: "${resident.value.firstName} ${resident.value.lastName}",
      senderId: resident.value.id.toString(),
      receiverId: resident.value.estateName,
      message: groupTextController.text.trim(),
      date: DateTime.now(),
    );
    await _groupChatCollection.add(message.toMap());
    groupTextController.clear();
  }

  sendPrivateMessage(int receiverId, String receiverName) async {
    var message = Message(
      receiverName: receiverName,
      senderName: "${resident.value.firstName} ${resident.value.lastName}",
      senderId: resident.value.id.toString(),
      receiverId: receiverId.toString(),
      message: privateTextController.text.trim(),
      date: DateTime.now(),
    );
    await _privateChatCollection.add(message.toMap());
    privateTextController.clear();
  }

  _getAllContacts() async {
    var estateId = resident.value.estateId.toString();
    var res = await _service.getContacts(estateId);
    res.fold(
      (l) => redSnackBar('Error loading contacts'),
      (r) => contacts.value = r,
    );
  }

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
