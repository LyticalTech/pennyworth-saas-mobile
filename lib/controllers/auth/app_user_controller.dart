import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:residents/controllers/shield/house_controller.dart';
import 'package:residents/models/other/app_user.dart';

class AppUserController extends GetxController {
  static AppUser? _appUser;

  static AppUser? get appUser => _appUser;

  Future<void> createAppUser(DocumentSnapshot snapshot) async {

    log(snapshot.data().toString());

    _appUser = AppUser.fromSnapshot(snapshot);
    updateHouse();
  }

  static void updateAppUser(AppUser? appUser) {
    _appUser = appUser;
    updateHouse();
  }

  static void updateHouse() async {
    HouseController house = Get.put(HouseController());
    if (_appUser?.houseInfo?.id != null) {
      await house.getHouse(_appUser!.houseInfo!.id!);
    }
  }
}
