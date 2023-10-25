import 'dart:developer';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:residents/components/text.dart';
import 'package:residents/controllers/community/chat_controller.dart';
import 'package:residents/helpers/constants.dart';
import 'package:residents/models/community/chat_message.dart';
import 'package:residents/models/community/convo_item.dart';
import 'package:residents/models/other/firebase_resident.dart';
import 'package:residents/services/chat_service.dart';
import 'package:residents/views/community/chat/components/chat_input.dart';
import 'package:residents/views/community/chat/components/message.dart';

class MessagesScreen extends StatefulWidget {
  final FirebaseResident? remoteUser;
  final String? conversationID;
  final ConvoItem? convoInfo;
  final bool isCommunity;

  MessagesScreen(
      {this.remoteUser,
      this.conversationID,
      this.convoInfo,
      this.isCommunity = false});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final ChatController controller = Get.find();

  late FirebaseResident localUser;
  late FirebaseResident? remoteUser;

  String? _conversationID;
  String? remoteUserName = "";

  @override
  void initState() {
    super.initState();
    localUser = FirebaseResident.fromResident(controller.resident.value);
    remoteUser = widget.remoteUser;
    remoteUserName = widget.convoInfo != null
        ? widget.convoInfo!.fullName
        : remoteUser?.fullName;

    log("Local user estate Id is: ${localUser.estateId}");
    checkConvoId();
  }

  Future<void> checkConvoId() async {
    /// ConvoInfo is not null
    /// From Convo List Screen
    if (widget.convoInfo != null) {
      _conversationID = widget.convoInfo!.convoId!;
    } else if (widget.isCommunity && widget.conversationID != null) {
      _conversationID = widget.conversationID;
      remoteUserName = controller.resident.value.estateName;
    } else {
      /// From Contact List
      final convoId = await ChatService.fetchConversationIdFor(
          localUser.uid!, remoteUser!.uid!);
      if (convoId != null) {
        _conversationID = convoId;
      } else {
        _conversationID = "${localUser.uid!}_${remoteUser!.uid!}";
      }
    }
    setState(() {});
  }

  Stream<DatabaseEvent>? fetchConvoMessages() {
    if (_conversationID != null) {
      return ChatService.fetchMessagesForConvo(_conversationID!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: kDefaultPadding * 0.75,
                bottom: Platform.isIOS ? 0 : kDefaultPadding * 0.5,
                right: kDefaultPadding * 0.75,
              ),
              child: StreamBuilder<DatabaseEvent>(
                stream: fetchConvoMessages(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data?.snapshot.value != null) {
                    final data =
                        snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                    log(data.toString());
                    final messages = data.values
                        .map((msg) => ChatMessage.fromJson(msg))
                        .toList();
                    messages.sort((a, b) => b.date.compareTo(a.date));
                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) =>
                          Message(message: messages[index]),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
          ChatInputField(
            receiver: widget.remoteUser,
            isCommunity: widget.isCommunity,
            convoId: _conversationID ?? "",
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          BackButton(),
          Column(
            children: [
              CustomText(
                remoteUserName ?? "",
                size: 17,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ],
      ),
      automaticallyImplyLeading: false,
    );
  }
}
