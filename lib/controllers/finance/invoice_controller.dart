import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:get/get.dart';
import 'package:residents/controllers/auth/auth_controller.dart';
import 'package:residents/helpers/constants.dart';
import 'package:residents/models/estate_office/resident.dart';
import 'package:residents/models/finance/invoice.dart';
import 'package:residents/models/finance/service_charge.dart';
import 'package:residents/services/api_service.dart';
import 'package:residents/utils/environment.dart';
import 'package:residents/utils/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class FinanceController extends GetxController with StateMixin<List<Invoice>> {
  List<Invoice> invoices = <Invoice>[].obs;
  List<ServiceCharge> serviceCharges = <ServiceCharge>[].obs;
  final AuthController authController = Get.find();
  late Rx<Resident> resident;

  final currentPage = 0.obs;

  final totalEstateInvoice = 0.0.obs;
  final totalResidentInvoice = 0.0.obs;
  final totalPaid = 0.0.obs;
  final totalEstatePaid = 0.0.obs;
  final totalServiceCharges = 0.0.obs;
  final balance = 0.0.obs;
  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    resident = authController.resident;

    getServices();
  }

  Future<void> getServices() async {
    Future.wait([getInvoices(), getServiceCharges()]).then((value) {
      balance.value = totalEstatePaid.value - totalServiceCharges.value;
    });
  }

  Future<bool> getInvoices() async {
    try {
      change([], status: RxStatus.loading());

      final houseId = resident.value.houseId;
      logger.i(invoices);
      const endpoint = "${Endpoints.baseUrl}${Endpoints.invoice}";
      final response = await ApiService.getRequest(endpoint);
      if (response['status']) {
        invoices = parseInvoices(response['response']);
        logger.i(invoices);
        change(invoices, status: RxStatus.success());
        if (invoices.isNotEmpty) {
          totalEstateInvoice.value = invoices
              .map((invoice) => invoice.totalAmountCreated)
              .reduce((value, element) => value + element);

          totalResidentInvoice.value = invoices
              .map((invoice) => invoice.outstanding)
              .reduce((value, element) => value + element);

          totalPaid.value = invoices
              .map((invoice) => invoice.amountPaid)
              .reduce((value, element) => value + element);

          totalEstatePaid.value = invoices
              .map((invoice) => invoice.totalAmountPaid)
              .reduce((value, element) => value + element);
        }
        return invoices.isNotEmpty;
      } else {
        change([],
            status: RxStatus.error("You currently do not have any invoice!"));
        return invoices.isNotEmpty;
        // throw Exception("You currently do not have any invoice!");
      }
    } on SocketException catch (_) {
      change([], status: RxStatus.error("Unable to connect to the internet!"));
      return false;
    } catch (error) {
      log("$error");

      change([], status: RxStatus.error("Error Fetching invoices."));

      return false;
    }
  }

  Future<bool> getServiceCharges() async {
    try {
      const endpoint = "${Endpoints.baseUrl}${Endpoints.serviceCharge}";
      var response = await ApiService.getRequest(endpoint);

      if (response['status'] != null && response['status']) {
        serviceCharges = parseServiceCharges(response['response']);
        if (serviceCharges.isNotEmpty) {
          totalServiceCharges.value = serviceCharges
              .map((charge) => charge.amount)
              .reduce((value, element) => value + element);
        }
      }
      return serviceCharges.isNotEmpty;
    } on SocketException catch (error) {
      throw Exception("Failed to fetch data. Error: $error");
    } catch (error) {
      throw Exception("Failed to fetch data. Error: $error");
    }
  }

  initiatePayment(BuildContext context, Invoice invoice) async {
    loading.value = true;

    try {
      const endpoint = "${Endpoints.baseUrl}${Endpoints.payBill}";
      var response = await ApiService.putRequest(
          endpoint, {"billId": invoice.invoiceNumber});
      logger.i(response);

      if (response['status'] != null && response['status']) {
        String url = jsonDecode(response['response'])['data']['link'];
        logger.i(url[1]);
        await launchUrl(Uri.parse(url));
        // serviceCharges = parseServiceCharges(response['response']);

        logger.i(serviceCharges);
      }
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          message: "Payment unsuccessful!",
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      loading.value = false;
    }
  }

  // Future<bool> initiatePayment(BuildContext context, Invoice invoice) async {
  //   loading.value = true;

  //   try {
  //     final Customer customer = Customer(
  //       name: resident.value.fullName,
  //       phoneNumber: resident.value.phone,
  //       email: resident.value.email,
  //     );

  //     final Flutterwave flutterwave = Flutterwave(
  //       context: context,
  //       publicKey: Environment.flutterwavePublicKey,
  //       txRef: "${resident.value.id}_${DateTime.now().microsecondsSinceEpoch}",
  //       amount: invoice.outstanding.toString(),
  //       currency: "NGN",
  //       customer: customer,
  //       paymentOptions: "ussd, card",
  //       customization: Customization(title: "Invoice Payment"),
  //       isTestMode: false,

  //       // style: style,
  //       redirectUrl: 'lyticaltechnology.com/verify',
  //     );

  //     final ChargeResponse response = await flutterwave.charge();
  //     if (response.success == true) {
  //       final verificationResponse = await _verifyPayment({
  //         "invoiceId": invoice.id,
  //         "amountPaid": invoice.outstanding.toString(),
  //         "paymentReference": response.transactionId,
  //       });
  //       Get.showSnackbar(
  //         GetSnackBar(
  //           message: "Invoice successful!",
  //           duration: Duration(seconds: 5),
  //           backgroundColor: Colors.green,
  //         ),
  //       );

  //       if (verificationResponse) {
  //         await getInvoices();
  //       }

  //       return verificationResponse;
  //     } else {
  //       Get.showSnackbar(
  //         GetSnackBar(
  //           message: "Payment unsuccessful!",
  //           duration: Duration(seconds: 5),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //       return false;
  //     }
  //   } on SocketException catch (_) {
  //     Get.showSnackbar(
  //       GetSnackBar(
  //         title: "Network Error",
  //         message: "Please check your connection!",
  //         duration: Duration(seconds: 5),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return false;
  //   } catch (error) {
  //     Get.showSnackbar(
  //       GetSnackBar(
  //         title: "Payment Error",
  //         message: "Unable to process payment!",
  //         duration: Duration(seconds: 5),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return false;
  //   } finally {
  //     loading.value = false;
  //   }
  // }

  Future<bool> _verifyPayment(Map<String, dynamic> body) async {
    try {
      const endpoint = "${Endpoints.baseUrl}${Endpoints.invoicePayment}";
      final response = await ApiService.postRequest(endpoint, body);
      if (response['status']) {
        log("Verification sent successfully!");
      } else {
        log("Unable to send verification to desktop!");
      }

      return response[status];
    } catch (error) {
      Get.showSnackbar(
        GetSnackBar(
          message: "Verification unsuccessful! $error",
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }
}
