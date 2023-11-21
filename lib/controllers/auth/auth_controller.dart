import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:residents/components/please_wait_dialog.dart';
import 'package:residents/controllers/shield/house_controller.dart';
import 'package:residents/controllers/shield/image_controller.dart';
import 'package:residents/models/estate_office/resident.dart';
import 'package:residents/models/other/app_user.dart';
import 'package:residents/models/other/firebase_resident.dart';
import 'package:residents/models/other/house.dart';
import 'package:residents/models/other/status.dart';
import 'package:residents/services/auth_services.dart';
import 'package:residents/services/preference_service.dart';
import 'package:residents/services/push_notification_services.dart';
import 'package:residents/views/auth/components/input_email_dialog.dart';
import 'package:residents/views/auth/sign_in_screen.dart';
import 'package:residents/views/verification_view.dart';
import 'package:residents/views/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/constants.dart';
import '../../utils/logger.dart';
import '../../views/auth/failed_screen.dart';

class AuthController extends GetxController {
  RxString title = 'SIGN IN'.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late FirebaseApp _guards;
  late FirebaseAuth _guardsAuth;
  late final AuthServices _authServices;
  late Rx<Resident> resident;

  final selectedHouseAddress = ''.obs;

  late final List<String> sex = ['Female', 'Male', 'Others'];

  late final List<String> status = [
    'Single',
    'Engaged',
    'Married',
    'Separated',
    'Divorced',
    'Widowed'
  ];

  final isLoading = false.obs;

  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  final FirebaseDynamicLinks _dynamicLinks = FirebaseDynamicLinks.instance;

  final FirebaseFirestore _store = FirebaseFirestore.instance;

  final TextEditingController $email = TextEditingController();

  final TextEditingController $fullName = TextEditingController();

  final TextEditingController $houseId = TextEditingController();

  final TextEditingController $password = TextEditingController();

  var notificationService = PushNotificationService();

  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  RxBool signup = false.obs;

  bool forgotPassword = false;

  final houseAddress = ''.obs;

  final houseId = ''.obs;

  final gender = 'None'.obs;

  final maritalStatus = 'None'.obs;

  final house = House().obs;

  final placeholderText = 'Home Address'.obs;

  PendingDynamicLinkData? linkData;

  late StreamSubscription<User?> authStateStream;

  HouseController houseController = Get.put(HouseController());

  final displayName = ''.obs;

  final preference = AppPreferences();

  final isAuthenticated = false.obs;
  String? fcmToken;
  User? firebaseAuthUser;

  @override
  Future<void> onInit() async {
    _authServices = AuthServices();
    await preference.initialize();
    fcmToken = await notificationService.initialize();
    final accessToken = preference.getString("accessToken", "");
    final authUserId = preference.getString("authUserId", "");
    isAuthenticated.value = accessToken.isNotEmpty && authUserId.isNotEmpty;
    if (isAuthenticated.value) {
      // final residentInfo = fetchUserFromPref();
      // resident(residentInfo);
      // notificationService =
      //     PushNotificationService(messaging: messaging, resident: residentInfo);
    }

    super.onInit();
  }

  Future<void> switchAuthType() async {
    signup.value = !signup.value;
    title.value = signup() ? 'SIGN UP' : 'SIGN IN';
  }

