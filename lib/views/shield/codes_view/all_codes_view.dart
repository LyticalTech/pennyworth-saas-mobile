import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residents/controllers/shield/code_controller.dart';
import 'package:residents/views/shield/codes_view/active_codes_view.dart';
import 'package:residents/views/shield/codes_view/inactive_codes_view.dart';

class CodeView extends GetResponsiveView<CodeController> {
  CodeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => CodeController());
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Codes',
            style: GoogleFonts.lato(
              letterSpacing: 3,
            ),
          ),
          elevation: 10,
          shadowColor: Colors.grey,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: Text(
                  'Active',
                  style: GoogleFonts.aclonica(),
                ),
              ),
              Tab(
                child: Text(
                  'Inactive',
                  style: GoogleFonts.aclonica(),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ActiveCodes(),
            InactiveCodes(),
          ],
        ),
      ),
    );
  }
}
