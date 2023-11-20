import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:residents/components/text.dart';
import 'package:residents/controllers/office/estate_office_controller.dart';
import 'package:residents/models/estate_office/messages.dart';
import 'package:residents/utils/dates_utils.dart';
import 'package:residents/utils/helper_functions.dart';

class ComplaintHistory extends StatefulWidget {
  const ComplaintHistory({Key? key}) : super(key: key);

  @override
  State<ComplaintHistory> createState() => _ComplaintHistoryState();
}

class _ComplaintHistoryState extends State<ComplaintHistory> {
  EstateOfficeController estateController = Get.find();

  String residentEmail = "";

  @override
  void initState() {
    residentEmail = estateController.resident.value.email ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Complaint History"),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: FutureBuilder(
        future: estateController.getComplaintsFromDB(residentEmail),
        builder:
            (BuildContext context, AsyncSnapshot<List<Complaint?>> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.isNotEmpty
                ? ListView.separated(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      log("${snapshot.data![index]?.status}");

                      final title = snapshot.data![index]?.title ?? "";
                      final message = snapshot.data![index]?.message ?? "";
                      return ListTile(
                        title: CustomText(title,
                            size: 17, fontWeight: FontWeight.w500),
                        subtitle: CustomText(message,
                            size: 14, fontWeight: FontWeight.w400, maxLine: 1),
                        onTap: () =>
                            _showBottomSheet(context, snapshot.data![index]!),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(),
                  )
                : Column(
                    children: [
                      Spacer(flex: 1),
                      Center(child: Lottie.asset("assets/lottie/empty.json")),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: CustomText(
                          "You haven't laid any complaint yet!",
                          fontWeight: FontWeight.w300,
                          size: 20,
                        ),
                      ),
                      Spacer(flex: 3),
                    ],
                  );
          }
          return Center(
            child: customActivityIndicator(size: 32),
          );
        },
      ),
    );
  }

  void _showBottomSheet(BuildContext context, Complaint complaint) {
    var status = "";
    Color? statusColor;
    if (complaint.status == 0) {
      status = "Pending";
      statusColor = Colors.redAccent;
    } else if (complaint.status == 1) {
      status = "In Progress";
      statusColor = Colors.grey;
    } else {
      status = "Completed";
      statusColor = Colors.greenAccent;
    }

    Get.bottomSheet(
      Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.5,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Center(
                  child: Container(
                    width: 32,
                    height: 5,
                    margin: EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.5),
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              _labelItem("Title", complaint.title ?? ""),
              _labelItem(
                  "Date", formatDateTime(DateTime.parse(complaint.date!))),
              _labelItem(
                "Status",
                status,
                color: statusColor,
              ),
              _labelItem("Message", complaint.message ?? ""),
            ],
          ),
        ),
      ),
    );
  }

  Widget _labelItem(String label, String value, {Color? color}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(label, fontWeight: FontWeight.w600, size: 15),
          SizedBox(height: 4),
          CustomText(value, size: 18, color: color ?? Colors.black54),
        ],
      ),
    );
  }
}
