import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:residents/controllers/auth/auth_controller.dart';
import 'package:residents/utils/app_theme.dart';

class SelectPhotoDialog extends GetResponsiveView<AuthController> {
  SelectPhotoDialog({Key? key}) : super(key: key) {
    Get.lazyPut(() => AuthController());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        height: Get.height * .25,
        width: Get.width * .85,
        decoration: BoxDecoration(
          color: AppTheme.nearlyWhite,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(
                    Icons.photo_camera,
                    color: AppTheme.primaryColor,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Select a photo',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.nearlyBlack,
                      ),
                    ),
                  )
                ],
              ),
              const Divider(
                thickness: 2,
                color: AppTheme.primaryColor,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () async {
                    //controller.imageFile.value = await photoServices.onCamera();
                  },
                  child: const Text(
                    'From Camera',
                    style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      fontSize: 16,
                      color: AppTheme.nearlyBlack,
                    ),
                  ),
                ),
              ),
              const Divider(
                thickness: 2,
                indent: 60,
                endIndent: 60,
                color: AppTheme.primaryColor,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () async {
                  },
                  child: const Text(
                    'From Gallery',
                    style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      fontSize: 16,
                      color: AppTheme.nearlyBlack,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
