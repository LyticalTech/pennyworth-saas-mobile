import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:residents/components/auth_components.dart';
import 'package:residents/components/text.dart';
import 'package:residents/controllers/auth/app_user_controller.dart';
import 'package:residents/controllers/auth/auth_controller.dart';
import 'package:residents/models/other/app_user.dart';
import 'package:residents/utils/app_theme.dart';
import 'package:residents/utils/extensions.dart';
import 'package:residents/utils/validator.dart';

class AddDependants extends StatefulWidget {
  const AddDependants({Key? key}) : super(key: key);

  @override
  State<AddDependants> createState() => _AddDependantsState();
}

class _AddDependantsState extends State<AddDependants> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();

  bool loading = false;

  final _formKey = GlobalKey<FormState>();

  late final List<String> sex = ['Female', 'Male', 'Others'];
  late final List<String> relationships = [
    'Parent',
    'Child',
    'Sibling',
    'Friend',
    'Domestic Staff',
    'Other'
  ];

  String gender = "";
  String relationship = "";

  late AppUser appUser;

  AuthController controller = Get.find();

  @override
  void initState() {
    appUser = AppUserController.appUser!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Add Dependant"),),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AuthTextField(
                controller: _firstName,
                textInputType: TextInputType.name,
                hintText: 'First Name',
                validator: Validator.firstNameValidator,
                icon: Icons.person_outlined,
              ),
              AuthTextField(
                controller: _lastName,
                textInputType: TextInputType.name,
                hintText: 'Last Name',
                validator: Validator.lastNameValidator,
                icon: Icons.person_outlined,
              ),
              AuthTextField(
                controller: _phone,
                textInputType: TextInputType.phone,
                hintText: 'Phone',
                validator: Validator.phoneValidator,
                icon: Icons.phone_outlined,
              ),
              AuthTextField(
                controller: _email,
                textInputType: TextInputType.emailAddress,
                hintText: 'Email (Optional)',
                icon: Icons.email_outlined,
              ),
              DropdownButtonFormField(
                alignment: AlignmentDirectional.centerStart,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 8),
                ),
                hint: const Text('Gender', style: TextStyle(color: Colors.black26)),
                items: sex.map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value));
                  },
                ).toList(),
                onChanged: (value) => setState(() => gender = value as String),
              ),
              DropdownButtonFormField(
                alignment: AlignmentDirectional.centerStart,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 8),
                ),
                hint: Text('Relationship', style: TextStyle(color: Colors.black26)),
                items: relationships.map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value));
                  },
                ).toList(),
                onChanged: (value) => setState(() => relationship = value as String),
              ),
              Container(
                width: double.infinity,
                height: 52,
                margin: EdgeInsets.symmetric(vertical: 48),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    fixedSize: Size.fromHeight(52),
                  ),
                  onPressed: _handleAddDependants,
                  child: loading
                      ? CircularProgressIndicator(value: 32, color: Colors.white)
                      : CustomText('Add Dependant', size: 17, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleAddDependants() async {
    if (_formKey.currentState!.validate() && relationship.isNotEmpty && gender.isNotEmpty) {
      setState(() => loading = true);
      AppUser user = AppUser(
        firstName: _firstName.text.trim().toSentenceCase(),
        lastName: _lastName.text.trim().toSentenceCase(),
        phoneNumber: _phone.text.trim(),
        email: _email.text.trim().toLowerCase(),
        gender: gender,
        relationship: relationship,
        houseInfo: appUser.houseInfo,
        maritalStatus: '',
      );

      final success = await controller.addDependant(AuthController.getAuthUser().uid, user);
      setState(() => loading = false);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomText("Dependant Added Successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        Future.delayed(Duration(seconds: 2), () => Get.back());
      }
    }
  }
}
