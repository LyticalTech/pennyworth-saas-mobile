import 'package:flutter/material.dart';
import 'package:residents/components/text.dart';
import 'package:residents/utils/app_theme.dart';

class FilledButtons extends StatelessWidget {
  const FilledButtons({
    Key? key, required this.title, required this.onPressed, this.color,
  }) : super(key: key);

  final String title;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: color ?? AppTheme.primaryColor,
          foregroundColor: Colors.white,
        ),
        child: CustomText(title),
      ),
    );
  }
}