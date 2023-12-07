import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:residents/controllers/community/chat_controller.dart';
import 'package:residents/models/chat/message.dart';
import 'package:residents/views/community/chat/components/chat_bubble.dart';

import '../../../components/text.dart';

class GroupChatPage extends StatelessWidget {
  const GroupChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    ChatController controller = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            BackButton(),
            Column(
              children: [
                CustomText(
                  controller.resident.value.estateName,
                  size: 17,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: controller.getGroupChatStream(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text("An Error has occurred please retry"));
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var message =
                        Message.fromFirestore(snapshot.data!.docs[index]);
                    return MessageBubble(message: message);
                  },
                );
              },
            ),
          ),
          TextField(
            controller: controller.groupTextController,
            minLines: 1,
            maxLines: 4,
            decoration: InputDecoration(
              fillColor: Colors.grey.shade800,
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.send_rounded,
                  color: Colors.red,
                ),
                onPressed: () => controller.sendGroupMessage(),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              contentPadding: EdgeInsets.all(14),
            ),
          )
        ],
      ),
    );
  }
}
