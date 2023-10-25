import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:residents/controllers/auth/auth_controller.dart';
import 'package:residents/utils/app_theme.dart';

import 'select_image_dialog.dart';

class ImageWidget extends GetResponsiveView<AuthController> {
  ImageWidget({
    Key? key,
  }) : super(key: key) {
    Get.lazyPut(() => AuthController());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
              child: InkWell(
                onTap: () async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) => SelectPhotoDialog(),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(Get.height * 0.003),
                  //Todo: add Image here
                  child: Container(),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(AppTheme.primaryColor),
          ),
        ],
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

  Widget buildCircle({
    required Widget child,
    double all = 0,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
