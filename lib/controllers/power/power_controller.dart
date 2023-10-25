import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:residents/controllers/auth/auth_controller.dart';
import 'package:residents/helpers/constants.dart';
import 'package:residents/models/estate_office/resident.dart';
import 'package:residents/models/power/power.dart';
import 'package:residents/services/api_service.dart';

class PowerController extends GetxController with StateMixin<List<PowerSupply>> {
  final powerSources = Rx<List<PowerSource>>([]);
  final powerSupplies = Rx<List<PowerSupply>>([]);
  final AuthController authController = Get.find();

  final resident = Resident().obs;

  @override
  void onInit() {
    super.onInit();
    resident(authController.resident.value);
    fetchSupplies();
  }

  Future<bool> fetchSources() async {
    try {
      change([], status: RxStatus.loading());
      final estateId = resident.value.estateId ?? "";
      final endpoint = "${Endpoints.baseUrl}${Endpoints.powerSource}/$estateId" ;
      final response = await ApiService.getRequest(endpoint);
      if (response['status']) {
        powerSources.value = parsePowerSources(response['response']);
        return powerSources.value.isNotEmpty;
      } else {
        change([], status: RxStatus.error(response['message']));
        return false;
      }
    } on SocketException catch (_) {
      change([], status: RxStatus.error("Network error! Please check your connection."));
      return false;
    } catch (error) {
      change([], status: RxStatus.error("Error fetching power sources"));
      return false;
    }
  }

  Future<bool> fetchSupplies() async {
    try {
      change([], status: RxStatus.loading());
      final estateId = resident.value.estateId ?? "";
      const endPoint = Endpoints.baseUrl + Endpoints.powerSupply;
      final response = await ApiService.getRequest(endPoint, param: {'estateId': estateId});
      if (response['status']) {
        powerSupplies.value = parsePowerSupply(response['response']);
        change(powerSupplies.value, status: RxStatus.success());
        return powerSupplies.value.isNotEmpty;
      } else {
        change([], status: RxStatus.error(response['message']));
        return false;
      }
    } on SocketException catch (_) {
      change([], status: RxStatus.error("Network error! Please check your connection."));
      return false;
    } catch (error) {
      change([], status: RxStatus.error("Failed to fetch power supplies."));
      return false;
    }
  }

  void filterSupplies(String source) {
    List<PowerSupply> temp = [];
    temp.addAll(powerSupplies.value);
    if (source.isNotEmpty) {
      List<PowerSupply> result = temp;
      result.retainWhere((supply) => supply.source!.toLowerCase().contains(source.toLowerCase()));
      change(result, status: RxStatus.success());
    } else {
      change(powerSupplies.value, status: RxStatus.success());
    }
  }

  void filterSources(String by) {
    List<PowerSource> result = powerSources.value;
    if (by.isNotEmpty) {
      result.where((source) => source.name!.contains(by));
    } else {
      result = powerSources.value;
    }
  }

  void filterByDateRange(String startDate, String endDate) {
    List<PowerSupply> temp = [];
    temp.addAll(powerSupplies.value);
    final sd = DateTime.parse(startDate);
    final ed = DateTime.parse(endDate);
    temp.retainWhere((supply) {
      var supplyDate = DateTime.parse(supply.date!);

      log(supplyDate.toString());

      return supplyDate.isAfter(sd) && supplyDate.isBefore(ed);
    });
    if (temp.isNotEmpty) {
      change(temp, status: RxStatus.success());
    } else {
      change([], status: RxStatus.error("No Supply found between date range."));
    }
  }

  void reset() {
    if (powerSupplies.value.isNotEmpty) {
      change(powerSupplies.value, status: RxStatus.success());
    } else {
      fetchSupplies();
    }
  }
}
