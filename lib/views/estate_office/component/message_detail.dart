import 'package:flutter/material.dart';
import 'package:residents/components/text.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessageDetail extends StatelessWidget {
  const MessageDetail({Key? key, required this.message}) : super(key: key);

  final Map<String, String> message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: CustomText("Message Board", textAlign: TextAlign.center)),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            CustomText(message['title'] ?? "",
                size: 16, fontWeight: FontWeight.w500),
            SizedBox(height: 24),
            Divider(height: 1, thickness: 1),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: CustomText(
                (message['created'] != null)
                    ? timeago.format(DateTime.parse(message['created']!))
                    : "",
                size: 12,
                textAlign: TextAlign.end,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 12),
            CustomText(
              message['body'] ?? "",
              size: 14,
              textAlign: TextAlign.start,
            )
          ],
        ),
      ),
    );
  }
}
