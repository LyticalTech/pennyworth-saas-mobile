import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:residents/controllers/shield/image_controller.dart';

import '../utils/app_theme.dart';

class ImageWidget extends GetResponsiveView<ImageController> {
  ImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Center(
      child: InkWell(
        onTap: controller.pickImage,
        child: Stack(
          children: [
            ClipOval(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.primaryColor,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Obx(
                    () {
                      return controller.image.value;
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 4,
              child: buildEditIcon(color),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        child: buildCircle(
          color: color,
          all: 8,
          child: const Icon(
            Icons.add_a_photo_outlined,
            color: Colors.white,
            size: 12,
          ),
        ),
      );

  Widget buildCircle({required Widget child, double all = 0, required Color color}) =>
      ClipOval(child: Container(padding: EdgeInsets.all(all), color: color, child: child));
}
