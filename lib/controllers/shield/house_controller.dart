import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:residents/models/other/app_user.dart';
import 'package:residents/models/other/house.dart';
import 'package:residents/utils/constants.dart';

class HouseController extends GetxController {
  static late House _house;

  late final FirebaseFirestore _store;

  late final CollectionReference _housesCollection;
  late final CollectionReference _estatesCollection;

  static House get house => _house;

  late CollectionReference<House> houseCollectionRef;
  late CollectionReference<Estate> estateCollectionRef;

  HouseController() {
    _store = FirebaseFirestore.instance;

    _housesCollection = _store.collection(Constants.houseRef);
    _estatesCollection = _store.collection(Constants.estatesRef);

    houseCollectionRef = _housesCollection.withConverter<House>(
      fromFirestore: (snapshot, _) => House.fromSnapshot(snapshot),
      toFirestore: (house, _) => house.toJson(),
    );

    estateCollectionRef = _estatesCollection.withConverter<Estate>(
      fromFirestore: (snapshot, _) => Estate.fromJson(snapshot.data() ?? {}),
      toFirestore: (estate, _) => estate.toJson(),
    );
  }

  Future<void> getHouse(String houseId) async {
    await _housesCollection.doc(houseId).get().then((DocumentSnapshot snap) {
      _house = House.fromSnapshot(snap);
    }).onError((error, stackTrace) {
      Get.showSnackbar(
        GetSnackBar(
          duration: const Duration(seconds: 3),
          icon: const Icon(
            Icons.clear,
            color: Colors.red,
          ),
          message: error.toString(),
        ),
      );
    });
  }

  Future<DocumentReference<House>?> addNewHouse(House house) async {
    DocumentSnapshot<House> houseRef = await houseCollectionRef.doc(house.id).get();
    if (houseRef.exists) {
      Get.showSnackbar(
        GetSnackBar(
          duration: const Duration(seconds: 3),
          icon: const Icon(
            Icons.clear,
            color: Colors.red,
          ),
          message: "House ID already exist!",
        ),
      );
      return null;
    }
    else {
      return houseCollectionRef
          .doc(house.id)
          .set(house)
          .then((value) => houseCollectionRef.doc(house.id));
    }
  }

  Stream<QuerySnapshot<House>> getAllHouses(String estateId) {
    return houseCollectionRef.where('estateId', isEqualTo: estateId).snapshots();
  }

  Stream<QuerySnapshot<Estate>> getAllEstates() {
    return estateCollectionRef.snapshots();
  }
}
