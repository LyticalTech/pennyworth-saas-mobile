import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:residents/components/text.dart';
import 'package:residents/controllers/community/chat_controller.dart';
import 'package:residents/models/community/chat.dart';
import 'package:residents/models/community/convo_item.dart';
import 'package:residents/models/other/firebase_resident.dart';
import 'package:residents/services/chat_service.dart';
import 'package:residents/views/community/chat/contact_list.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'components/chat_tile.dart';
import 'messages.dart';

class Chats extends StatefulWidget {
  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final ChatController _controller = Get.put(ChatController());
  late String _estateGroup;
  late String _estateId;

  FirebaseResident? receiver;

  @override
  void initState() {
    super.initState();
    _estateGroup = _controller.resident.value.estateName ?? "Estate";
    _estateId = _controller.resident.value.estateId ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final residentId = _controller.resident.value.id ?? "";
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Column(
            children: [
              StreamBuilder<DatabaseEvent>(
                stream: ChatService.fetchCommunityConvoInfo(_estateId),
                builder: (context, snapshot) {
                  final result = snapshot.data?.snapshot.value as Map<dynamic, dynamic>?;

                  log(result.toString());
                  if (result != null) {
                    final convo = ConvoItem.fromJson(result);
                    log(convo.toString());
                  }
                  return ChatTile(
                    chat: Chat(
                      name: _estateGroup,
                      lastMessage: "",
                      time: "",
                    ),
                    onTap: () {
                      Get.to(() => MessagesScreen(conversationID: _estateId, isCommunity: true));
                    },
                  );
                },
              ),
              Expanded(
                child: StreamBuilder<DatabaseEvent>(
                  stream: ChatService.fetchUserConvoHistory(residentId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final result = snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;
                      final convoList =
                          result?.values.map((convo) => ConvoItem.fromJson(convo)).toList() ?? [];
                      if (convoList.isNotEmpty) {
                        return ListView.builder(
                          itemCount: convoList.length,
                          itemBuilder: (context, index) {
                            final convoInfo = convoList[index];
                            return ChatTile(
                              chat: Chat(
                                name: convoInfo.fullName ?? "",
                                lastMessage: convoInfo.lastMessage ?? "",
                                time: convoInfo.dateTime != null
                                    ? timeago.format(DateTime.parse(convoInfo.dateTime!))
                                    : "",
                              ),
                              onTap: () {
                                Get.to(() => MessagesScreen(convoInfo: convoInfo));
                              },
                            );
                          },
                        );
                      }
                    } else if (snapshot.hasError) {
                      return Column(
                        children: [
                          Spacer(flex: 2),
                          Center(child: Lottie.asset("assets/lottie/error_lady.json")),
                          Spacer(flex: 1),
                          CustomText(
                            "Error loading chat history.",
                            textAlign: TextAlign.center,
                            size: 20,
                            fontWeight: FontWeight.w300,
                          ),
                          Spacer(flex: 3),
                        ],
                      );
                    }
                    return SizedBox.shrink();
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
