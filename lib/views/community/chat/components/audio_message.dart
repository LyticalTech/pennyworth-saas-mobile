import 'package:flutter/material.dart';
import 'package:residents/helpers/constants.dart';
import 'package:residents/models/community/chat_message.dart';

class AudioMessage extends StatelessWidget {

  AudioMessage({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.55,
      height: 36,
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding * 0.75,
        vertical: kDefaultPadding / 2.5
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        // color: AppTheme.primaryColor.withOpacity(message.isSender ? 1 : 0.1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.play_arrow_sharp,
            // color: message.isSender ? Colors.white : AppTheme.primaryColor,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 2,
                    // color: message.isSender ? Colors.white : AppTheme.primaryColor.withOpacity(0.4),
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                          // color: message.isSender ? Colors.white : AppTheme.primaryColor,
                          shape: BoxShape.circle
                      ),
                    ),
                  ),
                ]
              ),
            )
          ),
          Text(
            "0.37",
            style: TextStyle(
              // color: message.isSender ? Colors.white : null,
              fontSize: 12
            ),
          ),
        ],
      ),
    );
  }
}