import 'package:flutter/material.dart';

class AccountCheck extends StatelessWidget {
  final bool login;
  final VoidCallback press;
  const AccountCheck({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          !login ? "Don’t have an Account ? " : "Already have an Account ? ",
          style: const TextStyle(color: Colors.orange, fontSize: 15),
        ),
        TextButton(
          onPressed: press,
          child: Text(
            !login ? "Sign Up" : "Sign In",
            style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 15,
            ),
          ),
        )
      ],
    );
  }
}
