import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:residents/controllers/community/chat_controller.dart';
import 'package:residents/utils/logger.dart';

import 'package:residents/views/community/chat/contact_list.dart';
import 'package:residents/views/community/chat/group_chat.dart';
import 'package:residents/views/community/chat/private_chat.dart';

import '../../../models/chat/message.dart';

class Chats extends StatefulWidget {
  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final ChatController _controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    final resident = _controller.resident.value;

    String getSenderName({
      required String receiverName,
      required String senderName,
    }) {
      return senderName == resident.fullName ? receiverName : senderName;
    }

    int getReceiverId({
      required String receiverId,
      required String senderId,
    }) {
      int idSender = int.tryParse(senderId) ?? 0;
      int idReceiver = int.tryParse(receiverId) ?? 0;

      return idSender == resident.id ? idReceiver : idSender;
      // return idSender == resident.id ? idReceiver : idSender;
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Column(
            children: [
              ListTile(
                leading: Icon(
                  Icons.account_circle_sharp,
                  size: 52,
                  color: Colors.black54,
                ),
                onTap: () => Get.to(() => GroupChatPage()),
                title: Text(
                  resident.estateName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: _controller.getRecentChat(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("An Error has occurred please retry"),
                      );
                    }
                    List<Message> messageList = [];
                    var names = [];
                    for (int i = 0; i < snapshot.data!.docs.length; i++) {
                      var parsedMessage =
                          Message.fromFirestore(snapshot.data!.docs[i]);

                      var name = getSenderName(
                        receiverName: parsedMessage.receiverName,
                        senderName: parsedMessage.senderName,
                      );

                      if (!names.contains(name)) {
                        names.add(name);
                        messageList.add(parsedMessage);
                        logger.i(names);
                      }
                    }

                    return ListView.builder(
                      itemCount: messageList.length,
                      itemBuilder: (context, index) {
                        // var message =
                        //     Message.fromFirestore(snapshot.data!.docs[index]);

                        return ListTile(
                          leading: Icon(
                            Icons.account_circle_sharp,
                            size: 52,
                            color: const Color.fromARGB(137, 100, 44, 44),
                          ),
                          onTap: () => Get.to(
                            () => PrivateChat(
                                receiverName: getSenderName(
                                  receiverName: messageList[index].senderName,
                                  senderName: messageList[index].receiverName,
                                ),
                                receiverId: getReceiverId(
                                  receiverId: messageList[index].receiverId,
                                  senderId: messageList[index].senderId,
                                )),
                          ),
                          title: Text(
                            getSenderName(
                              receiverName: messageList[index].receiverName,
                              senderName: messageList[index].senderName,
                            ),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: () {
                showCupertinoModalBottomSheet(
                  context: context,
                  elevation: 8,
                  builder: (context) => ContactsList(),
                );
              },
              child: Icon(Icons.chat_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
