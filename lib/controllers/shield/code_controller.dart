import 'dart:core';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:residents/controllers/auth/auth_controller.dart';
import 'package:residents/helpers/snackbar.dart';
import 'package:residents/models/other/code.dart';
import 'package:residents/services/code_services.dart';
import 'package:residents/utils/constants.dart';
import 'package:residents/utils/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class CodeController extends GetxController {
  final CodeServices _codeServices = CodeServices();
  var isGeneratingCode = false.obs;

  late final FirebaseFirestore _store;
  late final FToast fToast;
  late final CollectionReference _activeCodeCollection;
  late final CollectionReference _inactiveCodeCollection;

  // late House _house;

  final AuthController authController = Get.find();
  RxBool visitorImage = false.obs;
  RxBool vehicleImage = false.obs;
  RxBool id = false.obs;
  RxBool shareCode = false.obs;

  // late Stream<List<Code>> _codes;
  var activeCodes = Rx<List<Code>>([]);
  var inActiveCodes = Rx<List<Code>>([]);
  RxBool loadingActiveCodes = false.obs;
  RxBool loadingInActiveCodes = true.obs;
  RxBool isCancelingCode = false.obs;

  late final Code code;
  Uri lytical = Uri.parse('lyticaltechnology.com');
  final int min = Constants.min;
  final int max = Constants.max;

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

  late CollectionReference userCollectionRef;

  // late CollectionReference<AppUser> userRef;

  @override
  void onInit() {
    super.onInit();
    fToast = FToast();
    fToast.init(Get.context!);
    _store = FirebaseFirestore.instance;
    getActiveCode();
    getInActiveCode();

    _activeCodeCollection = _store.collection(Constants.activeCodeRef);

    // final houseController = Get.put(HouseController());

    // _house = HouseController.house;

    // if (_house.reservedKey != null && _house.reservedKey!.isNotEmpty) {
    _inactiveCodeCollection = _store.collection(
        'codes/${authController.resident.value.houseId}/past_codes');
    // }
  }

  Future<void> generateCode() async {
    isGeneratingCode.value = true;

    var response = await _codeServices.generate(
      visitorImage.value,
      vehicleImage.value,
      id.value,
    );

    isGeneratingCode.value = false;

    response.fold((l) {
      redSnackBar("Unable to generate code");
      Get.back();
    }, (r) {
      logger.i(r);
      code = Code(
        houseId: authController.resident.value.houseId,
        status: 'active',
        createdBy: authController.resident.value.id.toString(),
        createdAt: DateTime.now(),
        expires: getExpirationTime(),
        code: r.code,
        vehicleImage: vehicleImage.value,
        visitorsImage: visitorImage.value,
        idCard: id.value,
        codeId: 0,
      );

      shareCode.toggle();
    });

    // Get.back();
  }

  Future<void> getActiveCode() async {
    loadingActiveCodes.value = true;
    var response = await _codeServices.activeCode();

    response.fold(
      (l) => redSnackBar('Error getting active codes'),
      (r) => activeCodes.value = r,
    );
    loadingActiveCodes.value = false;
  }

  void getInActiveCode() async {
    loadingInActiveCodes.value = true;
    var response = await _codeServices.inActiveCode();

    response.fold(
      (l) => redSnackBar('Error getting inactive codes'),
      (r) {
        inActiveCodes.value = r;
      },
    );
    loadingInActiveCodes.value = false;
  }

  int _random() {
    Random random = Random.secure();
    return min + random.nextInt(max - min);
  }

  Future<void> cancelCode(int codeId) async {
    try {
      isCancelingCode.value = true;
      loadingActiveCodes.value = true;
      var response = await _codeServices.cancelCodeApi(codeId);
      response.fold(
        (l) {
          redSnackBar("Error canceling code");
        },
        (r) async {
          await getActiveCode();
          Get.back();
        },
      );
      // Get.back();
      loadingActiveCodes.value = false;
      isCancelingCode.value = false;

      // Get.back();
      _showToast('Code Cancelled');
    } on Exception catch (_) {
      _showToast('Unable to cancel code');

      Get.back();
    }
  }

  // Future<Code> _getActiveCode(String codeId) async {
  //   DocumentSnapshot snapshot = await _activeCodeCollection.doc(codeId).get();

  //   return Code.fromSnapshot(snapshot);
  // }

  Future<void> extendCodeByAnHour(String codeId) async {
    try {
      // Get.back();
      loadingActiveCodes.value = true;
      await _updateCode(codeId);
      Get.back();
    } on Exception catch (_) {
      _showToast('Unable to extend code expiry');
    }
  }

  Future<void> _updateCode(String codeId) async {
    var response = await _codeServices.extendCode(codeId);

    response.fold(
      (l) {
        _showToast('Unable to extend code expiry');
      },
      (r) async {
        await getActiveCode();

        _showToast('Code Expiry Extended');
      },
    );
  }

  List<Code> _allCodesBelongingToHousehold(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Code.fromSnapshot(doc);
    }).toList();
  }

  Future<void> copyCode() async {
    try {
      Clipboard.setData(ClipboardData(text: code.code));
      _showToast("Code Copied");
    } catch (e) {
      _showToast("Unable to Copy Code");
    }
  }

  Future<void> shareCodeOnWhatsApp() async {
    String residentsName =
        FirebaseAuth.instance.currentUser?.displayName ?? 'A resident';
    String homeAddress = authController.resident.value!.houseAddress ?? "";
    final link = WhatsAppUnilink(
      text: """Hey! 
You have been invited to $homeAddress by $residentsName.

Your entry code is

        ${code.code}
        
This code expires ${DateFormat("EEEE dd MMMM, yyyy, @ hh:mm aaa").format(code.expires)}.
        
Thank you.

Powered by $lytical
""",
    );
    try {
      await launch('$link');
    } catch (e, _) {
      _showToast("Unable to Launch WhatsApp");
    }
  }

  void _showPleaseWait() {
    Get.dialog(
      AlertDialog(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const <Widget>[
            CircularProgressIndicator(),
            Text('Please wait...'),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  _showToast(String toast) {
    Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  DateTime getExpirationTime() {
    DateTime expire = DateTime.now().add(Constants.expirationDuration);
    return DateTime(expire.year, expire.month, expire.day, expire.hour, 59);
  }
}
