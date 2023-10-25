import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthButton extends StatelessWidget {
  final String title;
  final VoidCallback press;
  final Color color, textColor;
  const AuthButton({
    Key? key,
    required this.title,
    required this.press,
    required this.color,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: Get.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            backgroundColor: color,
          ),
          onPressed: press,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              title,
              style: TextStyle(
                  color: textColor,
                  letterSpacing: 5,
                  wordSpacing: 3,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}