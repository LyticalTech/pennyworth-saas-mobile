import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'components/auth_button.dart';


class FailedApplicationScreen extends StatelessWidget {
  const FailedApplicationScreen({required this.title, required this.body, required this.action, required this.press, Key? key}) : super(key: key);

  final String title;
  final String body;
  final String action;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/pattern.png"),
                  ),
                ),
                child: Lottie.asset('assets/lottie/failed.json'),
              ),
            ),
            Expanded(
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: Get.height * .035),
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            textStyle:
                            Theme.of(context).textTheme.headline5!.copyWith(
                              fontWeight: FontWeight.w900,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 1
                                ..color = Colors.orange,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        body,
                        style: GoogleFonts.patrickHand(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AuthButton(
              title: action,
              color: Colors.orangeAccent,
              press: press,
            ),
          ],
        ),
      ),
    );
  }
}
