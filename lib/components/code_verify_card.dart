import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

String code = '140422';

class CodeGeneratorDialog extends StatefulWidget {
  const CodeGeneratorDialog({Key? key}) : super(key: key);

  @override
  State<CodeGeneratorDialog> createState() => _CodeGeneratorDialogState();
}

class _CodeGeneratorDialogState extends State<CodeGeneratorDialog> {
  final TextEditingController amount = TextEditingController();

  bool opt1 = false;

  bool opt2 = false;

  bool opt3 = false;

  bool codeCardView = false;

  bool loading = false;

  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(40),
        ),
      ),
      elevation: 10,
      child: Stack(
        children: [

          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(
                Icons.clear,
                color: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset("assets/icons/content_copy.svg"),
          const SizedBox(
            width: 12.0,
          ),
          const Text("Copied to Clipboard!"),
        ],
      ),
    );


    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

}
