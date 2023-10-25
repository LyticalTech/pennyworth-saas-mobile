import 'package:flutter/material.dart';

class PleaseWaitDialog extends StatelessWidget {
  const PleaseWaitDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const <Widget>[
          CircularProgressIndicator(),
          Text('Please wait...'),
        ],
      ),
    );
  }
}
