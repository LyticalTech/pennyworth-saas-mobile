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
import 'package:residents/models/other/code.dart';
import 'package:residents/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class CodeController extends GetxController {
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

    _activeCodeCollection = _store.collection(Constants.activeCodeRef);

    // final houseController = Get.put(HouseController());

    // _house = HouseController.house;

    // if (_house.reservedKey != null && _house.reservedKey!.isNotEmpty) {
    _inactiveCodeCollection = _store.collection(
        'codes/${authController.resident.value?.houseId}/past_codes');
    // }
  }

  Future<void> generateCode() async {
    // _showPleaseWait();

    /*Map pastCodes = await _codeCollection.get().then((DocumentSnapshot documentSnapshot) {

      return documentSnapshot.data() as Map;

    });*/

    // String generatedCode = _house.reservedKey + _random().toString();
    String isoString = DateTime.now().millisecondsSinceEpoch.toString();

    // String generatedCode = isoString.substring(isoString.length - 5);

    code = Code(
      houseId: authController.resident.value.houseId.toString(),
      status: 'active',
      createdBy: authController.resident.value.id.toString(),
      createdAt: DateTime.now(),
      expires: getExpirationTime(),
      code: "generatedCode",
      vehicleImage: vehicleImage.value,
      visitorsImage: visitorImage.value,
      idCard: id.value,
    );

    shareCode.toggle();

    // Get.back();
  }

  int _random() {
    Random random = Random.secure();
    return min + random.nextInt(max - min);
  }

  Future<void> cancelCode(String codeId) async {
    try {
      _showPleaseWait();

      Code code = await _getActiveCode(codeId);

      code.status = 'cancelled';

      _insertIntoInactiveCodeCollection(code);

      _deleteFromActiveCodeCollection(codeId);

      _showToast('Code Cancelled');

      Get.back();
    } on Exception catch (_) {
      _showToast('Unable to cancel code');

      Get.back();
    }
  }

  Future<Code> _getActiveCode(String codeId) async {
    DocumentSnapshot snapshot = await _activeCodeCollection.doc(codeId).get();

    return Code.fromSnapshot(snapshot);
  }

  Future<void> _deleteFromActiveCodeCollection(String codeId) async {
    await _activeCodeCollection.doc(codeId).delete();
  }

  Future<void> _insertIntoInactiveCodeCollection(Code code) async {
    await _inactiveCodeCollection.add(code.toSnapshot());
  }

  Future<void> extendCodeByAnHour(String codeId, DateTime expiryTime) async {
    try {
      _showPleaseWait();

      expiryTime = expiryTime.add(const Duration(hours: 1));

      _updateCode(codeId, expiryTime);

      _showToast('Code Expiry Extended');

      Get.back();
    } on Exception catch (_) {
      _showToast('Unable to extend code expiry');

      Get.back();
    }
  }

  Future<void> _updateCode(String codeId, DateTime expiryTime) async {
    await _activeCodeCollection.doc(codeId).update({
      'expires': expiryTime,
    });
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

  Stream<List<Code>> get activeCodes {
    return _activeCodeCollection
        .where('houseId', isEqualTo: authController.resident.value!.houseId)
        .where('createdBy', isEqualTo: authController.resident.value!.id)
        .snapshots()
        .map(_allCodesBelongingToHousehold);
  }

  Stream<List<Code>> get inactiveCodes {
    return _inactiveCodeCollection
        .where('createdBy', isEqualTo: authController.resident.value!.id)
        .snapshots()
        .map(_allCodesBelongingToHousehold);
  }
}
