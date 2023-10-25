import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:residents/components/text.dart';
import 'package:residents/controllers/auth/app_user_controller.dart';
import 'package:residents/models/other/app_user.dart';
import 'package:residents/views/estate_office/component/complaints.dart';
import 'package:residents/views/estate_office/component/msg_board.dart';

class EstateOffice extends StatefulWidget {
  @override
  State<EstateOffice> createState() => _EstateOfficeState();
}

class _EstateOfficeState extends State<EstateOffice> {

  AppUser? appUser;

  @override
  void initState() {
    appUser = AppUserController.appUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: (appUser?.isAdmin == true) ? 3 : 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Estate Office"),
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark,
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              // if (appUser?.isAdmin == true) Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 12.0),
              //   child: CustomText("Attendance", color: Colors.white, size: 15),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: CustomText("Complaints", color: Colors.white, size: 15),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: CustomText("Msg. Board", color: Colors.white, size: 15),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // if (appUser?.isAdmin == true) AttendanceScreen(),
            Complaints(),
            MessageBoard(),
          ],
        ),
      ),
    );
  }
}
