import 'package:flutter/material.dart';
import 'package:residents/helpers/constants.dart';
import 'package:residents/models/community/chat_message.dart';
import 'package:residents/views/community/chat/components/chat_input.dart';
import 'package:residents/views/community/chat/components/message.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 0.75),
            child: ListView.builder(
              itemCount: 0,
              // itemBuilder: (context, index) => Message(message: ,)
              itemBuilder: (context, snapshot) => Container(),
            ),
          )
        ),
        // ChatInputField()
      ],
    );
  }

}
