import 'package:flutter/material.dart';

import '../components/constants.dart';
import '../components/default_button.dart';
import '../size_config.dart';

class OtpScreen extends StatefulWidget {
  static String routeName = "/views";

  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;

  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();

  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
  }

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
    }
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(

      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                Text(
                  "OTP Generator",
                  style: headingStyle,
                ),
                //Text("We sent your code to +1 898 860 ***"),
                buildTimer(),
            Form(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: getProportionateScreenWidth(40),
                        child: TextFormField(
                          autofocus: true,
                          controller: controller1,
                          obscureText: false,
                          style: const TextStyle(fontSize: 24),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: otpInputDecoration,
                          onChanged: (value) {
                            nextField(value, pin2FocusNode);
                          },
                        ),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(40),
                        child: TextFormField(
                          focusNode: pin2FocusNode,
                          obscureText: false,
                          controller: controller2,
                          style: const TextStyle(fontSize: 24),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: otpInputDecoration,
                          onChanged: (value) => nextField(value, pin3FocusNode),
                        ),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(40),
                        child: TextFormField(
                          focusNode: pin3FocusNode,
                          controller: controller3,
                          obscureText: false,
                          style: const TextStyle(fontSize: 24),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: otpInputDecoration,
                          onChanged: (value) => nextField(value, pin4FocusNode),
                        ),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(40),
                        child: TextFormField(
                          focusNode: pin4FocusNode,
                          controller: controller4,
                          obscureText: false,
                          style: const TextStyle(fontSize: 24),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: otpInputDecoration,
                          onChanged: (value) {
                            if (value.length == 1) {
                              pin4FocusNode!.unfocus();
                              // Then you need to check is the code is correct or not
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(40),
                        child: TextFormField(
                          focusNode: pin3FocusNode,
                          controller: controller3,
                          obscureText: false,
                          style: const TextStyle(fontSize: 24),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: otpInputDecoration,
                          onChanged: (value) => nextField(value, pin4FocusNode),
                        ),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(40),
                        child: TextFormField(
                          focusNode: pin4FocusNode,
                          controller: controller4,
                          obscureText: false,
                          style: const TextStyle(fontSize: 24),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: otpInputDecoration,
                          onChanged: (value) {
                            if (value.length == 1) {
                              pin4FocusNode!.unfocus();
                              // Then you need to check is the code is correct or not
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.15),
                  DefaultButton(
                    text: "Generate",
                    press: () {
                      setState(() {
                        controller1.text = '5';
                        nextField(controller1.text, pin2FocusNode);
                        controller2.text = '9';
                        controller3.text = '8';
                        controller4.text = '2';
                        pin4FocusNode!.unfocus();
                        pin3FocusNode!.unfocus();
                        pin2FocusNode!.unfocus();
                      });
                    },
                  )
                ],
              ),
            ),
                SizedBox(height: SizeConfig.screenHeight * 0.1),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Column buildTimer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("This code will expire in "),
        TweenAnimationBuilder(
          tween: Tween(begin: const Duration(hours: 12), end: Duration.zero),
          duration: const Duration(hours: 12),
          builder: (_, Duration value, child){
            final hours = value.inHours;
            final minutes = value.inMinutes % 60;
            final seconds = value.inSeconds % 60;
            return Text(
              "$hours hours, $minutes minutes, $seconds seconds",
              style: const TextStyle(color: kPrimaryColor),
            );
    }

        ),
      ],
    );
  }
}
