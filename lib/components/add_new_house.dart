import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:residents/components/logo_widget.dart';
import 'package:residents/controllers/shield/house_controller.dart';
import 'package:residents/models/other/house.dart';
import 'package:residents/utils/app_theme.dart';
import 'package:residents/utils/validator.dart';
import 'package:residents/views/auth/components/auth_button.dart';
import 'package:residents/views/auth/components/auth_text_field.dart';

class AddNewHouse extends StatelessWidget {
  AddNewHouse({Key? key}) : super(key: key) {
    Get.lazyPut(() => HouseController());
  }

  final HouseController _controller = Get.find();

  final TextEditingController _houseId = TextEditingController();
  final TextEditingController _houseAddress = TextEditingController();
  final TextEditingController _reservedKey = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New House"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: const [
              Shield(),
              Flexible(
                child: Image(
                  fit: BoxFit.contain,
                  image: AssetImage("assets/images/pattern.png"),
                ),
              ),
            ],
          ),
          Center(
            child: SafeArea(
              child: SingleChildScrollView(
                dragStartBehavior: DragStartBehavior.down,
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(height: 32),
                          AuthTextField(
                            controller: _houseId,
                            textInputType: TextInputType.text,
                            hintText: 'House ID',
                            validator: Validator.textValidator,
                            icon: Icons.settings,
                          ),
                          SizedBox(height: 8),
                          AuthTextField(
                            textInputType: TextInputType.text,
                            initialValue: "Oak Estate, Lekki",
                            enable: false,
                            validator: Validator.textValidator,
                            icon: Icons.home_outlined,
                          ),
                          SizedBox(height: 8),
                          AuthTextField(
                            controller: _reservedKey,
                            textInputType: TextInputType.text,
                            hintText: 'ReservedKey',
                            validator: Validator.textValidator,
                            icon: Icons.key,
                          ),
                          SizedBox(height: 24),
                          AuthButton(
                            title: 'Submit',
                            press: () {
                              _addNewHouse(context);
                            },
                            color: AppTheme.primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addNewHouse(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // House house = House(
      //   id: _houseId.text,
      //   reservedKey: _reservedKey.text,
      //   address: _houseAddress.text,

      // );

      // await _controller.addNewHouse(house).then((documentRef) {
      //   if (documentRef != null) {
      //     Navigator.pop(context);
      //   }
      // });
    }
  }
}
