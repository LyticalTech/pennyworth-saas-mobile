import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residents/components/cancel_button.dart';
import 'package:residents/components/image_check_box.dart';
import 'package:residents/components/share_icon.dart';
import 'package:residents/controllers/shield/code_controller.dart';

class CodeGeneratorDialog extends GetResponsiveView<CodeController> {
  CodeGeneratorDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CodeController());
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CancelButton(
            alignment: Alignment.centerRight,
            press: () {
              Navigator.pop(context);
              Get.delete<CodeController>();
            },
          ),
          PageTransitionSwitcher(
            // reverse: true, // uncomment to see transition in reverse
            transitionBuilder: (
              Widget child,
              Animation<double> primaryAnimation,
              Animation<double> secondaryAnimation,
            ) {
              return SharedAxisTransition(
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                fillColor: Colors.transparent,
                child: child,
              );
            },
            child: Obx(
              () => controller.shareCode.value ? shareCard() : generateCard(),
            ),
          ),
        ],
      ),
    );
  }

  Widget shareCard() => Card(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                child: Text(
                  'Share code with guest',
                  style: GoogleFonts.lato(
                    textStyle: Theme.of(Get.context!)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 16), // Omotayo Added this for spacing
              FittedBox(
                child: Text(
                  controller.code.code,
                  style: GoogleFonts.lato(
                    textStyle: Theme.of(Get.context!)
                        .textTheme
                        .headline4!
                        .copyWith(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 16), // Omotayo Added this for spacing
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ShareIcon(
                    iconSrc: "assets/icons/whatsapp.svg",
                    press: controller.shareCodeOnWhatsApp,
                  ),
                  // COMMENTED THIS OUT AS REQUESTED BY MR JOHN UNTIL SHARE
                  // BY SMS IS IMPLEMENTED.
                  // ShareIcon(
                  //   iconSrc: "assets/icons/textsms.svg",
                  //   press: () {},
                  // ),
                  ShareIcon(
                    iconSrc: "assets/icons/content_copy.svg",
                    press: controller.copyCode,
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Card generateCard() => Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 50,
              color: Colors.deepOrange,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                "Select Security Actions",
                style: GoogleFonts.lato(
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageCheckBox(
                  controller: controller.visitorImage,
                  label: 'Visitor\'s Image',
                ),
                ImageCheckBox(
                  controller: controller.vehicleImage,
                  label: 'Vehicle\'s Image',
                ),
                ImageCheckBox(
                  controller: controller.id,
                  label: 'Id Card\'s Image',
                ),
              ],
            ),
            Container(
              width: double.infinity,
              height: 50,
              color: Colors.deepOrange,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 8),
              child: Center(
                child: Obx(
                  () => controller.isGeneratingCode.value
                      ? CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        )
                      : TextButton(
                          onPressed: () => controller.generateCode(),
                          child: Text(
                            'Generate',
                            style: GoogleFonts.lato(
                                fontSize: 25,
                                letterSpacing: 5,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      );
}
