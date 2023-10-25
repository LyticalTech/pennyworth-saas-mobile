import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:residents/components/labelled_datetime_picker.dart';
import 'package:residents/components/text.dart';
import 'package:residents/controllers/power/power_controller.dart';
import 'package:residents/models/power/power.dart';
import 'package:residents/utils/app_theme.dart';
import 'package:residents/utils/extensions.dart';
import 'package:residents/utils/helper_functions.dart';

class SourceSupplies extends GetView<PowerController> {
  SourceSupplies({Key? key}) : super(key: key);

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  @override
  final PowerController controller = Get.put(PowerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Power Supply"),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text("Filter by Date"),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text("Refresh"),
                ),
              ];
            },
            onSelected: (value) {
              _handleAction(context, value);
            },
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white54,
              ),
              child: TextField(
                onChanged: controller.filterSupplies,
                decoration: InputDecoration(
                  fillColor: Colors.red,
                  prefixIcon: Icon(Icons.search_sharp),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 6),
                ),
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          controller.fetchSupplies();
        },
        color: Colors.white,
        backgroundColor: AppTheme.primaryColor,
        child: Stack(
          children: [
            ListView(),
            controller.obx(
              (state) {
                if (controller.powerSupplies.value.isNotEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
                    child: ListView.separated(
                      itemCount: state!.length,
                      itemBuilder: (BuildContext context, int index) {
                        final supply = state[index];
                        var duration = supply.runtime;

                        String runtime = '';
                        if (duration != null && duration.inMinutes > 60) {
                          runtime += "${(duration.inMinutes / 60).floor()} hs, ";
                        }
                        runtime += (duration != null) ? "${duration.inMinutes % 60} mins" : "";

                        return ListTile(
                          onTap: () => _showBottomSheet(context, supply),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomText(
                                  supply.source ?? "",
                                  size: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              CustomText(
                                DateTime.parse(supply.onTime!).formattedVerboseDate(),
                                size: 13,
                                color: Colors.black54,
                              )
                            ],
                          ),
                          subtitle: Column(
                            children: [
                              Row(
                                children: [
                                  bottomLabels(
                                    fontSize: 12,
                                    title: "On/T",
                                    value: (supply.onTime != null)
                                        ? DateTime.parse(supply.onTime!).formattedTime()
                                        : "",
                                  ),
                                  bottomLabels(
                                    fontSize: 12,
                                    title: "Off/T",
                                    value: (supply.offTime != null)
                                        ? DateTime.parse(supply.offTime!).formattedTime()
                                        : "",
                                  ),
                                  bottomLabels(fontSize: 12, title: "Time", value: runtime)
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        thickness: 1,
                        height: 3,
                        color: Colors.black12,
                      ),
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      Spacer(flex: 1),
                      Lottie.asset("assets/lottie/empty.json"),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: CustomText(
                          "Supply record is empty!",
                          fontWeight: FontWeight.w300,
                          size: 20,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 16),
                      // TextButton(onPressed: () => controller.reset(), child: Text("Refresh")),
                      Spacer(flex: 3),
                    ],
                  );
                }
              },
              onLoading: Center(child: customActivityIndicator(size: 32)),
              onError: (error) {
                return Column(
                  children: [
                    Spacer(flex: 1),
                    Lottie.asset("assets/lottie/error_lady.json"),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: CustomText(
                        "$error",
                        fontWeight: FontWeight.w300,
                        size: 20,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 16),
                    // TextButton(onPressed: () => controller.reset(), child: Text("Refresh")),
                    Spacer(flex: 3),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, PowerSupply powerSupply) {
    var duration = powerSupply.runtime;

    String runtime = '';
    if (duration != null && duration.inMinutes > 60) {
      runtime += "${(duration.inMinutes / 60).floor()} hours, ";
    }
    runtime += (duration != null) ? "${duration.inMinutes % 60} minutes" : "";

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
              SizedBox(
                height: 12,
              ),
              buildItem(title: "Power Source", value: powerSupply.source ?? ""),
              buildItem(
                title: "Date",
                value: (powerSupply.date != null)
                    ? DateTime.parse(powerSupply.date!).formattedDate()
                    : "-",
              ),
              buildItem(
                title: "On Time",
                value: (powerSupply.onTime != null)
                    ? DateTime.parse(powerSupply.onTime!).formattedDateTime()
                    : "-",
              ),
              buildItem(
                title: "Off Time",
                value: (powerSupply.offTime != null)
                    ? DateTime.parse(powerSupply.offTime!).formattedDateTime()
                    : "-",
              ),
              buildItem(title: "Total Runtime", value: runtime),
              buildItem(title: "Remarks", value: powerSupply.remarks ?? "-"),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAction(BuildContext context, int value) {
    if (value == 0) {
      showDialog(
        context: context,
        builder: (context) {
          return _dateRangePicker(context);
        },
      );
    } else {
      controller.fetchSupplies();
    }
  }

  Widget _dateRangePicker(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 300,
      ),
      child: AlertDialog(
        title: CustomText("Date Range"),
        insetPadding: EdgeInsets.symmetric(horizontal: 12),
        content: SizedBox(
          height: 200,
          width: MediaQuery.of(context).size.width * 0.92,
          child: Column(
            children: [
              LabelledDateTimePicker(
                label: "Start Date",
                controller: startDateController,
                initialDate: DateTime.now().subtract(Duration(days: 60)),
              ),
              SizedBox(height: 12),
              LabelledDateTimePicker(
                label: "End Date",
                controller: endDateController,
                initialDate: DateTime.now().subtract(Duration(days: 60)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel")),
          TextButton(
            onPressed: () {
              if (startDateController.text.isNotEmpty && endDateController.text.isNotEmpty) {
                controller.filterByDateRange(
                    startDateController.text.trim(), endDateController.text.trim());
              }
              Navigator.pop(context);
            },
            child: Text("Done"),
          )
        ],
      ),
    );
  }
}
