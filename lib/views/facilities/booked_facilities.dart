import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:residents/components/text.dart';
import 'package:residents/controllers/facility/facility_controller.dart';
import 'package:residents/models/facility/booked_facility.dart';
import 'package:residents/models/facility/facility_card.dart';
import 'package:residents/utils/helper_functions.dart';
import 'package:residents/views/facilities/booked_facility_detail.dart';

class BookedFacilities extends StatefulWidget {
  const BookedFacilities({Key? key}) : super(key: key);

  @override
  State<BookedFacilities> createState() => _BookedFacilitiesState();
}

class _BookedFacilitiesState extends State<BookedFacilities> {
  final FacilityController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booked Facilities"),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: FutureBuilder(
        future: _controller.getBookedFacilities(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            return ListView.separated(
              itemBuilder: (context, index) {
                BookedFacility booked = _controller.bookedFacilities[index];
                return FacilityCard(
                  title: booked.asset ?? "",
                  image: "assets/images/facility.svg",
                  rate: booked.ratePerHour ?? 0,
                  description: booked.description,
                  capacity: booked.bookedSlot,
                  onTap: () {
                    Get.to(() => BookedFacilityDetail(facility: booked));
                  },
                );
              },
              separatorBuilder: (ctx, index) => Divider(),
              itemCount: _controller.bookedFacilities.length,
            );
          } else if (snapshot.data == false) {
            return RefreshIndicator(
              onRefresh: () => _controller.getBookedFacilities(),
              child: Stack(
                children: [
                  ListView(),
                  Column(
                    children: [
                      Spacer(flex: 2),
                      Center(child: Lottie.asset("assets/lottie/empty.json")),
                      Spacer(flex: 1),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: CustomText(
                          "No booked facility!",
                          fontWeight: FontWeight.w300,
                          size: 20,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Spacer(flex: 3),
                    ],
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return RefreshIndicator(
              onRefresh: () => _controller.getBookedFacilities(),
              child: Stack(
                children: [
                  ListView(),
                  Column(
                    children: [
                      Spacer(flex: 2),
                      Center(
                          child: Lottie.asset("assets/lottie/error_lady.json")),
                      Spacer(flex: 1),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: CustomText(
                          "${snapshot.error}",
                          fontWeight: FontWeight.w300,
                          size: 20,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Spacer(flex: 3),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return Center(child: customActivityIndicator(size: 32));
          }
        },
      ),
    );
  }
}
