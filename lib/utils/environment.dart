import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {

  static get envFile => kReleaseMode ? '.env.production' : '.env.development';

  static get flutterwaveEncryptionKey => dotenv.env['ENCRYPTION_KEY'];

  static get flutterwavePublicKey => dotenv.env['FLUTTERWAVE_PUBLIC_KEY'];

  static get firebaseAppIdIOS => dotenv.env['FIREBASE_APP_ID_IOS'];

  static get firebaseAppIdAndroid => dotenv.env['FIREBASE_APP_ID_ANDROID'];

  static get firebaseAPIKey => dotenv.env['FIREBASE_API_KEY'];

  static get messagingId => dotenv.env['MESSAGING_SENDER_ID'];

  static get projectId => dotenv.env['PROJECT_ID'];

  static get devPassword => dotenv.env['DEV_PASSWORD'];

}