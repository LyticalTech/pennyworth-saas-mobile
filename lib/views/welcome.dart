import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residents/components/constants.dart';
import 'package:residents/controllers/auth/auth_controller.dart';
import 'package:residents/controllers/office/estate_office_controller.dart';
import 'package:residents/services/push_notification_services.dart';
import 'package:residents/utils/helper_functions.dart';
import 'package:residents/views/auth/sign_in_screen.dart';
import 'package:residents/views/community/community.dart';
import 'package:residents/views/estate_office/estate_office.dart';
import 'package:residents/views/facilities/estate_facilities.dart';
import 'package:residents/views/finance/finance.dart';
import 'package:residents/views/home_view.dart';
import 'package:residents/views/maint_power/source_supplies.dart';
import 'package:residents/views/module_card.dart';
import 'package:residents/views/profile/profile.dart';
import 'package:residents/views/sos/sos.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late String fullName;
  final EstateOfficeController officeController = Get.put(EstateOfficeController());
  final AuthController authController = Get.find();

  @override
  void initState() {
    super.initState();
    authController.loginAndPrepFirebase();
    authController.notificationService?.initialise();

    log("${authController.resident.value.estateId} => ${authController.resident.value.estateName}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: welcomeAppBar(),
      body: MainModules(),
    );
  }

  PreferredSizeWidget welcomeAppBar() {
    return AppBar(
      title: Text(
        "PENNYWORTH",
        style: GoogleFonts.breeSerif(color: Colors.deepOrangeAccent, fontWeight: FontWeight.w900),
      ),
      actions: [
        PopupMenuButton(
          onSelected: _onSelect,
          itemBuilder: (context) => [
            PopupMenuItem<int>(value: 0, child: Text("Profile")),
            PopupMenuItem<int>(value: 1, child: Text("Sign Out")),
          ],
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.more_vert, size: 28, color: kPrimaryColor),
          ),
        )
      ],
      centerTitle: true,
      backgroundColor: Colors.white60,
      elevation: 0,
    );
  }

  void _onSelect(int value) {
    value == 0 ? Get.to(() => ProfileScreen()) : _handleSignOut();
  }

  Future<void> _handleSignOut() async {
    await authController.signOut();
    Get.offAll(() => SignIn());
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class MainModules extends StatefulWidget {
  MainModules({Key? key}) : super(key: key);

  @override
  State<MainModules> createState() => _MainModulesState();
}

class _MainModulesState extends State<MainModules> {
  final AuthController controller = Get.find();
  late String residentFullName;

  @override
  void initState() {
    residentFullName = controller.resident.value.fullName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white60,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 8),
              child: RichText(
                text: TextSpan(
                  text: "Welcome, \n",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w300,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(
                      text: residentFullName,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                ModulesCard(
                  title: "Estate Office",
                  icon: CupertinoIcons.home,
                  onTap: () => gotoScreen(context: context, screen: EstateOffice()),
                ),
                SizedBox(width: 12),
                ModulesCard(
                  title: "Finance",
                  icon: CupertinoIcons.money_dollar_circle,
                  onTap: () => gotoScreen(context: context, screen: Finance()),
                )
              ],
            ),
            Row(
              children: [
                ModulesCard(
                  title: "Power",
                  icon: Icons.flash_on_rounded,
                  onTap: () => gotoScreen(context: context, screen: SourceSupplies()),
                ),
                SizedBox(width: 12),
                ModulesCard(
                  title: "Facilities",
                  icon: CupertinoIcons.building_2_fill,
                  onTap: () => gotoScreen(context: context, screen: EstateFacilities()),
                )
              ],
            ),
            Row(
              children: [
                ModulesCard(
                  title: "Code Generation",
                  icon: CupertinoIcons.qrcode_viewfinder,
                  onTap: () => Get.to(() => Home()),
                ),
                SizedBox(width: 12),
                ModulesCard(
                  title: "SOS",
                  icon: Icons.emergency,
                  onTap: () => gotoScreen(context: context, screen: SOS()),
                )
              ],
            ),
            Row(
              children: [
                ModulesCard(
                  title: "Estate Community",
                  icon: CupertinoIcons.group_solid,
                  onTap: () => gotoScreen(context: context, screen: Community()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
