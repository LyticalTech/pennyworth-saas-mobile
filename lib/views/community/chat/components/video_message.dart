import 'package:flutter/material.dart';
import 'package:residents/components/constants.dart';
import 'package:residents/models/community/chat_message.dart';

class VideoMessage extends StatelessWidget {
  final ChatMessage message;

  VideoMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      child: AspectRatio(
        aspectRatio: 1.6,
        child: Stack(alignment: Alignment.center, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              "assets/images/team_amoto.jpg",
              errorBuilder: (context, object, trace) => Container(
                width: MediaQuery.of(context).size.width * 0.45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white24
                ),
                child: Icon(Icons.error_outline),
              ),
            ),
          ),
          Container(
            height: 25,
            width: 25,
            decoration:
                BoxDecoration(color: kPrimaryColor, shape: BoxShape.circle),
            child: Icon(Icons.play_arrow, size: 16, color: Colors.white),
          ),
        ]),
      ),
    );
  }
}
