import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:residents/components/text.dart';
import 'package:residents/controllers/community/chat_controller.dart';
import 'package:residents/models/other/firebase_resident.dart';
import 'package:residents/views/community/chat/components/contact_item.dart';
import 'package:residents/views/community/chat/messages.dart';

class ContactsList extends StatefulWidget {
  ContactsList({Key? key}) : super(key: key);

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  final ChatController controller = Get.put(ChatController());
  late String _estateGroup;
  late String _estateId;

  @override
  void initState() {
    super.initState();
    _estateGroup = controller.resident.value.estateName ?? "Estate";
    _estateId = controller.resident.value.estateId ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contacts"), centerTitle: true, elevation: 0),
      body: StreamBuilder<QuerySnapshot<FirebaseResident>>(
        stream: controller.getAvailableUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.size > 0) {



            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Get.off(() => MessagesScreen(conversationID: _estateId, isCommunity: true));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12, top: 12.0, right: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            margin: EdgeInsets.only(right: 12),
                            child: Icon(
                              Icons.account_circle,
                              size: 44,
                              color: Colors.black38,
                            ),
                          ),
                          CustomText(
                            _estateGroup,
                            size: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.otherUsers.length,
                      itemBuilder: (context, index) {
                        return ContactItem(remoteUser: controller.otherUsers[index]);
                      },
                    ),
                  )
                ],
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
