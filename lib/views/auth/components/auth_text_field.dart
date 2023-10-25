import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final String? hintText;
  final String? initialValue;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final bool autofocus;
  final IconData? icon;
  final int maxLine;
  final bool? enable;
  final TextAlign? align;

  const AuthTextField({
    Key? key,
    this.controller,
    this.textInputType,
    this.hintText,
    this.validator,
    this.focusNode,
    this.autofocus = false,
    this.icon,
    this.maxLine = 1,
    this.initialValue,
    this.enable,
    this.align,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      focusNode: focusNode,
      autofocus: false,
      textCapitalization: TextCapitalization.none,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: Colors.orange,
      keyboardType: textInputType,
      maxLines: maxLine,
      initialValue: initialValue,
      enabled: enable,
      textAlign: align ?? TextAlign.start,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepOrange),
        ),
        hintStyle: TextStyle(color: Colors.black26),
        prefixIcon: Icon(
          icon,
          color: Colors.orange,
        ),
        hintText: hintText,
      ),
    );
  }
}
