import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:residents/helpers/constants.dart';
import 'package:residents/utils/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final Widget? prefix;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final Color? color;

  CustomTextField({
    this.controller,
    this.label,
    this.hint,
    this.obscureText,
    this.keyboardType,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return TextFormField(
        controller: controller,
        obscureText: obscureText ?? false,
        obscuringCharacter: '*',
        keyboardType: keyboardType,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: suffix,
          suffixIconColor: Colors.black87,
          enabledBorder: borderOutline(),
          focusedBorder: borderOutline(),
        ),
        onChanged: onChanged,
      );
    } else {
      return CupertinoTextField(
        controller: controller,
        placeholder: hint,
        obscureText: obscureText ?? false,
        obscuringCharacter: '*',
        keyboardType: keyboardType,
        onChanged: onChanged,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        placeholderStyle: TextStyle(color: Colors.black26),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.primaryLightColor),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        style: TextStyle(color: Colors.black),
        suffix: Padding(
          padding: EdgeInsets.only(right: kDefaultPadding),
          child: suffix,
        ),
      );
    }
  }
}

class CustomTextArea extends StatelessWidget {
  CustomTextArea({
    this.controller,
    this.hintText,
    this.height,
    this.minLines,
    this.maxLines,
    this.onChanged,
    this.focusNode,
    this.textInputAction,
    this.textInputType,
    this.hasError = false,
  });

  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final String? hintText;
  final double? height;
  final int? minLines;
  final int? maxLines;
  final bool? hasError;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Padding(
        padding: EdgeInsets.only(bottom: 12.0),
        child: CupertinoTextField(
          onTap: () {
            _dismissKeyboard(context);
          },
          controller: controller,
          placeholder: hintText,
          focusNode: focusNode,
          placeholderStyle: _placeHolderStyle(),
          style: _textStyle(),
          maxLines: maxLines ?? 3,
          onChanged: onChanged,
          textInputAction: textInputAction,
          keyboardType: textInputType,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: hasError == true
                ? Border.all(color: Colors.red)
                : Border.all(color: Colors.black54),
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(bottom: 12.0),
        child: TextFormField(
          onTap: () {
            _dismissKeyboard(context);
          },
          controller: controller,
          focusNode: focusNode,
          style: _textStyle(),
          textAlign: TextAlign.start,
          maxLines: maxLines ?? 3,
          onChanged: onChanged,
          textInputAction: textInputAction,
          keyboardType: textInputType,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            hintText: hintText,
            hintStyle: _placeHolderStyle(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: hasError == true ? Colors.red : Colors.black54),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: AppTheme.primaryColor),
            ),
          ),
        ),
      );
    }
  }

  TextStyle _placeHolderStyle() {
    return TextStyle(color: Colors.black26);
  }

  TextStyle _textStyle() {
    return TextStyle(color: Colors.black87, fontWeight: FontWeight.normal, height: height ?? 1.4);
  }

  void _dismissKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}

OutlineInputBorder borderOutline() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(6.0),
    borderSide: BorderSide(color: Colors.black26),
    gapPadding: 10.0,
  );
}
