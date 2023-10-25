import 'package:flutter/material.dart';
import 'package:residents/helpers/constants.dart';
import 'package:residents/models/community/chat.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    Key? key,
    required this.chat,
    required this.onTap,
  }) : super(key: key);

  final Chat chat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
          vertical: kDefaultPadding * 0.75,
        ),
        child: Row(
          children: [
            Icon(Icons.account_circle_sharp, size: 52, color: Colors.black54),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: kDefaultPadding, left: kDefaultPadding / 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(chat.name, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                    SizedBox(height: 4),
                    Opacity(
                      opacity: 0.75,
                      child: Text(
                        chat.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Opacity(opacity: 0.75, child: Text(chat.time))
          ],
        ),
      ),
    );
  }
}
