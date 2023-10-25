import 'package:flutter/material.dart';

class CustomRoundButton extends StatelessWidget {
  const CustomRoundButton({
        required this.press,
        required this.alignment,
        required this.icon,
        this.color = Colors.white,
        Key? key,
  }) : super(key: key);

  final VoidCallback press;
  final AlignmentGeometry alignment;
  final Icon icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ClipOval(
        child: Material(
          color: color, // Button color
          child: InkWell(
            splashColor: Colors.orangeAccent, // Splash color
            onTap: press,
            child: SizedBox(
              width: 56,
              height: 56,
              child: icon,
            ),
          ),
        ),
      ),
    );
  }
}
