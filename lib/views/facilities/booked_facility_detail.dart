import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:residents/components/text.dart';
import 'package:residents/controllers/facility/facility_controller.dart';
import 'package:residents/models/facility/booked_facility.dart';
import 'package:residents/utils/app_theme.dart';
import 'package:residents/utils/helper_functions.dart';

class BookedFacilityDetail extends StatelessWidget {
  BookedFacilityDetail({Key? key, required this.facility}) : super(key: key);

  final BookedFacility facility;
  final FacilityController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booked Facility"),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAssetTitle(),
            _buildBookingInfo(),
            _buildDescription(),
            _buildButton(context),
            SizedBox(height: 44),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetTitle() {
    return Card(
      margin: EdgeInsets.only(top: 16),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: RichText(
          text: TextSpan(
            text: "Asset:  ",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87),
            children: [
              TextSpan(
                text: facility.asset,
                style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black87),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingInfo() {
    var status = "";
    if (facility.bookingStatus == 0 && facility.paymentStatus == 0) {
      status = "Pending Approval";
    } else if (facility.bookingStatus == 1 && facility.paymentStatus == 0) {
      status = "Awaiting Payment";
    } else if (facility.bookingStatus == 1 && facility.paymentStatus == 1) {
      status = "Booked";
    } else {
      status = "";
    }

    return Card(
      margin: EdgeInsets.only(top: 16),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: buildInfoItems(
                    "Start Date",
                    facility.startDate ?? "",
                    valueSize: 16,
                  ),
                ),
                Expanded(
                  child: buildInfoItems(
                    "End Date",
                    facility.endDate ?? "",
                    valueSize: 16,
                    crossAxisAlignment: CrossAxisAlignment.end,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: buildInfoItems(
                    "Start Time",
                    facility.startTime ?? "",
                    valueSize: 16,
                  ),
                ),
                Expanded(
                  child: buildInfoItems(
                    "End Time",
                    facility.endTime ?? "",
                    valueSize: 16,
                    crossAxisAlignment: CrossAxisAlignment.end,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: buildInfoItems(
                    "Booking Hour",
                    "${facility.totalHours ?? ''}",
                    valueSize: 16,
                  ),
                ),
                Expanded(
                  child: buildInfoItems(
                    "Rate/Hour (₦)",
                    "${facility.ratePerHour ?? ''}",
                    valueSize: 16,
                    crossAxisAlignment: CrossAxisAlignment.end,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: buildInfoItems(
                    "Booking Amount",
                    "${facility.bookingAmount ?? ''}",
                    valueSize: 16,
                  ),
                ),
                Expanded(
                  child: buildInfoItems(
                    "Booking Status",
                    status,
                    color: status == "Booked" ? Colors.green : Colors.black54,
                    valueSize: 16,
                    crossAxisAlignment: CrossAxisAlignment.end,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Card(
      margin: EdgeInsets.only(top: 16),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Text(
              "Description: ",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            Expanded(
              child: Text(
                facility.description ?? "",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      margin: EdgeInsets.only(top: 28),
      child: TextButton(
        onPressed: () {
          if (facility.bookingStatus == 1 && facility.paymentStatus == 0) {
            _controller.initialPayment(context, facility);
          } else {}
        },
        style: TextButton.styleFrom(
          backgroundColor: (facility.bookingStatus == 1 && facility.paymentStatus == 0)
              ? AppTheme.primaryColor
              : Colors.grey,
          foregroundColor: Colors.white,
        ),
        child: CustomText(
          (facility.bookingStatus == 1 && facility.paymentStatus == 0)
              ? "Complete Payment"
              : "Pending Approval",
          size: 18,
        ),
      ),
    );
  }
}
