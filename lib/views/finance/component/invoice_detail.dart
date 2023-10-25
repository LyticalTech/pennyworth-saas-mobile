import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:residents/controllers/auth/app_user_controller.dart';
import 'package:residents/controllers/finance/invoice_controller.dart';
import 'package:residents/models/finance/invoice.dart';
import 'package:residents/models/other/app_user.dart';
import 'package:residents/utils/app_theme.dart';
import 'package:residents/utils/extensions.dart';
import 'package:residents/utils/helper_functions.dart';
import 'package:residents/components/text.dart';

class InvoiceDetail extends StatelessWidget {
  InvoiceDetail(this.invoice);

  final Invoice invoice;
  final FinanceController _controller = Get.find();
  final AppUser? appUser = AppUserController.appUser;

  Future<void> _handlePayment(BuildContext context) async {
    bool successful = await _controller.initiatePayment(context, invoice);
    if (successful) {
      waitAndExec(5, () {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildTop(),
                  _buildResident(),
                  _buildInvoiceInfo(),
                  _buildRemarks(),
                  (invoice.amountPaid != invoice.bill)
                      ? _buildButton(context)
                      : _buildPaidButton(),
                  // _buildReportButton(),
                  SizedBox(height: 44),
                ],
              ),
            ),
            Obx(
              () => _controller.loading.value
                  ? Positioned(
                      left: 0,
                      top: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        color: Colors.black.withOpacity(0.25),
                        child: Center(
                          child: customActivityIndicator(
                              size: 32, color: Colors.white),
                        ),
                      ),
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTop() {
    return Card(
      child: SizedBox(
        width: double.infinity,
        height: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            CustomText("Amount", color: Colors.black54),
            Spacer(),
            CustomText(
              "N${formattedDouble(invoice.bill)}",
              size: 32,
              fontWeight: FontWeight.w800,
            ),
            Spacer(),
            // Padding(
            //   padding:
            //       const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Container(
            //         padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            //         decoration: BoxDecoration(
            //           color: Colors.greenAccent,
            //           borderRadius: BorderRadius.circular(8),
            //         ),
            //         child: CustomText(
            //           "Total Res. Paid: ${invoice.totalPaid}",
            //           color: Colors.black,
            //         ),
            //       ),
            //       Container(
            //         padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            //         decoration: BoxDecoration(
            //           color: Colors.redAccent,
            //           borderRadius: BorderRadius.circular(8),
            //         ),
            //         child: CustomText(
            //           "Total Res. Unpaid: ${invoice.totalUnpaid}",
            //           color: Colors.white,
            //         ),
            //       )
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildResident() {
    return Card(
      margin: EdgeInsets.only(top: 16),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: RichText(
          text: TextSpan(
            text: "Resident:  ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
            children: [
              TextSpan(
                text: appUser?.fullName ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceInfo() {
    DateTime invoiceDate = DateTime.parse(invoice.invoiceDate);
    return Card(
      margin: EdgeInsets.only(top: 16),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildInfoItems(
              "Invoice Number",
              "${invoice.invoiceNumber}",
              valueSize: 16,
            ),
            buildInfoItems(
              "Date Generated",
              invoiceDate.formattedDate(),
              valueSize: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: buildInfoItems(
                    "Amount Paid",
                    formattedDouble(invoice.amountPaid),
                    valueSize: 16,
                  ),
                ),
                Expanded(
                  child: buildInfoItems(
                    "Outstanding",
                    formattedDouble(invoice.outstanding),
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

  Widget _buildRemarks() {
    return Card(
      margin: EdgeInsets.only(top: 16),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Text(
              "Remarks: ",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            Expanded(
              child: Text(
                "${invoice.remarks}",
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
          _handlePayment(context);
        },
        style: TextButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          primary: Colors.white,
        ),
        child: CustomText(
          "Pay ${formattedDouble(invoice.outstanding)}",
          size: 18,
        ),
      ),
    );
  }

  Widget _buildPaidButton() {
    return Container(
      width: double.infinity,
      height: 52,
      margin: EdgeInsets.only(top: 28),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          backgroundColor: Colors.black12,
          primary: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 4),
            CustomText("Paid", size: 18, color: Colors.green,),
          ],
        ),
      ),
    );
  }

// Widget _buildReportButton() {
//   return Container(
//     width: double.infinity,
//     margin: EdgeInsets.only(top: 24),
//     child: TextButton(
//       onPressed: () {},
//       style: TextButton.styleFrom(
//         minimumSize: Size.fromHeight(52),
//         backgroundColor: Colors.transparent,
//         primary: AppTheme.primaryColor,
//         side: BorderSide(color: AppTheme.primaryColor, width: 1),
//       ),
//       child: CustomText("Report an issue", size: 18),
//     ),
//   );
// }
}
