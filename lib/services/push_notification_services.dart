import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  PushNotificationService() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    log('Handling a background message: ${message.messageId}');
  }

  Future<String?> initialize() async {
    await messaging.requestPermission();
    String? fcmToken = await messaging.getToken();
    return fcmToken;
  }
}
