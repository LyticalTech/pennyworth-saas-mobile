import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageCheckBox extends StatelessWidget {
  const ImageCheckBox({required this.controller, required this.label, Key? key}) : super(key: key);

  final RxBool controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
        return Row(
          children: [
            Checkbox(
              value: controller.value,
              activeColor: Colors.orange,
              onChanged: (value) => controller.toggle(),
            ),
            Text(label),
          ],
        );
      }
    );
  }
}
