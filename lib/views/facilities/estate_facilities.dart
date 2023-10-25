import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:residents/components/text.dart';
import 'package:residents/controllers/facility/facility_controller.dart';
import 'package:residents/models/facility/facility_card.dart';
import 'package:residents/models/facility/facility_response.dart';
import 'package:residents/utils/app_theme.dart';
import 'package:residents/utils/helper_functions.dart';
import 'package:residents/views/facilities/book_facility.dart';
import 'package:residents/views/facilities/booked_facilities.dart';

class EstateFacilities extends GetView<FacilityController> {
  void _gotoBookFacility(FacilityResponse facility) {
    Get.to(() => BookFacility(facility: facility));
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  final controller = Get.put(FacilityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Estate Facilities"),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => BookedFacilities()),
            icon: Icon(Icons.bookmark, color: Colors.white),
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async => controller.getAvailableFacilities(),
        color: Colors.white,
        backgroundColor: AppTheme.primaryColor,
        child: Stack(
          children: [
            ListView(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: controller.obx(
                (state) => controller.facilities.isNotEmpty
                    ? _buildFacilityList()
                    : _buildNoFacilityWidget(),
                onLoading: Center(child: customActivityIndicator(size: 32)),
                onError: (error) {
                  return Column(
                    children: [
                      Spacer(flex: 2),
                      Center(child: Lottie.asset("assets/lottie/error_lady.json")),
                      Spacer(flex: 1),
                      CustomText(
                        "$error",
                        fontWeight: FontWeight.w300,
                        size: 20,
                        textAlign: TextAlign.center,
                      ),
                      Spacer(flex: 3),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilityList() {
    return ListView.builder(
      itemCount: controller.facilities.length,
      itemBuilder: (context, index) {
        var facility = controller.facilities[index];
        return FacilityCard(
          title: facility.name ?? "",
          image: "assets/images/facility.svg",
          rate: facility.rate!,
          description: facility.description,
          capacity: facility.capacity,
          onTap: () => _gotoBookFacility(facility),
        );
      },
    );
  }

  Widget _buildNoFacilityWidget() {
    return Column(
      children: [
        Spacer(flex: 1),
        Center(child: Lottie.asset("assets/lottie/empty.json")),
        CustomText(
          "No facility has been entered!",
          size: 20,
          fontWeight: FontWeight.w300,
          textAlign: TextAlign.center,
        ),
        Spacer(flex: 3),
      ],
    );
  }
}
