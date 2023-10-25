import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:residents/components/text.dart';
import 'package:residents/controllers/auth/auth_controller.dart';
import 'package:residents/models/estate_office/resident.dart';
import 'package:residents/views/profile/add_dependants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthController controller = Get.find();
  late Resident _resident;

  @override
  void initState() {
    _resident = controller.resident.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText("Personal Info", size: 20, fontWeight: FontWeight.w600),
            SizedBox(height: 12),
            _rowItem("Name", _resident.fullName),
            _rowItem("Phone", _resident.phone ?? ""),
            _rowItem("Email", _resident.email ?? ""),
            _rowItem("Gender", _resident.gender ?? ""),
            _rowItem("Address", _resident.houseAddress ?? ""),
            SizedBox(height: 24),
            CustomText("Additional Info", size: 20, fontWeight: FontWeight.w600),
            _dependantsList(),
          ],
        ),
      ),
    );
  }

  Widget _dependantsList() {
    final residentDependants = _resident.dependants ?? [];
    if (residentDependants.isNotEmpty) {
      List<Widget> dependants = [];
      for (final dependant in residentDependants) {
        dependants.add(_rowItem("Name", "${dependant.fullName}"));
      }
      return Column(children: dependants);
    } else {
      return Padding(
        padding: EdgeInsets.only(top: 12.0),
        child: CustomText("No dependants", size: 17),
      );
    }
  }

  Widget _rowItem(String title, String value) {
    return Container(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: SizedBox(width: 80, child: CustomText(title, size: 16, color: Colors.black45)),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 8),
              padding: EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 0.5, color: Colors.black26)),
              ),
              child: CustomText(value, size: 16),
            ),
          )
        ],
      ),
    );
  }

  void _onSelect(int value) {
    if (value == 0) Get.to(() => AddDependants());
  }
}
