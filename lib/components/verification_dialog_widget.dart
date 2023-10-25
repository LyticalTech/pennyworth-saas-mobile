import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residents/controllers/auth/verification_controller.dart';

import 'auth_components.dart';

class VerificationDialog extends GetResponsiveView<VerificationController> {
  VerificationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(40),
        ),
      ),
      elevation: 10,
      child: FittedBox(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                child: Text(
                  'Please enter "entry code" below',
                  style: GoogleFonts.lato(
                    textStyle: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(
                        color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: Get.width * 0.5,
                child: AuthTextField(
                  controller: controller.verificationTextController,
                  autofocus: true,
                  textInputType: TextInputType.number,
                  hintText: '',
                  icon: Icons.code,
                  validator: null,
                ),
              ),
              Button(
                press: () {
                  if (controller.verificationTextController.text.isEmpty) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                        content: Text(
                          'Please fill out the field to proceed',
                          textAlign: TextAlign.center,
                        )));
                  } else {
                    controller.verifyCode();
                  }
                },
                title: 'Proceed',
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
