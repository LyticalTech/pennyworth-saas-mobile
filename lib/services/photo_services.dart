/*
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';

class PhotoServices {

  late final FirebaseStorage _storage;

  late final ImagePicker _imagePicker;

  PhotoServices() {
    _imagePicker = ImagePicker();
  }

  Future<File?> onCamera() async {
    return await _imagePicker.pickImage(source: ImageSource.camera).then((image) {
      return File(image!.path);
    });
  }

  Future<File?> onGallery() async {
    return await _imagePicker.pickImage(source: ImageSource.gallery).then((image) {
      return File(image!.path);
    });
  }

  Future<void> uploadImage({required String id, required File image}) async {
    _storage = FirebaseStorage.instance;
    Reference ref = _storage.ref().child('profile_photos/$id');
    return await ref.putFile(image).then((p0) => p0.ref.getDownloadURL());
  }
}
*/
