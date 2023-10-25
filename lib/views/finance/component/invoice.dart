import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:residents/components/card_balance.dart';
import 'package:residents/components/text.dart';
import 'package:residents/controllers/auth/app_user_controller.dart';
import 'package:residents/controllers/finance/invoice_controller.dart';
import 'package:residents/models/finance/invoice.dart';
import 'package:residents/models/other/app_user.dart';
import 'package:residents/utils/app_theme.dart';
import 'package:residents/utils/extensions.dart';
import 'package:residents/utils/helper_functions.dart';
import 'package:residents/views/finance/component/invoice_detail.dart';

class InvoiceScreen extends GetView<FinanceController> {

  final AppUser? appUser = AppUserController.appUser;

  @override
  final FinanceController controller = Get.put(FinanceController());

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final balancePageViewController = PageController(
    initialPage: 0,
  );

  void viewDetail(BuildContext context, Invoice invoice) {
    gotoScreen(context: context, screen: InvoiceDetail(invoice));
  }

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
        (state) => SingleChildScrollView(
          padding: EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 0),
          child: Column(
            children: [
              _buildTopCard(context),
              _buildInvoicesList(context),
            ],
          ),
        ),
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
              Spacer(flex: 1),
              TextButton(
                onPressed: () => controller.getServices(),
                child: CustomText("Refresh", color: AppTheme.colorOrange),
              ),
              Spacer(flex: 2),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInvoicesList(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: ListView.separated(
        itemCount: controller.invoices.length,
        itemBuilder: (context, index) => Container(
          color: (controller.invoices[index].amountPaid == controller.invoices[index].bill)
              ? Colors.green.shade50
              : Colors.red.shade50,
          child: ListTile(
            title: Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: CustomText(
                "Invoice No: ${controller.invoices[index].invoiceNumber}",
                size: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.invoices[index].remarks != null &&
                      controller.invoices[index].remarks!.isNotEmpty)
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            controller.invoices[index].remarks!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 4),
                  if (appUser?.isAdmin == true) Padding(
                    padding: EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomText(
                            "No Res. Paid: ${controller.invoices[index].totalPaid}",
                            size: 12,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 12),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomText(
                            "No Res. Unpaid: ${controller.invoices[index].totalUnpaid}",
                            size: 12,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            trailing: Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Spacer(),
                  CustomText(
                    "N${formattedDouble(controller.invoices[index].bill)}",
                    size: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 4),
                  CustomText(
                    DateTime.parse(controller.invoices[index].invoiceDate).formattedDate(),
                    color: Colors.black54,
                    size: 13,
                  ),
                  Spacer(flex: 2),
                ],
              ),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            onTap: () {
              viewDetail(context, controller.invoices[index]);
            },
          ),
        ),
        separatorBuilder: (context, index) => Divider(
          thickness: 1,
          height: 3,
          color: Colors.black12,
        ),
      ),
    );
  }

  Widget _buildTopCard(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.95,
          height: 160,
          child: PageView(
            controller: balancePageViewController,
            onPageChanged: (newPage) {
              controller.currentPage.value = newPage;
            },
            children: [
              Container(
                height: 180,
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Card(
                  elevation: 2,
                  color: AppTheme.colorOrange,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: CustomText(
                            "", //controller.getAuthUserFirstName(),
                            size: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Row(
                          children: [
                            Obx(
                              () => CardBalance(
                                amount: controller.totalResidentInvoice.value,
                                title: "Unpaid",
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 56,
                              color: Colors.white,
                            ),
                            Obx(
                              () => CardBalance(
                                amount: controller.totalPaid.value,
                                title: "Paid",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // if (controller.appUser.isAdmin)
              //   Container(
              //     height: 180,
              //     width: double.infinity,
              //     margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              //     child: Card(
              //       elevation: 2,
              //       color: AppTheme.colorOrange,
              //       child: Padding(
              //         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              //         child: Column(
              //           children: [
              //             Padding(
              //               padding: EdgeInsets.only(bottom: 8),
              //               child: CustomText(
              //                 "Estate Invoice",
              //                 size: 20,
              //                 fontWeight: FontWeight.w600,
              //                 color: Colors.white,
              //                 textAlign: TextAlign.left,
              //               ),
              //             ),
              //             Row(
              //               children: [
              //                 Obx(
              //                   () => CardBalance(
              //                     amount: controller.totalEstateInvoice.value,
              //                     title: "Unpaid",
              //                   ),
              //                 ),
              //                 Container(
              //                   width: 2,
              //                   height: 56,
              //                   color: Colors.white,
              //                 ),
              //                 Obx(
              //                   () => CardBalance(
              //                     amount: controller.totalEstatePaid.value,
              //                     title: "Paid",
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
        // if (controller.appUser.isAdmin)
        //   Positioned(
        //     bottom: 24,
        //     child: SizedBox(
        //       width: MediaQuery.of(context).size.width * 0.95,
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: List.generate(
        //           2,
        //           (index) {
        //             return Obx(
        //               () => Container(
        //                 width: 10,
        //                 height: 10,
        //                 margin: EdgeInsets.symmetric(horizontal: 3),
        //                 decoration: BoxDecoration(
        //                   shape: BoxShape.circle,
        //                   color: index == controller.currentPage.value ? Colors.white : null,
        //                   border: index != controller.currentPage.value
        //                       ? Border.all(color: Colors.white, width: 1)
        //                       : null,
        //                 ),
        //               ),
        //             );
        //           },
        //         ),
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}
