import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residents/controllers/auth/auth_controller.dart';

class SettingsHome extends GetResponsiveView<AuthController> {
  SettingsHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AuthController());
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
              children: [
                const Divider(
                  thickness: 2,
                  indent: 50,
                  endIndent: 50,
                ),
                TextButton(
                  onPressed: (){
                    controller.signOut();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sign Out',
                        style: GoogleFonts.dancingScript(
                          textStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 25,
                            fontWeight: FontWeight.bold

                          )
                        ),
                      ),
                      const Icon(Icons.power_settings_new, color: Colors.red),
                    ],
                  ),
                ),
              ],
          ),
        ),
      ),
    );
  }
}
