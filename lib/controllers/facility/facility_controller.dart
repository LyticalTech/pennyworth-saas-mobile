import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:get/get.dart';
import 'package:residents/controllers/auth/auth_controller.dart';
import 'package:residents/controllers/office/estate_office_controller.dart';
import 'package:residents/helpers/constants.dart';
import 'package:residents/models/estate_office/resident.dart';
import 'package:residents/models/facility/booked_facility.dart';
import 'package:residents/models/facility/facility_response.dart';
import 'package:residents/services/api_service.dart';
import 'package:residents/utils/environment.dart';
import 'package:residents/utils/flutterwave_style.dart';
import 'package:residents/utils/logger.dart';

class FacilityController extends GetxController
    with StateMixin<List<FacilityResponse>> {
  TextEditingController fromDateTimeController = TextEditingController();
  TextEditingController toDateTimeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController slotController = TextEditingController();

  final AuthController authController = Get.find();
  late Rx<Resident> resident;

  final facilities = <FacilityResponse>[].obs;
  final loading = false.obs;
  final bookedFacility = BookedFacility().obs;
  final bookedFacilities = <BookedFacility>[].obs;

  @override
  void onInit() async {
    super.onInit();
    resident = authController.resident;
    resident(authController.resident.value);
    await getAvailableFacilities();
  }

  Future<void> getAvailableFacilities() async {
    logger.i('facilities');
    try {
      change([], status: RxStatus.loading());
      final estateId = resident.value.estateId;

      String endpoint = "${Endpoints.baseUrl}${Endpoints.facilities}/$estateId";
      final response = await ApiService.getRequest(endpoint);
      logger.i(response['response']);
      if (response['status']) {
        List<FacilityResponse> parsedResponse =
            parseFacilityResponse(response['response']);
        facilities.value = parsedResponse;
      }
      change(facilities, status: RxStatus.success());
    } on SocketException catch (_) {
      change([],
          status:
              RxStatus.error("Network error! Please check your connection."));
    } catch (error) {
      logger.i(error);

      change([], status: RxStatus.error("Failed to fetch facilities."));
    }
  }

  Future<bool> bookFacility(FacilityResponse facility) async {
    try {
      loading.value = true;
      String endpoint = "${Endpoints.baseUrl}${Endpoints.bookFacility}";
      if (fromDateTimeController.text.isEmpty ||
          toDateTimeController.text.isEmpty ||
          descriptionController.text.isEmpty ||
          slotController.text.isEmpty) {
        Get.snackbar(
          "Field Empty",
          "All fields are required!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 4),
          margin: EdgeInsets.all(16),
        );
        return false;
      }
// {
//   "assetId": 0,
//   "residentId": 0,
//   "description": "string",
//   "bookedSlot": 0,
//   "startDateAndTime": "2023-11-09T21:53:54.376Z",
//   "endDateAndTime": "2023-11-09T21:53:54.376Z"
// }

      Map<String, dynamic> body = {
        "assetId": facility.id!,
        "residentId": resident.value.id,
        "description": descriptionController.text.trim(),
        "bookedSlot": slotController.text.trim(),
        "startDateAndTime": DateTime.parse(fromDateTimeController.text.trim())
            .toIso8601String(),
        "endDateAndTime":
            DateTime.parse(toDateTimeController.text.trim()).toIso8601String(),
      };

      logger.i(body);

      final response = await ApiService.postRequest(endpoint, body);
      logger.i(response['response']);
      logger.i(response['status']);
      if (response['status']) {
        Get.snackbar(
          "Successful",
          "Facility has been booked successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 4),
          margin: EdgeInsets.all(16),
        );
        return true;
      } else {
        Get.snackbar(
          "Booking failed",
          "Unable to complete the booking!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 4),
          margin: EdgeInsets.all(16),
        );
        return false;
      }
    } on SocketException catch (_) {
      Get.showSnackbar(GetSnackBar(
        message: "Error! Please check your connection!",
        duration: Duration(seconds: 3),
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16),
      ));
      return false;
    } catch (error) {
      Get.showSnackbar(GetSnackBar(
        message: "Failed to book facility. $error",
        duration: Duration(seconds: 3),
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16),
      ));
      return false;
    } finally {
      loading.value = false;
    }
  }

  Future<bool> getBookedFacilities() async {
    try {
      const endpoint = "${Endpoints.baseUrl}${Endpoints.bookedFacility}";
      final response = await ApiService.getRequest(endpoint);
      if (response['status']) {
        logger.i(response['response']);
        final returnedFacilities = parseBookedFacilities(response['response']);
        bookedFacilities.clear();
        bookedFacilities.addAll(returnedFacilities);
        return returnedFacilities.isNotEmpty;
      } else {
        Get.showSnackbar(GetSnackBar(
          message: response['message'],
          duration: Duration(seconds: 3),
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(16),
        ));
        return false;
      }
    } on SocketException catch (_) {
      Get.showSnackbar(GetSnackBar(
        message: "Network error. Please check your connection!",
        duration: Duration(seconds: 3),
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16),
      ));
      return false;
    } catch (error) {
      // print(error);
      Get.showSnackbar(GetSnackBar(
        message: "Unable to fetch booked asset.",
        duration: Duration(seconds: 3),
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16),
      ));
      return false;
    }
  }

  Future<bool> initialPayment(
      BuildContext context, BookedFacility facility) async {
    loading.value = true;

    final EstateOfficeController estateOfficeController =
        Get.put(EstateOfficeController());
    Resident resident = estateOfficeController.resident.value;

    try {
      bool isAvailable = await _checkAvailability(facility.id);

      if (!isAvailable) return false;
      final Customer customer = Customer(
        name: 'resident.fullName',
        phoneNumber: resident.phone,
        email: resident.email,
      );

      final Flutterwave flutterwave = Flutterwave(
        context: context,
        publicKey: Environment.flutterwavePublicKey,
        txRef: "${resident.id}_${DateTime.now().microsecondsSinceEpoch}",
        amount: facility.bookingAmount.toString(),
        currency: "NGN",
        customer: customer,
        paymentOptions: "ussd, card",
        customization: Customization(title: "Facility Usage Payment"),
        isTestMode: false,
        // style: style,
        redirectUrl: 'lyticaltechnology.com/verify',
      );

      final ChargeResponse response = await flutterwave.charge();
      if (response.success != null) {
        final verificationResponse = await _verifyPayment({
          "bookingId": facility.id,
          "residentEmail": facility.bookingAmount,
          "payment": facility.bookingAmount,
          "paymentReference": response.transactionId,
        });

        Get.showSnackbar(GetSnackBar(
          message: "Invoice payment successful!",
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(16),
        ));

        if (verificationResponse) {
          await getBookedFacilities();
        }

        return verificationResponse;
      } else {
        Get.showSnackbar(GetSnackBar(
          message: "Unable to process payment!",
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(16),
        ));
        return false;
      }
      return true;
    } on SocketException catch (_) {
      Get.showSnackbar(
        GetSnackBar(
          title: "Network Error",
          message: "Please check your connection!",
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(16),
        ),
      );
      return false;
    } catch (error) {
      Get.showSnackbar(
        GetSnackBar(
          title: "Payment Error",
          message: "Unable to process payment!",
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(16),
        ),
      );
      return false;
    } finally {
      loading.value = false;
    }
  }

  Future<bool> _verifyPayment(Map<String, dynamic> body) async {
    try {
      const endpoint = "${Endpoints.baseUrl}${Endpoints.facilityPayment}";
      final response = await ApiService.postRequest(endpoint, body);
      if (response['status']) {
        log("Verification sent successfully!");
      } else {
        log("Unable to send verification to desktop!");
      }

      return response['status'];
    } catch (error) {
      Get.showSnackbar(
        GetSnackBar(
          message: "Verification unsuccessful! $error",
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(16),
        ),
      );
      return false;
    }
  }

  void clear() {
    fromDateTimeController.text = "";
    toDateTimeController.text = "";
    descriptionController.text = "";
    slotController.text = "";
  }

  Future<bool> _checkAvailability(String? id) async {
    try {
      final endpoint =
          "${Endpoints.baseUrl}${Endpoints.checkBookingAvailability}$id";
      final response = await ApiService.getRequest(endpoint);
      if (response['status']) {
        return response['response'];
      }
      return false;
    } on SocketException catch (_) {
      Get.showSnackbar(
        GetSnackBar(
          title: "Network Error",
          message: "Please check your connection!",
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(16),
        ),
      );
      return false;
    } catch (error) {
      Get.showSnackbar(
        GetSnackBar(
          title: "Payment Error",
          message: "Unable to process payment!",
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(16),
        ),
      );
      return false;
    }
  }
}
