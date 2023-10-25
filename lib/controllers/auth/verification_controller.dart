import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:residents/components/verification_dialog_widget.dart';

import '../../utils/constants.dart';

class VerificationController extends GetxController{

  late final FirebaseFirestore _store;

  late final FToast fToast;

  late final TextEditingController verificationTextController;

  late final CollectionReference _activeCodes;

  Container successToast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.greenAccent,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(
          Icons.check,
          color: Colors.green,
        ),
        SizedBox(
          width: 12.0,
        ),
        Text("Code Copied"),
      ],
    ),
  );

  Container failedToast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.grey,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(
          Icons.clear,
          color: Colors.red,
        ),
        SizedBox(
          width: 12.0,
        ),
        Text("Sorry Operation Failed"),
      ],
    ),
  );

  @override
  void onInit() {
    verificationTextController = TextEditingController();

    fToast = FToast();

    fToast.init(Get.context!);

    _store = FirebaseFirestore.instance;

    _activeCodes = _store.collection(Constants.activeCodeRef);

    super.onInit();
  }

  void showVerificationDialog() {
    Get.dialog(VerificationDialog(),
    );
  }

  Future<void> verifyCode () async {
    _activeCodes.doc(verificationTextController.text).get().then((_) => {});
  }

}