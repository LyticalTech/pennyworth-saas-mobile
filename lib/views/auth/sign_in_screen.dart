import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residents/components/logo_widget.dart';
import 'package:residents/components/please_wait_dialog.dart';
import 'package:residents/controllers/auth/auth_controller.dart';
import 'package:residents/utils/app_theme.dart';
import 'package:residents/utils/helper_functions.dart';
import 'package:residents/utils/validator.dart';
import 'package:residents/views/auth/otp_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'components/already_have_an_account.dart';
import 'components/auth_button.dart';
import 'components/auth_text_field.dart';

class SignIn extends GetResponsiveView<AuthController> {
  SignIn({Key? key}) : super(key: key) {
    Get.lazyPut(() => AuthController());
  }

  final TextEditingController _email = TextEditingController();
  final TextEditingController _requestEmail = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Shield(),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            'SIGN IN',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(
                                    fontWeight: FontWeight.w900,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 1
                                      ..color = AppTheme.primaryColor,
                                  ),
                            ),
                          ),
                        ),
                        AuthTextField(
                          controller: _email,
                          textInputType: TextInputType.emailAddress,
                          hintText: 'Email Address',
                          validator: Validator.emailValidator,
                          icon: Icons.mail_outline,
                        ),
                        SizedBox(height: 24),
                        AuthButton(
                          title: 'Proceed',
                          press: _handleGetOtp,
                          color: AppTheme.primaryColor,
                        ),
                        AlreadyHaveAnAccountCheck(
                          press: () async {
                            final url =
                                Uri.parse("https://silverstonemanager.com/");
                            if (await canLaunchUrl(url)) {
                              launchUrl(url);
                            }
                          },
                        ),
                      ],
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

  Future<void> _handleGetOtp() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final email = _email.text.trim().toLowerCase();
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> res = await controller.getOtp(email);
      if (res["success"]) {
        Get.snackbar(
          "OTP Sent",
          res['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 4),
          margin: EdgeInsets.all(16),
        );
        waitAndExec(4000, () => Get.to(() => AuthOTPScreen(email)));
      } else {
        Get.snackbar(
          "Sign In Error",
          res['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 4),
          margin: EdgeInsets.all(16),
        );
      }
    }
  }

  void _handleResendLink(BuildContext context) {
    Navigator.pop(context);
    Get.dialog(const PleaseWaitDialog());
    if (_requestEmail.text.isNotEmpty) {
      controller.requestActivationLinkResend(context, _requestEmail.text);
    }
  }
}
