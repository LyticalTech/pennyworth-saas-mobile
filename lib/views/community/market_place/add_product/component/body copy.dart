import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:residents/controllers/community/market_controller.dart';
import 'package:residents/helpers/constants.dart';
import 'package:residents/utils/color_picker.dart';

class Body extends StatelessWidget {

  final CommerceController _controller = Get.find();

  void pickColor(String color) {
    _controller.productColor.value = color;
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 4),
      child: Column(
        children: [
          GestureDetector(
            onTap: _showBottomDialog,
            child: GetBuilder<CommerceController>(
              builder: (controller) {
                return Container(
                    height: size.height * .3,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(6)
                    ),
                    child: controller.productImages.isNotEmpty
                        ? ListView.builder(
                              itemCount: controller.productImages.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) => Image.file(
                                  File(_controller.productImages[index].path)
                              ),
                        )
                        : Icon(Icons.image_outlined, size: 44, color: Colors.white70,)
                );
              }
            ),
          ),
          TextButton(
            onPressed: () { _showPickerDialog(context); },
            child: Text("Show Picker")
          )
        ],
      ),
    );
  }

  void _showPickerDialog(BuildContext context) {

    var size = MediaQuery.of(context).size;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24)
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                    width: size.width * 0.8,
                    height: size.width * 0.6,
                    child: GridView.count(
                      crossAxisCount: 5,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      children: colors.entries.map((entry) => Obx(
                              () => ColorItem(
                            color: entry.value,
                            onTap: (){ pickColor(entry.key); },
                            isSelected: entry.key == _controller.productColor.value,
                          )
                      )
                      ).toList(),
                    )
                ),
              )
          );
        }
    );
  }

  void _showBottomDialog() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12)
          )
        ),
        height: 160,
        child: Column(
          children: [
            ExpandedButton(
              title: "Camera",
              onPressed: () {
                _controller.takeProductImageFromCamera();
                Get.back();
              },
            ),
            Divider(height: 1, color: Colors.black38,),
            ExpandedButton(
              title: "Gallery",
              onPressed: () {
                _controller.pickProductImagesFromGallery();
                Get.back();
              },
            )
          ],
        ),
      ),
      elevation: 2
    );
  }
}

class ExpandedButton extends StatelessWidget {
  const ExpandedButton({
    Key? key, required this.title, required this.onPressed,
  }) : super(key: key);

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: onPressed,
            child: Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black),),
          ),
        )
    );
  }
}