  Future<void> authenticate() async {
    Get.dialog(
      AlertDialog(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const <Widget>[
            CircularProgressIndicator(),
            Text('Please wait...'),
          ],
        ),
      ),
      barrierDismissible: false,
    );
    if (signup()) {
      signUp();
    } else {
      // signIn();
    }
  }

  Future<void> checkDynamicLink() async {
    _dynamicLinks.onLink.listen((PendingDynamicLinkData? emailLink) {
      if (emailLink != null) {
        String link = emailLink.link.toString();
        _auth
            .signInWithEmailLink(email: $email.text, emailLink: link)
            .then((value) {
          Get.to(
            () => WelcomeScreen(),
            transition: Transition.fade,
            duration: const Duration(seconds: 1),
          );
        });
      }
    }).onError((error) {});
  }

  Future<Object> checkEmailAuthorization() async {
    try {
      HttpsCallable callable = _functions.httpsCallable('checkEmail');
      var response = await callable.call(<String, dynamic>{
        'houseId': $houseId.text,
        'email': $email.text,
      });
      if (response.data['status'] == true) {
        return Success(response: response);
      } else {
        return Failure(
          code: response.data['code'],
          errorResponse: response.data['message'],
        );
      }
    } on FirebaseFunctionsException catch (e) {
      return Failure(code: e.code, errorResponse: e.message as String);
    } catch (e) {
      return Failure(code: "Unknown Error", errorResponse: e);
    }
  }

  Future<void> signUp() async {
    Get.dialog(
      AlertDialog(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const <Widget>[
            CircularProgressIndicator(),
            Text('Please wait...'),
          ],
        ),
      ),
      barrierDismissible: false,
    );
    var image = Get.put(ImageController());
    var response = await checkEmailAuthorization();
    if (response is Success) {
      try {
        authStateStream.pause();
        await _auth
            .createUserWithEmailAndPassword(
                email: $email.text, password: $password.text)
            .then((value) async {
          if (value.user != null) {
            final String dir = (await getExternalStorageDirectory())!.path;
            final String path = '$dir/profileimage.jpg';
            firebase_storage.Reference ref = firebase_storage
                .FirebaseStorage.instance
                .ref()
                .child('profile_pics/${value.user?.uid}');
            if (image.imagePath != null) {
              var result = await FlutterImageCompress.compressAndGetFile(
                image.imagePath!.path,
                path,
                quality: 50,
              );
              File resultFile = File(result!.path);
              await ref.putFile(resultFile);
              value.user?.updatePhotoURL(await ref.getDownloadURL());
            }
            await value.user?.updateDisplayName($fullName.text);
            await _addUserToFirestore($houseId.text);
            await clearEditingControllers();
            authStateStream.resume();
          }
        });
        Get.showSnackbar(
          const GetSnackBar(
            duration: Duration(seconds: 3),
            icon: Icon(
              Icons.check,
              color: Colors.green,
            ),
            message: 'User Signed In Successfully',
          ),
        );
      } on FirebaseAuthException catch (e) {
        Get.back();
        Get.showSnackbar(
          GetSnackBar(
            duration: const Duration(seconds: 3),
            icon: const Icon(
              Icons.clear,
              color: Colors.red,
            ),
            message: _handleSignUpError(e),
          ),
        );
      } catch (e) {
        Get.back();
        Get.showSnackbar(
          const GetSnackBar(
            duration: Duration(seconds: 3),
            icon: Icon(
              Icons.clear,
              color: Colors.red,
            ),
            message: "Unknown Error",
          ),
        );
      }
    } else {
      Failure error = response as Failure;
      Get.back();
      Get.showSnackbar(
        GetSnackBar(
          icon: const Icon(
            Icons.check,
            color: Colors.green,
          ),
          message: error.errorResponse as String,
        ),
      );
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    isLoading.value = true;
    var res = await _authServices.signIn(email, password, fcmToken);
    res.fold(
      (l) => logger.e(l.errorResponse),
      (r) {
        _authServices.saveToken = r.accessToken;
        resident = Rx(r);
        logger.i(r.email);
        Get.to(
          () => WelcomeScreen(),
          transition: Transition.fade,
          duration: const Duration(seconds: 1),
        );
      },
    );
    isLoading.value = false;
  }

  Future<void> _addUserToFirestore(String houseId) async {
    User user = _auth.currentUser!;
    _store.collection(Constants.appUserRef).doc(user.uid).set({
      'uid': user.uid,
      'displayName': user.displayName,
      'email': user.email,
      'houseId': houseId,
    });
  }

  String _handleSignUpError(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'email-already-in-use':
        message = 'This email is already in use';
        break;
      case 'invalid-email':
        message = 'The email you entered is invalid';
        break;
      case 'user-not-found':
        message = 'This user is not registered';
        break;
      case 'operation-not-allowed':
        message = 'This operation is not allowed';
        break;
      case 'weak-password':
        message = 'The password you entered is too weak';
        break;
      default:
        message = 'An unknown error occurred';
        break;
    }
    return message;
  }

  Future<void> signOut() async {
    // resident(Resident());
    preference.clear();
  }

  /*
    NEW IMPLEMENTATIONS ADDED FOR EMAIL LINK AUTHENTICATION
   */

  Future<void> _retrieveInitialLink() async {
    PendingDynamicLinkData? linkData = await _authServices.init();

    if (linkData != null) {
      _handleLink(linkData);
    }

    return;
  }

  Future<void> _listenForLink() async {
    _authServices.linkStream().listen((PendingDynamicLinkData linkData) async {
      _handleLink(linkData);
    });
  }

  Future<void> _handleLink(PendingDynamicLinkData linkData) async {
    final String link = linkData.link.toString();

    final prefs = await SharedPreferences.getInstance();

    final String? email = prefs.getString('email');

    if (email != null) {
      await signInWithEmailLink(email: email, link: link);
    } else {
      Get.dialog(InputEmailDialog(link: link), barrierDismissible: false);
    }
  }

  Future<void> signInWithEmailLink(
      {required String email, required String link}) async {
    authStateStream.pause();
    Get.dialog(const PleaseWaitDialog());
    try {
      bool accountCheck = await _authServices.checkIfItsANewAccount(email);
      await _authServices
          .signInWithEmailLink(email: email, deepLink: link)
          .then((value) async {
        if (accountCheck == false) {
          await _authServices.copyNewUserDataToUserData(email, value.user!.uid);
        }
        final prefs = await SharedPreferences.getInstance();

        final String? fullName = prefs.getString('fullName');

        if (fullName != null || fullName != _auth.currentUser!.displayName) {
          await _auth.currentUser!.updateDisplayName(fullName);
        }
        Get.offAll(
          () => WelcomeScreen(),
          transition: Transition.fadeIn,
          duration: const Duration(seconds: 1),
        );
      });
    } catch (e) {
      Get.offAll(
        () => FailedApplicationScreen(
          title: 'An Error Occurred!',
          body: e.toString(),
          action: 'Go Back',
          press: () => Get.offAll(
            () => SignIn(),
            transition: Transition.fadeIn,
            duration: const Duration(seconds: 1),
          ),
        ),
        transition: Transition.fadeIn,
        duration: const Duration(seconds: 1),
      );
    }

    authStateStream.resume();
  }

  Future<void> clearEditingControllers() async {
    $email.clear();
    $password.clear();
    $houseId.clear();
    $fullName.clear();
  }

  Future<void> initializeGuardsApp() async {
    _guards = await Firebase.initializeApp(
      name: 'guards',
      options: const FirebaseOptions(
          appId: '1:781423469372:android:c27b8f1ac8c8f2bc147439',
          apiKey: 'AIzaSyD800ziOrJwUaAKcEdTH3S0DQky0RYwQVE',
          messagingSenderId: '781423469372',
          projectId: 'lytical-shield'),
    );
    _guardsAuth = FirebaseAuth.instanceFor(app: _guards);
  }

  Future<void> guardsSignIn() async {
    await _guardsAuth.signInAnonymously().then(
          (value) => Get.offAll(
            () => VerificationView(),
            transition: Transition.fadeIn,
            duration: const Duration(seconds: 1),
          ),
        );
  }

  Future<void> guardsSignOut() async {
    await _guardsAuth.signOut();
  }

  static User getAuthUser() => FirebaseAuth.instance.currentUser!;

  // Future<void> updateAuthUserToken(String userId, String fcmToken) async {
  //   DocumentReference docRef =
  //       FirebaseFirestore.instance.collection("residents").doc(userId);

  //   docRef.get().then((snapshot) {
  //     if (snapshot.data() != null) {
  //       docRef.update({'fcmToken': fcmToken});
  //     }
  //   });
  // }

  Stream<QuerySnapshot<House>> fetchHouseAddresses(String estateId) {
    return houseController.getAllHouses(estateId);
  }

  Future<bool> addDependant(String authUserId, AppUser dependant) async {
    final userRef =
        FirebaseFirestore.instance.collection("users").doc(authUserId);
    return await userRef.update({
      'dependants': FieldValue.arrayUnion([dependant.toSnapshot()])
    }).then((value) => true);
  }

  Stream<DocumentSnapshot<AppUser>> getAuthUserSnapshot() {
    final snapshot = FirebaseFirestore.instance
        .collection("users")
        .withConverter<AppUser>(
          fromFirestore: (snapshot, _) => AppUser.fromSnapshot(snapshot),
          toFirestore: (user, _) => user.toSnapshot(),
        )
        .doc(_auth.currentUser!.uid)
        .snapshots();
    return snapshot;
  }

  // Future<void> saveResidentToFirebase(Resident resident) async {
  //   DocumentReference docRef = _store.collection("residents").doc(resident.id);

  //   docRef.get().then((snapshot) {
  //     if (!snapshot.exists) {
  //       _store
  //           .collection("residents")
  //           .doc(resident.id)
  //           .set(FirebaseResident.fromResident(resident).toSnapshot());
  //     }
  //   });
  // }

  // Future<void> saveUserToPreference(Resident resident) async {
  //   preference.setString("accessToken", resident.accessToken ?? "");
  //   preference.setString("authUserId", resident.id ?? "");
  //   preference.setString("firstName", resident.firstName ?? "");
  //   preference.setString("lastName", resident.lastName ?? "");
  //   preference.setString("email", resident.email ?? "");
  //   preference.setString("phone", resident.phone ?? "");
  //   preference.setString("gender", resident.gender ?? "");
  //   preference.setString("maritalStatus", resident.maritalStatus ?? "");
  //   preference.setString("houseId", resident.houseId ?? "");
  //   preference.setString("houseAddress", resident.houseAddress ?? "");
  //   preference.setString("estateId", resident.estateId ?? "");
  //   preference.setString("estateAddress", resident.estateAddress ?? "");
  //   preference.setString("estateName", resident.estateName ?? "");
  // }

  // Resident fetchUserFromPref() {
  //   final resident = Resident()
  //     ..accessToken = preference.getString("accessToken", "")
  //     ..id = preference.getString("authUserId", "")
  //     ..firstName = preference.getString("firstName", "")
  //     ..lastName = preference.getString("lastName", "")
  //     ..email = preference.getString("email", "")
  //     ..phone = preference.getString("phone", "")
  //     ..gender = preference.getString("gender", "")
  //     ..maritalStatus = preference.getString("maritalStatus", "")
  //     ..houseId = preference.getString("houseId", "")
  //     ..houseAddress = preference.getString("houseAddress", "")
  //     ..estateId = preference.getString("estateId", "")
  //     ..estateAddress = preference.getString("estateAddress", "")
  //     ..estateName = preference.getString("estateName", "");

  //   return resident;
  // }

  Future<void> loginAndPrepFirebase() async {
    _auth.authStateChanges().listen((user) async {
      if (user == null) {
        try {
          final userCredential = await _auth.signInAnonymously();
          firebaseAuthUser = userCredential.user;
          // prepFirebaseMessaging();
        } on FirebaseAuthException catch (e) {
          switch (e.code) {
            case "operation-not-allowed":
              log("Anonymous auth hasn't been enabled for this project.");
              break;
            default:
              log("Unknown error.");
          }
        }
      } else {
        firebaseAuthUser = user;
      }
    });
  }

  // void prepFirebaseMessaging() {
  //   final FirebaseMessaging messaging = FirebaseMessaging.instance;
  //   final notificationService = PushNotificationService(
  //     messaging: messaging,
  //     resident: resident.value,
  //   );
  //   notificationService.initialise();
  // }

  Future<FirebaseResident?> fetchFirestoreUser(String docRef) async {
    return await _store
        .collection("residents")
        .doc(docRef)
        .withConverter<FirebaseResident>(
          fromFirestore: (snapshot, _) =>
              FirebaseResident.fromJson(snapshot.data()!),
          toFirestore: (user, _) => user.toSnapshot(),
        )
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        return snapshot.data();
      } else {
        return null;
      }
    });
  }

  @override
  void dispose() {
    resident(null);
    house(House());
    preference.clear();
    super.dispose();
  }
}
