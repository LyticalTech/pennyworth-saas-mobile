import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:residents/controllers/auth/auth_controller.dart';
import 'package:residents/controllers/community/chat_controller.dart';
import 'package:residents/helpers/constants.dart';
import 'package:residents/models/community/chat_message.dart';
import 'package:residents/models/other/firebase_resident.dart';
import 'package:residents/services/chat_service.dart';
import 'package:residents/utils/app_theme.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({
    Key? key,
    required this.receiver,
    required this.convoId,
    this.isCommunity = false,
  }) : super(key: key);

  final FirebaseResident? receiver;
  final String convoId;
  final bool isCommunity;

  @override
  ChatInputFieldState createState() => ChatInputFieldState();
}

class ChatInputFieldState extends State<ChatInputField> {
  var hasText = false;

  final ChatController _controller = Get.find();
  final AuthController _authController = Get.find();

  void _chatTextChanged(String message) {
    setState(() {
      hasText = message.isNotEmpty;
    });
  }

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    String? receiverId = widget.receiver?.uid;

    if (_controller.message.text.isNotEmpty) {
      final message = ChatMessage(
        senderId: _authController.resident.value.id!,
        receiverId: receiverId,
        text: _controller.message.text.trim(),
        messageType: ChatMessageType.text.value,
        messageStatus: MessageStatus.unread.value,
        date: DateTime.now().toString(),
      );

      ChatService.saveMessage(
        authUser: FirebaseResident.fromResident(_authController.resident.value),
        recipient: widget.receiver,
        convoId: widget.convoId,
        message: message,
        isCommunity: widget.isCommunity,
      ).then((_) {
        _controller.message.text = "";
        setState(() {
          hasText = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: kDefaultPadding / 2,
        horizontal: kDefaultPadding / 1.5,
      ),
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 32,
              color: Color(0xFF087949).withOpacity(0.08),
            )
          ]),
      child: SafeArea(
        child: Row(
          children: [
            Icon(
              Icons.camera_alt_outlined,
              color: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .color!
                  .withOpacity(0.64),
            ),
            SizedBox(
              width: kDefaultPadding / 2,
            ),
            Expanded(
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: kDefaultPadding * 0.75),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: kDefaultPadding / 4,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller.message,
                        textInputAction: TextInputAction.send,
                        minLines: 1,
                        maxLines: 3,
                        onSubmitted: (value) => _sendMessage(),
                        onChanged: _chatTextChanged,
                        decoration: InputDecoration(
                          hintText: "type message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: kDefaultPadding / 4,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: kDefaultPadding / 2,
            ),
            if (hasText)
              IconButton(
                onPressed: _sendMessage,
                icon: Icon(
                  Icons.send,
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.64),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
