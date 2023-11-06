import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:residents/controllers/auth/auth_controller.dart';
import 'package:residents/helpers/constants.dart';
import 'package:residents/models/estate_office/attendance.dart';
import 'package:residents/models/estate_office/messages.dart';
import 'package:residents/services/api_service.dart';
import 'package:residents/utils/logger.dart';
import 'package:residents/utils/network_base.dart';
import '../../models/estate_office/resident.dart';

class EstateOfficeController extends GetxController
    with StateMixin<List<Attendance>> {
  final attendance = <Attendance>[].obs;
  late Rx<Resident> resident;
  final hasFetchedResidents = false.obs;
  final AuthController authController = Get.find();
  final _networkHelper = NetworkHelper(Endpoints.baseUrl);

  final loading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    // resident(authController.resident.value);
    resident = authController.resident;
    await getServices();
  }

  Future<bool> fetchAttendance() async {
    try {
      change([], status: RxStatus.loading());
      final response =
          await get(Uri.parse(Endpoints.baseUrl + Endpoints.attendance));
      if (response.statusCode == 200) {
        attendance.value = parseAttendance(response.body);
        change(attendance, status: RxStatus.success());
        return attendance.isNotEmpty;
      } else {
        change([], status: RxStatus.error());
        throw Exception("Failed to fetch Attendance");
      }
    } on SocketException catch (_) {
      change([], status: RxStatus.error("Unable to connect to the internet!"));
      return false;
    } catch (error) {
      change([], status: RxStatus.error("Error fetching attendance!"));
      return false;
    }
  }

  void filterAttendance(String by) {
    List<Attendance> temp = [];
    temp.addAll(attendance);
    if (by.isNotEmpty) {
      List<Attendance> result = temp;
      result.retainWhere((element) =>
          element.staff!.toLowerCase().contains(by.toLowerCase()) ||
          element.title!.toLowerCase().contains(by.toLowerCase()));
      change(result, status: RxStatus.success());
    } else {
      change(attendance, status: RxStatus.success());
    }
  }

  Future<bool> fetchMessages() async {
    try {
      change([], status: RxStatus.loading());
      final response =
          await get(Uri.parse(Endpoints.baseUrl + Endpoints.attendance));
      if (response.statusCode == 200) {
        return false;
      } else {
        throw Exception("Failed to fetch Attendance");
      }
    } on SocketException catch (error) {
      throw Exception("Failed to fetch Attendance. $error");
    } catch (error) {
      throw Exception("Failed to fetch Attendance. $error");
    }
  }

  // Future<void> fetchResidentInfo() async {
  //   try {
  //     final authUserEmail = FirebaseAuth.instance.currentUser?.email;
  //     assert(authUserEmail != null);
  //
  //     String endpoint = "${Endpoints.baseUrl}${Endpoints.getResidentInfo}$authUserEmail";
  //     final response = await get(Uri.parse(endpoint));
  //
  //     if (response.statusCode == 200) {
  //       Resident instance = Resident.fromJson(jsonDecode(response.body));
  //       log("Network response: ${instance.toString()}");
  //       resident.update((res) {
  //         res?.id = instance.id;
  //         res?.fullName = instance.fullName;
  //         res?.email = instance.email;
  //         res?.phoneNumber = instance.phoneNumber;
  //         res?.maritalStatus = instance.maritalStatus;
  //         res?.address = instance.address;
  //         res?.dateRegistered = instance.dateRegistered;
  //         res?.houseId = instance.houseId;
  //       });
  //       hasFetchedResidents.value = true;
  //     } else {
  //       Get.showSnackbar(GetSnackBar(
  //         message: "Unable to fetch resident info!",
  //         duration: Duration(seconds: 3),
  //       ));
  //     }
  //   } on SocketException catch (error) {
  //     throw Exception("Failed to fetch Attendance. $error");
  //   } catch (error) {
  //     throw Exception("Failed to fetch Attendance. $error");
  //   }
  // }

  Future<void> getServices() async {
    Future.wait([fetchAttendance()]);
  }

  Future<bool> submitComplaint(
      {required String title, required String msg}) async {
    // final authUserEmail = resident.value.email;

    Map<String, String> message = {
      "title": title,
      "message": msg,
    };

    try {
      loading.value = true;

      String endpoint = "${Endpoints.baseUrl}${Endpoints.complaint}";

      final response = await ApiService.postRequest(endpoint, message);

      if (response['status']) {
        Get.showSnackbar(GetSnackBar(
          message: "Complaint submitted successfully!",
          duration: Duration(seconds: 5),
          backgroundColor: Colors.green,
        ));

        return true;
      } else {
        Get.showSnackbar(GetSnackBar(
          message: "Unable to submit complaint!",
          duration: Duration(seconds: 3),
        ));
        return false;
      }
    } on SocketException catch (_) {
      Get.showSnackbar(GetSnackBar(
        message: "Error! Please check your connection!",
        duration: Duration(seconds: 3),
        backgroundColor: Colors.redAccent,
      ));
      return false;
    } catch (error) {
      logger.d(error);
      Get.showSnackbar(GetSnackBar(
        message: "Failed to submit complaint. $error",
        duration: Duration(seconds: 3),
        backgroundColor: Colors.redAccent,
      ));
      return false;
    } finally {
      loading.value = false;
    }
  }

  // Stream<QuerySnapshot<Map<String, dynamic>>> getMessageBoard() {
  //   final boardCollection = FirebaseFirestore.instance
  //       .collection("message_board")
  //       .where('estateId', isEqualTo: resident.value.estateId)
  //       .orderBy("created", descending: true);

  //   return boardCollection.snapshots();
  // }

  Stream<List<Map<String, dynamic>>> messageBoard() async* {
    try {
      var id = resident.value.estateId;
      logger.d(id);
      var response = await _networkHelper.get(
        '${Endpoints.getMessageBoard}$id',
      );

      logger.d(response);
      var hasError = isBadStatusCode(response.statusCode!);
      if (hasError) {
        throw response.statusCode.toString();
      }
      logger.i(response.data);
      if (response.data is List) {
        final List<Map<String, dynamic>> messages =
            List<Map<String, dynamic>>.from(response.data);
        yield messages;
      } else {
        throw "Invalid response data format";
      }
    } on SocketException {
      throw "Unable to connect to the internet";
    } on DioException catch (e) {
      throw (NetworkHelper.onError(e));
    }
  }

  Future<List<Complaint?>> getComplaintsFromDB(String email) async {
    try {
      change([], status: RxStatus.loading());
      String endpoint = "${Endpoints.baseUrl}${Endpoints.complaint}/$email";
      final response = await ApiService.getRequest(endpoint);
      if (response['status']) {
        final complaint = parseComplaints(response['response']);
        return complaint;
      } else {
        throw Exception("Failed to fetch Attendance");
      }
    } on SocketException catch (error) {
      throw Exception("Failed to fetch Attendance. $error");
    } catch (error) {
      throw Exception("Failed to fetch Attendance. $error");
    }
  }

  @override
  void dispose() {
    resident(null);
    super.dispose();
  }
}
