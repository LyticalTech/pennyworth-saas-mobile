import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';
import 'package:residents/models/other/app_user.dart';
import 'package:residents/models/other/firebase_resident.dart';
import 'package:residents/models/other/status.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  late final FirebaseAuth _auth;
  late final FirebaseDynamicLinks _links;
  late final FirebaseFirestore _store;

  // _store.collection("residents")
  //
  // static final userRef = userCollectionRef.withConverter<AppUser>(
  //   fromFirestore: (snapshot, _) => AppUser.fromJson(snapshot.data()!),
  //   toFirestore: (user, _) => user.toJson(),
  // );

  AuthServices() {
    _auth = FirebaseAuth.instance;
    _links = FirebaseDynamicLinks.instance;
    _store = FirebaseFirestore.instance;
  }

  final ActionCodeSettings acs = ActionCodeSettings(
    url: "https://middle-chase.firebaseapp.com/",
    handleCodeInApp: true,
    androidPackageName: "com.pennyworth.middlechase",
    iOSBundleId: "com.pennyworth.middlechase",
    androidInstallApp: true,
    androidMinimumVersion: '1',
  );

  Future<PendingDynamicLinkData?> init() async {
    // Check dynamic link once app starts up.
    // This is required to process any dynamic links if the app is opened by a link
    return await _links.getInitialLink();
  }

  Stream<PendingDynamicLinkData> linkStream() {
    return _links.onLink;
  }

  Stream<User?> userStream() {
    return _auth.authStateChanges();
  }

  Future<Object> sendSignInLink(String email) async {
    bool checkEmail = await checkIfItsANewAccount(email);

    if (checkEmail) {
      return _auth
          .sendSignInLinkToEmail(email: email, actionCodeSettings: acs)
          .catchError((onError) => Failure(
              code: 'Failed',
              errorResponse: "There's nothing to log"
                  ". $onError"))
          .then((value) => Success(response: "Success"));
    } else {
      return Failure(
        code: 'Unregistered User',
        errorResponse: "Please register first",
      );
    }
  }

  Future<UserCredential> signInWithEmailLink(
      {required String email, required String deepLink}) async {
    return await _auth.signInWithEmailLink(email: email, emailLink: deepLink);
  }

  Future<void> signOut() async {
    _auth.signOut();
    //Todo: Uncomment to close app after sign out
    // exit(0);
  }

  Future<bool> checkIfItsANewAccount(String email) async {
    try {
      return await _auth.fetchSignInMethodsForEmail(email).then((List<String> methods) {
        if (methods.isNotEmpty) {
          return true;
        } else {
          return false;
        }
      }).onError((error, stackTrace) {
        printInfo(info: error.toString());
        return false;
      });
    } on FirebaseAuthException catch (_) {
      return false;
    }
  }

  Future<void> sendNewUserData(AppUser user) async {
    await _store.collection('new_users').add(user.toSnapshot());
  }

  Future<void> copyNewUserDataToUserData(String email, String id) async {
    late String docId;
    CollectionReference ref = _store.collection('new_users');
    QuerySnapshot snapshot = await ref.where('email', isEqualTo: email).limit(1).get();

    for (var doc in snapshot.docs) {
      await _store.collection('users').doc(id).set({
        'firstName': doc['firstName'],
        'lastName': doc['lastName'],
        'email': doc['email'],
        'gender': doc['gender'],
        'maritalStatus': doc['maritalStatus'],
        'phoneNumber': doc['phoneNumber'],
        'houseInfo': doc['houseInfo'],
        'dependants': doc['dependants']
      });

      docId = doc.id;

      ref.doc(docId).delete();
    }
  }

  String _handleAuthError(FirebaseAuthException e) {
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
      case 'Bad state':
        message = 'The password you entered is too weak';
        break;
      default:
        message = 'An unknown error occurred';
        break;
    }
    return message;
  }

  Future<void> persistEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('email', email);
  }

  Future<void> persistUserInfo(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('email', user.email);
    await prefs.setString('fullName', '${user.firstName} ${user.lastName}');
  }

  Future<bool> emailExists(String email) async {
    CollectionReference newUsersRef = _store.collection('new_users');
    QuerySnapshot newUserSnapshot = await newUsersRef.where('email', isEqualTo: email).get();

    CollectionReference usersRef = _store.collection('users');
    QuerySnapshot usersSnapshot = await usersRef.where('email', isEqualTo: email).get();

    return newUserSnapshot.docs.isNotEmpty || usersSnapshot.docs.isNotEmpty;
  }
}
