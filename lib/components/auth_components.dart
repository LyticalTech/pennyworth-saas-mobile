import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String title;
  final VoidCallback press;
  final Color color, textColor;
  const Button({
    Key? key,
    required this.title,
    required this.press,
    required this.color,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
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
                  fontWeight: FontWeight.w900
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.orange,
          ),
        ),
      ),
      child: child,
    );
  }
}

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final String hintText;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final bool autofocus;
  final IconData icon;


  const AuthTextField({
    Key? key,
    required this.controller,
    required this.textInputType,
    required this.hintText,
    this.validator,
    this.focusNode,
    this.autofocus = false,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        validator: validator,
        focusNode: focusNode,
        autofocus: false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        cursorColor: Colors.orange,
        keyboardType: textInputType,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
          focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.deepOrange)),
          prefixIcon: Icon(
            icon,
            color: Colors.orange,
          ),
          hintText: hintText,
        )
    );
  }
}

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