// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:residents/components/available_estates_modal.dart';
// import 'package:residents/components/available_houses_modal.dart';
// import 'package:residents/components/logo_widget.dart';
// import 'package:residents/controllers/auth/auth_controller.dart';
// import 'package:residents/models/other/app_user.dart';
// import 'package:residents/utils/app_theme.dart';
// import 'package:residents/utils/extensions.dart';
// import 'package:residents/utils/validator.dart';
// import 'package:residents/views/auth/sign_in_screen.dart';

// import 'components/already_have_an_account.dart';
// import 'components/auth_button.dart';
// import 'components/auth_text_field.dart';

// class SignUp extends GetResponsiveView<AuthController> {
//   SignUp({Key? key}) : super(key: key) {
//     Get.lazyPut(() => AuthController());
//   }
//
//   final TextEditingController _firstName = TextEditingController();
//   final TextEditingController _lastName = TextEditingController();
//   final TextEditingController _email = TextEditingController();
//   final TextEditingController _phone = TextEditingController();
//
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Column(
//             children: const [
//               Shield(),
//               Flexible(
//                 child: Image(
//                   fit: BoxFit.contain,
//                   image: AssetImage("assets/images/pattern.png"),
//                 ),
//               ),
//             ],
//           ),
//           Center(
//             child: SafeArea(
//               child: SingleChildScrollView(
//                 dragStartBehavior: DragStartBehavior.down,
//                 child: Card(
//                   margin: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.symmetric(
//                               vertical: Get.height * .035,
//                             ),
//                             child: Text(
//                               'SIGN UP',
//                               textAlign: TextAlign.center,
//                               style: GoogleFonts.lato(
//                                 textStyle: Theme.of(context).textTheme.headline3!.copyWith(
//                                       fontWeight: FontWeight.w900,
//                                       foreground: Paint()
//                                         ..style = PaintingStyle.stroke
//                                         ..strokeWidth = 1
//                                         ..color = Colors.orange,
//                                     ),
//                               ),
//                             ),
//                           ),
//                           AuthTextField(
//                             controller: _firstName,
//                             textInputType: TextInputType.name,
//                             hintText: 'First Name',
//                             validator: Validator.firstNameValidator,
//                             icon: Icons.person_outlined,
//                           ),
//                           AuthTextField(
//                             controller: _lastName,
//                             textInputType: TextInputType.name,
//                             hintText: 'Last Name',
//                             validator: Validator.lastNameValidator,
//                             icon: Icons.person_outlined,
//                           ),
//                           AuthTextField(
//                             controller: _phone,
//                             textInputType: TextInputType.phone,
//                             hintText: 'Phone',
//                             validator: Validator.phoneValidator,
//                             icon: Icons.phone_outlined,
//                           ),
//                           AuthTextField(
//                             controller: _email,
//                             textInputType: TextInputType.emailAddress,
//                             hintText: 'Email',
//                             validator: Validator.emailValidator,
//                             icon: Icons.email_outlined,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.all(11.0),
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   Icons.home_outlined,
//                                   color: Colors.orange,
//                                   size: 26,
//                                 ),
//                                 SizedBox(width: 12),
//                                 Expanded(
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       showBarModalBottomSheet(
//                                         expand: false,
//                                         context: context,
//                                         builder: (context) => EstatesModal(),
//                                       );
//                                     },
//                                     child: Obx(
//                                       () => Text(
//                                         controller.selectedEstate.value.name != null
//                                             ? controller.selectedEstate.value.name!
//                                             : 'Select Estate',
//                                         style: TextStyle(
//                                           color: controller.selectedEstate.value.name != null
//                                               ? Colors.black
//                                               : Colors.black26,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           Divider(
//                             height: 1,
//                             color: Colors.black,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.all(11.0),
//                             child: Row(
//                               children: [
//                                 Icon(Icons.home_outlined, color: Colors.orange, size: 26),
//                                 SizedBox(width: 12),
//                                 Expanded(
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       if (controller.selectedEstate.value.id != null) {
//                                         showBarModalBottomSheet(
//                                           expand: false,
//                                           context: context,
//                                           builder: (context) => EstateHousesModal(
//                                             estateId: controller.selectedEstate.value.id!,
//                                           ),
//                                         );
//                                       } else {
//                                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                                           content: Text("Please select an estate!"),
//                                         ));
//                                       }
//                                     },
//                                     child: Obx(
//                                       () => Text(
//                                         controller.house.value.address != null
//                                             ? controller.house.value.address!
//                                             : controller.placeholderText.value,
//                                         style: TextStyle(
//                                           color: controller.house.value.address != null
//                                               ? Colors.black
//                                               : Colors.black26,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           Divider(height: 1, color: Colors.black),
//                           Row(
//                             mainAxisSize: MainAxisSize.min,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 flex: 2,
//                                 child: DropdownButtonFormField(
//                                   alignment: AlignmentDirectional.center,
//                                   decoration: InputDecoration(
//                                     contentPadding: EdgeInsets.only(left: 8),
//                                   ),
//                                   hint: const Text(
//                                     'Gender',
//                                     style: TextStyle(color: Colors.black26),
//                                   ),
//                                   items: controller.sex.map<DropdownMenuItem<String>>(
//                                     (String value) {
//                                       return DropdownMenuItem<String>(
//                                         value: value,
//                                         child: Text(value),
//                                       );
//                                     },
//                                   ).toList(),
//                                   onChanged: (value) {
//                                     controller.gender.value = value as String;
//                                   },
//                                 ),
//                               ),
//                               SizedBox(width: 16),
//                               Expanded(
//                                 flex: 3,
//                                 child: DropdownButtonFormField(
//                                   decoration: InputDecoration(
//                                     contentPadding: EdgeInsets.only(left: 8),
//                                   ),
//                                   hint: const FittedBox(
//                                     fit: BoxFit.contain,
//                                     child: Text(
//                                       'Marital Status',
//                                       style: TextStyle(color: Colors.black26),
//                                     ),
//                                   ),
//                                   items: controller.status.map<DropdownMenuItem<String>>(
//                                     (String value) {
//                                       return DropdownMenuItem<String>(
//                                         value: value,
//                                         child: Text(value),
//                                       );
//                                     },
//                                   ).toList(),
//                                   onChanged: (value) {
//                                     controller.maritalStatus.value = value as String;
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                           AuthButton(
//                             title: 'SIGN UP',
//                             press: () async {
//                               if (_formKey.currentState!.validate() &&
//                                   controller.house.value.id != null) {
//                                 AppUser user = AppUser(
//                                   firstName: _firstName.text.trim().toSentenceCase(),
//                                   lastName: _lastName.text.trim().toSentenceCase(),
//                                   phoneNumber: _phone.text.trim(),
//                                   email: _email.text.trim().toLowerCase(),
//                                   gender: controller.gender.value,
//                                   maritalStatus: controller.maritalStatus.value,
//                                   houseInfo: controller.house.value,
//                                 );
//                                 controller.sendInfoForApproval(user);
//                               }
//                             },
//                             color: AppTheme.primaryColor,
//                           ),
//                           AlreadyHaveAnAccountCheck(
//                             login: false,
//                             press: () => Get.offAll(() => SignIn()),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
