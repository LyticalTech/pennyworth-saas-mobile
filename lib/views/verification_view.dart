import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:residents/components/logo_widget.dart';
import 'package:residents/controllers/auth/auth_controller.dart';

import '../components/action_button.dart';
import '../controllers/auth/verification_controller.dart';

class VerificationView extends GetResponsiveView<VerificationController> {
  VerificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => VerificationController());
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: Get.width * 0.01,
          ).copyWith(top: Get.height * 0.01),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: const Shield(),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: Get.width * 0.1)
                      .copyWith(top: Get.height * 0.02),
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    children: [
                      ActionButton(
                        buttonColor: Colors.orange,
                        icon: const Icon(
                          Icons.vpn_key_outlined,
                          color: Colors.white,
                        ),
                        label: 'Verify Code',
                        press: () {
                          controller.showVerificationDialog();
                        },
                        textColor: Colors.white,
                      ),
                      ActionButton(
                        buttonColor: Colors.red,
                        icon: const Icon(
                          Icons.power_settings_new_outlined,
                          color: Colors.white,
                        ),
                        label: 'Sign Out',
                        press: () {
                          final authController = Get.put(AuthController());
                          authController.guardsSignOut();
                        },
                        textColor: Colors.white,
                      ),
                    ],
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
