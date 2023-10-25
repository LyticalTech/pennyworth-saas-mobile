import 'dart:io';

import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    Key? key,
    required this.label,
    this.controller,
    this.hint,
    this.maxLine,
    this.textInputAction,
    this.textInputType,
    this.onChanged,
    this.hasError = false,
  }) : super(key: key);

  final TextEditingController? controller;
  final String label;
  final String? hint;
  final int? maxLine;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final bool hasError;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Platform.isIOS ? 52 : 48,
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.only(bottom: 0),
      child: TextField(
          textInputAction: textInputAction,
          keyboardType: textInputType,
          maxLines: maxLine,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: label,
            hintStyle: TextStyle(color: Colors.black26),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(
                color: hasError ? Colors.red : Colors.black54,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(
                color: hasError ? Colors.red : Colors.black54,
              ),
            ),
          ),
      ),
    );
  }
}