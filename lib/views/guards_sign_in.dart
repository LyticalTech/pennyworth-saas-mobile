import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_responsive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residents/components/auth_components.dart';
import 'package:residents/components/logo_widget.dart';

import '../controllers/auth/auth_controller.dart';
import '../helpers/validator.dart';
import '../size_config.dart';

class GuardsSignIn extends GetResponsiveView<AuthController> {
  GuardsSignIn({Key? key}) : super(key: key);

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.04),
          const Shield(),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    'GUARDS SIGN IN',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      textStyle:
                          Theme.of(context).textTheme.headline3!.copyWith(
                                fontWeight: FontWeight.w900,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1
                                  ..color = Colors.orange,
                              ),
                    ),
                  ),
                  AuthTextField(
                    controller: email,
                    textInputType: TextInputType.emailAddress,
                    hintText: 'john@gmail.com',
                    validator: Validator.emailValidator,
                    icon: Icons.mail_outline,
                  ),
                  PasswordTextField(
                    validator: Validator.passwordValidator,
                    controller: password,
                  ),
                  Button(
                    title: 'Proceed',
                    press: () {
                      controller.guardsSignIn();
                    },
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
