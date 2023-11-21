import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:residents/helpers/constants.dart';
import 'package:residents/services/api_service.dart';
import 'package:residents/utils/logger.dart';

class SOSController extends GetxController {
  SOSController();

  final loading = false.obs;

  Future<bool> sendPanicMessage({
    required String estateId,
    required String residentName,
    required String residentAddress,
  }) async {
    Map<String, String> message = {
      "resident": residentName,
      "address": residentAddress,
      "estateId": estateId
    };
    try {
      loading.value = true;

      final response = await ApiService.postRequest(
          "${Endpoints.baseUrl}${Endpoints.sendPanicMessage}", message);

      logger.i(response);
      if (response['status']) {
        Get.showSnackbar(GetSnackBar(
          message: "Success: Residents notified of Emergency!",
          duration: Duration(seconds: 5),
          backgroundColor: Colors.green,
        ));

        return true;
      } else {
        Get.showSnackbar(GetSnackBar(
          message: "Unable to send alert!",
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 3),
        ));
        return false;
      }
    } on SocketException catch (_) {
      Get.showSnackbar(GetSnackBar(
        message: "Error! Please enable internet connection!",
        duration: Duration(seconds: 3),
        backgroundColor: Colors.redAccent,
      ));
      return false;
    } catch (error) {
      return false;
    } finally {
      loading.value = false;
    }
  }
}
