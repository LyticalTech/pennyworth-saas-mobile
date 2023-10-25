import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:residents/controllers/auth/auth_controller.dart';
import 'package:residents/models/estate_office/resident.dart';
import 'package:residents/models/other/firebase_resident.dart';

class PushNotificationService {
  final FirebaseMessaging messaging;
  final Resident resident;

  PushNotificationService({required this.messaging, required this.resident});

  final FirebaseAuth auth = FirebaseAuth.instance;
  final AuthController authController = Get.find();

  Future initialise() async {
    if (Platform.isIOS) {
      await messaging.requestPermission();
    }

    String? fcmToken = await messaging.getToken();

    log("FCM TOKEN: $fcmToken");

    if (fcmToken != null && resident.id != null) {
      authController.updateAuthUserToken(resident.id!, fcmToken);
    }

    messaging.onTokenRefresh.listen((fcmToken) {
      if (auth.currentUser != null && resident.id != null) {
        authController.updateAuthUserToken(resident.id!, fcmToken);
      }
    }).onError((err) {});

    final estateId = resident.estateId;

    if (estateId != null) {
      await messaging.subscribeToTopic(estateId);
    }

    FirebaseMessaging.onMessage.listen(
      (message) {
        log("${message.data}");
        if (message.notification != null) {
          showSimpleNotification(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.notification?.title ?? "",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(message.notification?.body ?? ""),
              ],
            ),
          );
        }

        if (Platform.isIOS) log("${(message.data)['aps']['alert']}");
      },
    );
    messaging.getInitialMessage().then((value) => log("${value?.data}"));
  }

  sendNotificationTo(FirebaseResident? recipient, String? estateId) {
    if (recipient != null) {
      // messaging.sendMessage()
      messaging.sendMessage(to: recipient.fcmToken);
    }
  }
}
