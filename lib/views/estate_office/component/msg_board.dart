import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:residents/components/text.dart';
import 'package:residents/controllers/office/estate_office_controller.dart';
import 'package:residents/utils/helper_functions.dart';
import 'package:residents/views/estate_office/component/message_detail.dart';

class MessageBoard extends StatelessWidget {
  final EstateOfficeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: controller.getMessageBoard(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: ListView.separated(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final message = snapshot.data!.docs[index];

                DateTime date = DateTime.fromMillisecondsSinceEpoch(message['created']);
                final formattedDate = DateFormat("dd, MMMM, yyyy").format(date);

                return ListTile(
                  onTap: () => Get.to(
                    () => MessageDetail(message: {
                      'title': message['title'],
                      'body': message['body'],
                      'created': DateTime.fromMillisecondsSinceEpoch(message['created']).toString(),
                    }),
                  ),
                  title: Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: CustomText(
                      message['title'],
                      maxLine: 1,
                      size: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(left: 12.0, top: 6),
                    child: CustomText(
                      message['body'],
                      maxLine: 2,
                      size: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  trailing: Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: CustomText(
                      formattedDate,
                      size: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                );
              },
              separatorBuilder: (context, index) => Divider(
                thickness: 1,
                height: 3,
                color: Colors.black12,
              ),
            ),
          );
        } else if (snapshot.hasData && (snapshot.data == null || snapshot.data!.docs.isEmpty)) {
          return Column(
            children: [
              Spacer(flex: 1),
              Center(child: Lottie.asset("assets/lottie/empty.json")),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomText(
                  "No messages at the moment!",
                  fontWeight: FontWeight.w300,
                  size: 20,
                ),
              ),
              Spacer(flex: 3),
            ],
          );
        } else {
          return Center(child: customActivityIndicator(size: 32));
        }
      },
    );
  }
}
