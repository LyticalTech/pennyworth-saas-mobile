import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:residents/components/text.dart';
import 'package:residents/controllers/office/estate_office_controller.dart';
import 'package:residents/models/estate_office/attendance.dart';
import 'package:residents/utils/app_theme.dart';
import 'package:residents/utils/extensions.dart';
import 'package:residents/utils/helper_functions.dart';

class AttendanceScreen extends GetView<EstateOfficeController> {
  @override
  final EstateOfficeController controller = Get.put(EstateOfficeController());

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        controller.getServices();
      },
      color: Colors.white,
      backgroundColor: AppTheme.primaryColor,
      child: controller.obx(
        (state) => Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * (Platform.isAndroid ? 0.1 : 0.085),
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.black12),
                child: TextField(
                  onChanged: controller.filterAttendance,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search_sharp),
                    focusColor: Colors.black,
                    fillColor: Colors.grey,
                    prefixIconColor: Colors.grey,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: state!.isNotEmpty
                  ? ListView.separated(
                      itemCount: state.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Padding(
                          padding: EdgeInsets.only(left: 12.0),
                          child: CustomText(
                            state[index].staff ?? "",
                            size: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.only(left: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.0),
                                child: RichText(
                                  text: TextSpan(
                                    text: "Title: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "${state[index].title}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              _buildSubtitle(
                                state[index].timeIn ?? "",
                                state[index].timeOut ?? "-:-",
                              ),
                            ],
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        onTap: () {
                          Attendance attendance = state[index];
                          _showBottomSheet(context, attendance);
                        },
                      ),
                      separatorBuilder: (context, index) => Divider(
                        thickness: 1,
                        height: 3,
                        color: Colors.black12,
                      ),
                    )
                  : Column(
                      children: [
                        Spacer(flex: 1),
                        Center(child: Lottie.asset("assets/lottie/empty.json")),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: CustomText(
                            "Staff attendance empty!",
                            fontWeight: FontWeight.w300,
                            size: 20,
                          ),
                        ),
                        Spacer(flex: 3),
                      ],
                    ),
            ),
          ],
        ),
        onLoading: Center(child: customActivityIndicator(size: 32)),
        onError: (error) {
          return Column(
            children: [
              Spacer(flex: 2),
              Center(child: Lottie.asset("assets/lottie/error_lady.json")),
              Spacer(flex: 1),
              Padding(
                padding: EdgeInsets.all(20),
                child: CustomText(
                  "$error",
                  fontWeight: FontWeight.w300,
                  size: 20,
                  textAlign: TextAlign.center,
                ),
              ),
              Spacer(flex: 3),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSubtitle(String timeIn, String timeOut) {
    return RichText(
      text: TextSpan(
        text: "Time In: ",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12,
          color: Colors.black54,
        ),
        children: [
          TextSpan(
            text: timeIn,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
            ),
          ),
          TextSpan(
            text: " | Time Out: ",
            style: TextStyle(fontWeight: FontWeight.w700),
            children: [
              TextSpan(
                text: timeOut,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context, Attendance attendance) {
    Get.bottomSheet(
      Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.4,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
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
              SizedBox(height: 12),
              buildItem(title: "Staff Name", value: attendance.staff ?? ""),
              buildItem(title: "Title", value: attendance.title ?? "-"),
              buildItem(
                  title: "Date",
                  value: attendance.date != null
                      ? DateTime.parse(attendance.date!).formattedDate()
                      : ""),
              buildItem(title: "Time In", value: attendance.timeIn ?? "-:-"),
              buildItem(title: "Time Out", value: attendance.timeOut ?? "-:-"),
            ],
          ),
        ),
      ),
    );
  }
}
