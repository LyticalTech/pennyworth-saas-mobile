import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:residents/controllers/community/chat_controller.dart';

import '../../../../models/chat/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    ChatController controller = Get.find();
    var isMyMessage =
        controller.resident.value.id.toString() == message.senderId;
    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isMyMessage ? Colors.red : Colors.orange.shade800,
          borderRadius: BorderRadius.circular(3.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.senderName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              message.message,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              message.date.toString(),
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
