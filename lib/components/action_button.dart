import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActionButton extends StatelessWidget {
  const ActionButton(
      {required this.icon,
      required this.label,
      required this.press,
      required this.buttonColor,
      required this.textColor,
      Key? key})
      : super(key: key);

  final Icon icon;
  final Color buttonColor;
  final Color textColor;
  final String label;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: buttonColor,
        shadowColor: Colors.grey,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      onPressed: press,
      child: FittedBox(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              icon,
              FittedBox(
                child: Text(
                  label,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: textColor,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
