import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residents/controllers/auth/auth_controller.dart';
import 'package:residents/utils/validator.dart';

import '../../../components/auth_components.dart';
import 'cancel_button.dart';

class InputEmailDialog extends GetResponsiveView<AuthController> {
  InputEmailDialog({required this.link, Key? key}) : super(key: key){
    Get.lazyPut(() => AuthController());
  }

  final String link;
  final TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomRoundButton(
              icon: const Icon(Icons.clear, color: Colors.red),
              alignment: Alignment.centerRight,
              press: () {
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                ),
                shape: BoxShape.rectangle,
                color: Colors.white
            ),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: Get.width,
                  height: 50,
                  color: Colors.deepOrange,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    "Provide Email Address",
                    style: GoogleFonts.lato(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  width: Get.width,
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: Get.width * 0.06),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    children: [
                      Center(
                        child: RichText(
                            maxLines: 5,
                            text: TextSpan(
                                text: 'Note: ',
                                style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                      'Please only input the email address for which you received a link.',
                                      style: GoogleFonts.oswald(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w300,
                                          fontStyle: FontStyle.italic
                                      ))
                                ])),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: Get.height * 0.03),
                        child: AuthTextField(
                          controller: _email,
                          textInputType: TextInputType.emailAddress,
                          hintText: 'Email',
                          validator: Validator.emailValidator,
                          icon: Icons.email_outlined,
                        )
                      ),
                    ],
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async{
                      await controller.signInWithEmailLink(email: _email.text, link: link);
                    },
                    child: Text(
                      'Proceed',
                      style: GoogleFonts.lato(
                        fontSize: 25,
                        letterSpacing: 5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}