import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:residents/components/action_button.dart';
import 'package:residents/components/code_generator_card.dart';
import 'package:residents/controllers/auth/auth_controller.dart';
import 'package:residents/size_config.dart';
import 'package:residents/views/shield/codes_view/all_codes_view.dart';
import 'package:residents/views/shield/codes_view/cancel_code.dart';

import '../controllers/shield/code_controller.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late AuthController authController;

  @override
  void initState() {
    authController = Get.find();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Code Generation"),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.size.width * 0.01,
          ),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    image: const DecorationImage(
                      image: AssetImage("assets/images/pattern.png"),
                    ),
                  ),
                  child: Image.asset(
                    "assets/images/shield.png",
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    top: SizeConfig.size.height * 0.02,
                    left: SizeConfig.size.width * 0.1,
                    right: SizeConfig.size.width * 0.1,
                  ),
                  //height: SizeConfig.screenHeight * 0.4,
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    children: [
                      ActionButton(
                        buttonColor: Colors.deepOrange,
                        icon: const Icon(
                          Icons.vpn_key_outlined,
                          color: Colors.deepOrange,
                        ),
                        label: 'Generate Code',
                        press: () {
                          Get.put(CodeController());
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) => CodeGeneratorDialog(),
                          );
                        },
                        textColor: Colors.deepOrange,
                      ),
                      ActionButton(
                        buttonColor: Colors.deepOrange,
                        icon: const Icon(
                          Icons.fullscreen_outlined,
                          color: Colors.deepOrange,
                        ),
                        label: 'View Codes',
                        press: () {
                          Get.to(
                            () => CodeView(),
                            duration: const Duration(seconds: 1),
                            transition: Transition.fadeIn,
                          );
                        },
                        textColor: Colors.deepOrange,
                      ),
                      ActionButton(
                        buttonColor: Colors.white,
                        icon: const Icon(
                          Icons.vpn_key_off_outlined,
                          color: Colors.deepOrange,
                        ),
                        label: 'Cancel Code',
                        press: () {
                          Get.to(
                            () => CancelCodeView(),
                            duration: const Duration(seconds: 1),
                            transition: Transition.fadeIn,
                          );
                        },
                        textColor: Colors.deepOrange,
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
