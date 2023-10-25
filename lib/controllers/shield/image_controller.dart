import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/or_divider.dart';

class ImageController extends GetxController {
  late final ImagePicker imagePicker;

  late Rx<Image> image = const Image(
    image: NetworkImage('https://bit.ly/3CQb4Hn'),
    fit: BoxFit.cover,
    width: 100,
    height: 100,
  ).obs;

  File? imagePath;

  ImageController() {
    imagePicker = ImagePicker();
  }

  Future<void> pickImage() async {
    Get.bottomSheet(
      SizedBox(
        height: 150,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                color: Colors.deepOrange,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  "Pick Image Source",
                  style: GoogleFonts.lato(fontSize: 25, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: TextButton(
                onPressed: () {
                  pickImageFromSource(ImageSource.camera);
                },
                child: Text(
                  'Camera',
                  style: GoogleFonts.roboto(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const OrDivider(),
            Expanded(
              flex: 1,
              child: TextButton(
                onPressed: () {
                  pickImageFromSource(ImageSource.gallery);
                },
                child: Text(
                  'Gallery',
                  style: GoogleFonts.roboto(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Future<void> pickImageFromSource(ImageSource source) async {
    Get.back();
    await imagePicker.pickImage(source: source).then((image) {
      if (image != null) {
        imagePath = File(image.path);
        this.image.value = Image(
          image: FileImage(imagePath!),
          fit: BoxFit.cover,
          width: 100,
          height: 100,
        );
      }
    });
  }
}
