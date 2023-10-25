import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:residents/components/filled_button.dart';
import 'package:residents/components/text.dart';
import 'package:residents/controllers/auth/app_user_controller.dart';
import 'package:residents/controllers/office/estate_office_controller.dart';
import 'package:residents/models/estate_office/resident.dart';
import 'package:residents/models/other/app_user.dart';
import 'package:residents/utils/app_theme.dart';
import 'package:residents/utils/helper_functions.dart';
import 'package:residents/views/estate_office/component/complaint_history.dart';

class Complaints extends StatefulWidget {
  @override
  State<Complaints> createState() => _ComplaintsState();
}

class _ComplaintsState extends State<Complaints> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  final EstateOfficeController _controller = Get.find();
  Resident? resident;

  @override
  void initState() {
    // appUser = AppUserController.appUser!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: "Title",
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppTheme.primaryColor),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black26),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          SizedBox(height: 24),
          TextField(
            controller: _bodyController,
            maxLines: 12,
            decoration: InputDecoration(
              hintText: "Type complaint here...",
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppTheme.primaryColor),
              ),
              contentPadding: EdgeInsets.all(12.0),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black26),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          SizedBox(height: 24),
          Obx(
            () => _controller.loading.value
                ? SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: Center(child: customActivityIndicator(size: 32)),
                  )
                : FilledButtons(title: 'Submit', onPressed: _submitComplaint),
          ),
          SizedBox(height: 16),
          TextButton(
            onPressed: () => Get.to(() => ComplaintHistory()),
            child: CustomText("Complaints History", size: 16),
          ),
        ],
      ),
    );
  }

  Future<void> _submitComplaint() async {
    if (_titleController.text.trim().isEmpty || _bodyController.text.trim().isEmpty) {
      Get.snackbar(
        "Field empty",
        "All fields are required!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(16),
      );
      return;
    }
    bool result = await _controller.submitComplaint(
      title: _titleController.text,
      msg: _bodyController.text,
    );

    if (result) {
      _titleController.text = "";
      _bodyController.text = "";
    }
  }
}
