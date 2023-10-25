import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({required this.press, required this.alignment, Key? key}) : super(key: key);

  final VoidCallback press;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ClipOval(
        child: Material(
          color: Colors.white, // Button color
          child: InkWell(
            splashColor: Colors.orangeAccent, // Splash color
            onTap: press,
            child: const SizedBox(
              width: 56,
              height: 56,
              child: Icon(Icons.clear, color: Colors.red,),
            ),
          ),
        ),
      ),
    );
  }
}
