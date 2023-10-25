import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:residents/controllers/auth/auth_controller.dart';
import 'package:residents/helpers/constants.dart';
import 'package:residents/models/community/chat_message.dart';
import 'package:residents/views/community/chat/components/audio_message.dart';
import 'package:residents/views/community/chat/components/image_message.dart';
import 'package:residents/views/community/chat/components/text_message.dart';
import 'package:residents/views/community/chat/components/video_message.dart';

class Message extends StatelessWidget {
  Message({
    Key? key,
    required this.message,
  }) : super(key: key);

  final ChatMessage message;
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    Widget messageContainer(ChatMessage message) {
      switch (message.messageType) {
        case "image":
          return ImageMessage(message: message);
        case "audio":
          return AudioMessage(message: message);
        case "video":
          return VideoMessage(message: message);
        default:
          return TextMessage(message: message);
      }
    }

    return Padding(
      padding: EdgeInsets.only(top: kDefaultPadding * 0.25),
      child: Row(
        mainAxisAlignment: message.senderId == authController.resident.value.id
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          messageContainer(message),
        ],
      ),
    );
  }
}
