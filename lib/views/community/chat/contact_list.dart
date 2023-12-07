import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:residents/controllers/community/chat_controller.dart';
import 'package:residents/views/community/chat/private_chat.dart';

class ContactsList extends StatefulWidget {
  ContactsList({super.key});

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  final ChatController controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(
        () => ListView.builder(
            itemCount: controller.contacts.value.length,
            itemBuilder: (context, index) {
              var contact = controller.contacts.value[index];
              return ListTile(
                onTap: () {
                  Get.to(
                    () => PrivateChat(
                      receiverId: contact.residentId,
                      receiverName: "${contact.firstName} ${contact.lastName}",
                    ),
                  );
                },
                leading: Icon(Icons.person_outlined),
                title: Text("${contact.firstName} ${contact.lastName}"),
              );
            }),
      ),
    );
  }
}
