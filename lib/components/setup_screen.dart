import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residents/controllers/office/estate_office_controller.dart';

class SetUpScreen extends StatefulWidget {
  const SetUpScreen({Key? key}) : super(key: key);

  @override
  State<SetUpScreen> createState() => _SetUpScreenState();
}

class _SetUpScreenState extends State<SetUpScreen> with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  final EstateOfficeController officeController = Get.find();

  @override
  void initState() {
    controller = AnimationController(duration: Duration(seconds: 3), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
    super.initState();
  }

  void setUpAppUser() {
    officeController.getServices();
  }

  @override
  Widget build(BuildContext context) => AnimatedText(animation: animation);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class AnimatedText extends AnimatedWidget {
  AnimatedText({required this.animation}) : super(listenable: animation);
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Container(
      color: Colors.orange,
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: FadeTransition(
          opacity: animation,
          child: Text(
            "Pennyworth",
            textAlign: TextAlign.center,
            style: GoogleFonts.cabin(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
