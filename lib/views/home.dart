import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:residents/controllers/auth/auth_controller.dart';

import 'auth/components/auth_button.dart';


class Home extends GetResponsiveView<AuthController> {
  Home({Key? key}) : super(key: key){
    Get.lazyPut(() => AuthController());
  }

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
                child: Lottie.asset('assets/lottie/doughnut.json'),
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
                          'Welcome to France',
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
                        '''Hello there! This is a reminder that Mr Tega likes food.
                        
A true definition of he can eat for Africa. Number one Jejemo. 

If you have any issues with what I have posted my address is 5, Alubomimu lane, isale eko, Lagos.

Thank you!
                        ''',
                        style: GoogleFonts.patrickHand(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AuthButton(
              title: 'Sign Out',
              color: Colors.orangeAccent,
              press: () => controller.signOut(),
            ),
          ],
        ),
      ),
    );
  }
}
