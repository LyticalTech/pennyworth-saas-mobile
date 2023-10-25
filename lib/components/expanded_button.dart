import 'package:flutter/material.dart';

class ExpandedButton extends StatelessWidget {
  const ExpandedButton({
    Key? key, required this.title, required this.onPressed,
  }) : super(key: key);

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: onPressed,
            child: Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black),),
          ),
        )
    );
  }
}