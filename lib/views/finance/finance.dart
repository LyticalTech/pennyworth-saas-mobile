import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:residents/controllers/auth/app_user_controller.dart';
import 'package:residents/controllers/finance/invoice_controller.dart';
import 'package:residents/models/other/app_user.dart';
import 'package:residents/utils/helper_functions.dart';
import 'package:residents/views/finance/component/invoice.dart';
import 'package:residents/views/finance/component/maintenance.dart';

class Finance extends StatefulWidget {
  @override
  _FinanceState createState() => _FinanceState();
}

class _FinanceState extends State<Finance> {
  int _currentIndex = 0;
  
  List screens = [InvoiceScreen(), MaintenanceAndService()];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Finance"),
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark,
          ),
          // bottom: appUser.isAdmin
          //     ? PreferredSize(
          //         preferredSize: Size.fromHeight(56),
          //         child: SizedBox(
          //           width: double.infinity,
          //           height: 56,
          //           child: Column(
          //             children: [
          //               Text(
          //                 "Payable Invoice",
          //                 style: TextStyle(color: Colors.white, fontSize: 14),
          //               ),
          //               Obx(
          //                 () => Text(
          //                   formattedDouble(controller.balance.value),
          //                   style: TextStyle(
          //                     color: Colors.white,
          //                     fontSize: 22,
          //                     fontWeight: FontWeight.w600,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       )
          //     : null,
        ),
        // bottomNavigationBar: appUser.isAdmin
        //     ? BottomNavigationBar(
        //         currentIndex: _currentIndex,
        //         onTap: (index) {
        //           setState(() {
        //             _currentIndex = index;
        //           });
        //         },
        //         items: [
        //           BottomNavigationBarItem(
        //             icon: Icon(Icons.money),
        //             label: "Invoices",
        //           ),
        //           BottomNavigationBarItem(
        //             icon: Icon(CupertinoIcons.gear),
        //             label: "Maint. & Services",
        //           ),
        //         ],
        //       )
        //     : null,
        // body: appUser.isAdmin ? screens[_currentIndex] : InvoiceScreen(),
        body: InvoiceScreen(),
      ),
    );
  }
}
