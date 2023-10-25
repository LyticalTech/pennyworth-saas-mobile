import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Shield extends StatelessWidget {
  const Shield({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/pattern.png"),
        ),
      ),
      child: Image.asset(
        "assets/images/shield.png",
        height: Get.height * 0.4, //40%
      ),
    );
  }
}
