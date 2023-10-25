import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:residents/components/filled_button.dart';
import 'package:residents/components/input_label.dart';
import 'package:residents/components/labelled_datetime_picker.dart';
import 'package:residents/components/text_field.dart';
import 'package:residents/controllers/facility/facility_controller.dart';
import 'package:residents/models/facility/facility_response.dart';
import 'package:residents/utils/extensions.dart';
import 'package:residents/utils/helper_functions.dart';

class BookFacility extends StatelessWidget {
  BookFacility({required this.facility});

  final FacilityResponse facility;

  final FacilityController controller = Get.put(FacilityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book ${StringExt(facility.name!).toSentenceCase()}"),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 36, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: "Please fill the form below to book ",
                style: TextStyle(color: Colors.black54, fontSize: 17),
                children: [
                  TextSpan(
                    text: "${StringExt(facility.name!).toSentenceCase()}.",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 24),
            LabelledDateTimePicker(
              label: "From Date/Time",
              controller: controller.fromDateTimeController,
            ),
            SizedBox(height: 16),
            LabelledDateTimePicker(
              label: "To Date/Time",
              controller: controller.toDateTimeController,
            ),
            SizedBox(height: 16),
            InputLabel(title: "No of Slot"),
            CustomTextField(
              hint: "E.g. 2",
              controller: controller.slotController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            InputLabel(title: "Description"),
            CustomTextArea(
              hintText: "Description",
              controller: controller.descriptionController,
            ),
            SizedBox(height: 32),
            Obx(
              () => controller.loading.value
                  ? SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: Center(child: customActivityIndicator(size: 32)),
                    )
                  : FilledButtons(title: 'Submit', onPressed: () => _handleBookFacility(context)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleBookFacility(BuildContext context) async {
    bool response = await controller.bookFacility(facility);
    if (response) {
      controller.clear();
      waitAndExec(5, () => Navigator.pop(context));
    }
  }
}
