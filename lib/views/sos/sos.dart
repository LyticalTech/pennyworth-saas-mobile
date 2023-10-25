import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:residents/components/text.dart';
import 'package:residents/controllers/auth/auth_controller.dart';
import 'package:residents/controllers/sos/sos_controller.dart';
import 'package:residents/models/estate_office/resident.dart';
import 'package:url_launcher/url_launcher.dart';

class SOS extends StatefulWidget {
  @override
  State<SOS> createState() => _SOSState();
}

class _SOSState extends State<SOS> {
  final controller = Get.put(SOSController());
  final AuthController authController = Get.find();
  bool panicMessageSent = false;

  late Resident resident;

  @override
  void initState() {
    resident = authController.resident.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SOS"),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text.rich(
                TextSpan(
                  text: "INFO: ",
                  style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: "SOS is a distress signal used to indicate that a person or group"
                          " is in danger and needs immediate assistance.\n\n"
                          "Please click on the PANIC BUTTON to alert residents within your Estate or"
                          " click on the LOCAL POLICE DEPARTMENT button to contact the nearest"
                          " police department for urgent help.",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        height: 1.2,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text.rich(
                TextSpan(
                  text: "WARNING: ",
                  style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: "DO NOT use except in a case of DISTRESS OR EMERGENCY.",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        height: 1.2,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            CustomText("Panic Button", size: 20, fontWeight: FontWeight.w600),
            SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: controller.loading.value || panicMessageSent ? Colors.grey : Colors.red,
              ),
              child: Obx(
                () => IconButton(
                  onPressed: controller.loading.value || panicMessageSent
                      ? null
                      : () => {HapticFeedback.vibrate(), _onPanicButtonTapped()},
                  icon: Icon(Icons.power_settings_new, color: Colors.white),
                  iconSize: 90,
                ),
              ),
            ),
            Spacer(),
            CustomText("Local Police Department", size: 20, fontWeight: FontWeight.w600),
            SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
              child: IconButton(
                onPressed: () => {HapticFeedback.heavyImpact(), _handleCall()},
                icon: Icon(Icons.phone, color: Colors.white, size: 64),
                iconSize: 90,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  void _onPanicButtonTapped() async {
    final sendMessage = await controller.sendPanicMessage(
      estateId: resident.estateId ?? "",
      residentName: resident.fullName,
      residentAddress: resident.houseAddress ?? "",
    );
    if (sendMessage) {
      setState(() => panicMessageSent = true);
    }
  }

  void _handleCall() async {
    await launchUrl(Uri.parse("tel:112"));
  }
}
