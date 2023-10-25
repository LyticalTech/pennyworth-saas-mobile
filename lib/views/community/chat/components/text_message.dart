import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:residents/components/text.dart';
import 'package:residents/controllers/community/chat_controller.dart';
import 'package:residents/helpers/constants.dart';
import 'package:residents/models/community/chat_message.dart';
import 'package:residents/utils/app_theme.dart';

class TextMessage extends StatefulWidget {
  TextMessage({required this.message});

  final ChatMessage message;

  @override
  State<TextMessage> createState() => _TextMessageState();
}

class _TextMessageState extends State<TextMessage> {
  final ChatController controller = Get.put(ChatController());

  late String _username;

  @override
  void initState() {
    _username = getUsername(widget.message.senderId) ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isSender = widget.message.senderId == controller.resident.value.id;

    return Column(
      crossAxisAlignment:
          isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: kDefaultPadding * 0.75,
            vertical: kDefaultPadding / 2,
          ),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(isSender ? 1 : 0.1),
            borderRadius: senderSides(isSender),
          ),
          child: Text(
            widget.message.text,
            softWrap: true,
            style: TextStyle(
              color: isSender
                  ? Colors.white
                  : Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
        ),
        if (!isSender)
          Padding(
            padding: EdgeInsets.only(
                top: _username.isNotEmpty ? 4.0 : 0,
                bottom: _username.isNotEmpty ? 8.0 : 0),
            child: CustomText(
              _username,
              textAlign: isSender ? TextAlign.end : TextAlign.start,
              size: 12,
              color: Colors.black38,
            ),
          ),
      ],
    );
  }

  BorderRadiusGeometry senderSides(bool isSender) {
    if (isSender) {
      return BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16));
    } else {
      return BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16));
    }
  }

  String? getUsername(String senderId) {
    if (controller.allUsers.isNotEmpty) {
      var user =
          controller.allUsers.firstWhereOrNull((user) => user.uid == senderId);
      return '${user?.fullName}';
    }
    return null;
  }
}
