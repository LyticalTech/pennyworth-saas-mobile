import 'package:flutter/material.dart';
import 'package:get/get.dart';

_baseSnackBar(String message, Color color) {
  return Get.snackbar('', message,
      titleText: Container(),
      backgroundColor: color,
      colorText: Colors.white,
      margin: const EdgeInsets.all( 24));
}

redSnackBar(String message) {
  return _baseSnackBar(message, Colors.red);
}

greenSnackBar(String message) {
  return _baseSnackBar(message, Colors.green);
}
