import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:residents/components/expanded_button.dart';
import 'package:residents/components/filled_button.dart';
import 'package:residents/components/input_label.dart';
import 'package:residents/components/text_field.dart';
import 'package:residents/controllers/community/market_controller.dart';
import 'package:residents/helpers/constants.dart';
import 'package:residents/utils/color_picker.dart';
import 'package:residents/utils/helper_functions.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final CommerceController _controller = Get.find();

  List<XFile> _selectedImages = [];

  void pickColor(String color) {
    _controller.productColor.value = color;
  }

  void _handleAddProduct() async {
    var product = await _controller.addProduct();
    if (product == null && _controller.errorList.contains("image")) {
      _controller.errorList.clear();
      Get.snackbar("Product Image", "Please select at least one image for product.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    } else {
      setState(() {
        _selectedImages.clear();
      });
      _controller.reset();
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              _buildProductImagesContainer(),
              _buildColorPicker(),
              _buildTextFields(),
              SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: FilledButtons(
                  title: 'Add Product',
                  onPressed: _handleAddProduct,
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
          Obx(
            () => _controller.loading.value
                ? Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    bottom: 0,
                    child: Container(
                      color: Colors.black26,
                      child: Center(
                        child: customActivityIndicator(size: 32, color: Colors.white),
                      ),
                    ),
                  )
                : SizedBox(),
          )
        ],
      ),
    );
  }

  Widget _buildProductImagesContainer() {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 8),
      child: GestureDetector(
        onTap: _showBottomDialog,
        child: Obx(
          () => Container(
            height: size.height * .25,
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: colors[_controller.productColor.value],
              borderRadius: BorderRadius.circular(6),
            ),
            child: _selectedImages.isNotEmpty
                ? ListView.builder(
                    itemCount: _selectedImages.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) => SizedBox(
                      width: size.width * 0.9,
                      child: Image.file(
                        File(_selectedImages[index].path),
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                      ),
                    ),
                  )
                : Icon(
                    Icons.image_outlined,
                    size: 44,
                    color: Colors.white70,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Product Background Color",
              style: TextStyle(fontSize: 18),
            ),
          ),
          Container(
            width: 52,
            height: 52,
            margin: EdgeInsets.only(right: 12),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Obx(
              () => InkWell(
                onTap: () {
                  _showPickerDialog(context);
                },
                child: Card(
                  elevation: 4,
                  color: colors[_controller.productColor.value],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFields() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputLabel(title: "Product Name"),
          Obx(() => CustomTextArea(
                controller: _controller.nameController,
                hintText: "Enter Product Name",
                textInputAction: TextInputAction.next,
                maxLines: 1,
                hasError: _controller.errorList.contains("name"),
              )),
          InputLabel(title: "Description"),
          Obx(() => CustomTextArea(
                controller: _controller.descriptionController,
                hintText: "Enter Product Description",
                textInputAction: TextInputAction.next,
                hasError: _controller.errorList.contains("description"),
              )),
          InputLabel(title: "Amount"),
          Obx(() => CustomTextArea(
                hintText: "Product Cost",
                controller: _controller.amountController,
                textInputType: TextInputType.number,
                textInputAction: TextInputAction.done,
                maxLines: 1,
                hasError: _controller.errorList.contains("amount"),
              )),
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
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          content: SingleChildScrollView(
            child: SizedBox(
              width: size.width * 0.8,
              height: size.width * 0.75,
              child: GridView.count(
                crossAxisCount: 5,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: colors.entries
                    .map(
                      (entry) => Obx(
                        () => ColorItem(
                          color: entry.value,
                          onTap: () {
                            pickColor(entry.key);
                          },
                          isSelected: entry.key == _controller.productColor.value,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showBottomDialog() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        height: 160,
        child: Column(
          children: [
            ExpandedButton(
              title: "Camera",
              onPressed: () async {
                Get.back();
                await _controller.takeProductImageFromCamera();
                setState(() {
                  _selectedImages = _controller.productImages;
                });
              },
            ),
            Divider(
              height: 1,
              color: Colors.black38,
            ),
            ExpandedButton(
              title: "Gallery",
              onPressed: () async {
                Get.back();
                await _controller.pickProductImagesFromGallery();
                setState(() {
                  _selectedImages = _controller.productImages;
                });
              },
            ),
          ],
        ),
      ),
      elevation: 2,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
