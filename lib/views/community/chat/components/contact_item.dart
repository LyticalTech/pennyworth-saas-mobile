import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:residents/components/text.dart';
import 'package:residents/controllers/auth/auth_controller.dart';
import 'package:residents/models/estate_office/resident.dart';
import 'package:residents/models/other/firebase_resident.dart';
import 'package:residents/views/community/chat/messages.dart';

class ContactItem extends StatefulWidget {
  ContactItem({
    Key? key,
    required this.remoteUser,
  }) : super(key: key);

  final FirebaseResident remoteUser;

  @override
  State<ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {

  final AuthController _authController = Get.find();
  late Resident resident;

  @override
  void initState() {
    resident = _authController.resident.value;
    super.initState();
  }

  void _gotoConversationScreen() async {
    Get.off(() => MessagesScreen(remoteUser: widget.remoteUser));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _gotoConversationScreen();
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
              widget.remoteUser.fullName,
              size: 17,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
