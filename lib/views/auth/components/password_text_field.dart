import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final String?Function(String?)? validator;
  final TextEditingController controller;
  const PasswordTextField({
    Key? key,
    required this.validator,
    required this.controller,
  }) : super(key: key);

  @override
  PasswordTextFieldState createState() => PasswordTextFieldState();
}

class PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        cursorColor: Colors.orange,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
          focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.deepOrange)),
          prefixIcon: const Icon(
            Icons.lock,
            color: Colors.orange,
          ),
          hintText: "Password",
          suffixIcon: IconButton(
            icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
            color: Colors.orange,
            onPressed: _toggle,
          ),
        ));
  }
}