// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:residents/components/logo_widget.dart';
// import 'package:residents/controllers/auth/auth_controller.dart';
// import 'package:residents/utils/app_theme.dart';
// import 'package:residents/utils/environment.dart';
// import 'package:residents/utils/helper_functions.dart';
// import 'package:residents/utils/validator.dart';
// import 'package:residents/views/welcome.dart';

// import 'components/auth_button.dart';
// import 'components/auth_text_field.dart';

// class AuthOTPScreen extends StatefulWidget {
//   AuthOTPScreen(this.email);

//   final String email;

//   @override
//   State<StatefulWidget> createState() => AuthOTPScreenState();
// }

// class AuthOTPScreenState extends State<AuthOTPScreen> {
//   final TextEditingController _otp = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   final AuthController controller = Get.find();

//   @override
//   void initState() {
//     log(widget.email);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           onPressed: () => Get.back(),
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const Shield(),
//               Card(
//                 margin: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.symmetric(vertical: 24),
//                           child: Text(
//                             'OTP',
//                             textAlign: TextAlign.center,
//                             style: GoogleFonts.lato(
//                               textStyle: Theme.of(context).textTheme.headline3!.copyWith(
//                                     fontWeight: FontWeight.w900,
//                                     foreground: Paint()
//                                       ..style = PaintingStyle.stroke
//                                       ..strokeWidth = 1
//                                       ..color = AppTheme.primaryColor,
//                                   ),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 62),
//                           child: AuthTextField(
//                             controller: _otp,
//                             autofocus: true,
//                             textInputType: TextInputType.number,
//                             hintText: 'Enter OTP',
//                             // align: TextAlign.s,
//                             validator: Validator.numberValidator,
//                           ),
//                         ),
//                         SizedBox(height: 12),
//                         AuthButton(
//                           title: 'Proceed',
//                           press: _handleSignInWithOTP,
//                           color: AppTheme.primaryColor,
//                         ),
//                         SizedBox(height: 24),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   _handleSignInWithOTP() async {
//     FocusManager.instance.primaryFocus?.unfocus();
//     if (!_formKey.currentState!.validate()) return;
//     Map<String, String> body = {
//       "residentEmail": widget.email,
//       "residentOTP": _otp.text.trim(),
//       "password": Environment.devPassword
//     };

//     Map<String, dynamic> res = await controller.signInWithOtp(body);
//     if (res['success']) {
//       Get.snackbar(
//         "Login Successful",
//         res['message'],
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//         duration: Duration(seconds: 4),
//         margin: EdgeInsets.all(16),
//       );
//       waitAndExec(4000, () => Get.offAll(() => WelcomeScreen()));
//     } else {
//       Get.snackbar(
//         "Sign In Error",
//         res['message'],
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         duration: Duration(seconds: 4),
//         margin: EdgeInsets.all(16),
//       );
//     }
//   }
// }
