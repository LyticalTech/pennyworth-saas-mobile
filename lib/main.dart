import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:residents/components/constants.dart';
import 'package:residents/controllers/auth/auth_controller.dart';
import 'package:residents/firebase_options.dart';
import 'package:residents/services/preference_service.dart';
import 'package:residents/utils/environment.dart';
import 'package:residents/utils/logger.dart';
import 'package:residents/views/auth/sign_in_screen.dart';
import 'package:residents/views/welcome.dart';

Future<void> main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    WidgetsFlutterBinding.ensureInitialized();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    Hive.init(appDocPath);
    logger.i(appDocPath);
    await Hive.openBox('storage');
    await dotenv.load(fileName: Environment.envFile);
    await Firebase.initializeApp(
      name: 'Pennyworth sass',
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    runApp(OverlaySupport.global(child: Residents()));
  },
      (error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}

class Residents extends StatefulWidget {
  const Residents({Key? key}) : super(key: key);

  @override
  State<Residents> createState() => _ResidentsState();
}

class _ResidentsState extends State<Residents> {
  late AppPreferences preference;
  bool isAuthenticated = false;

  @override
  void initState() {
    setupPreferences();
    super.initState();
  }

  void setupPreferences() async {
    preference = AppPreferences();
    await preference.initialize();

    final accessToken = preference.getString("accessToken", "");
    final authUserId = preference.getString("authUserId", "");

    isAuthenticated = accessToken.isNotEmpty && authUserId.isNotEmpty;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        primaryColor: kPrimaryColor,
      ),
      home: isAuthenticated ? WelcomeScreen() : SignIn(),
      onInit: () async {
        Get.put(AuthController());
      },
    );
  }
}
