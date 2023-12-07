import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';

import 'package:image_picker/image_picker.dart';
import 'package:residents/controllers/auth/auth_controller.dart';
import 'package:residents/helpers/constants.dart';
import 'package:residents/helpers/snackbar.dart';
import 'package:residents/models/community/product.dart';
import 'package:residents/utils/logger.dart';
import 'package:residents/utils/network_base.dart';

class CommerceController extends GetxController {
  @override
  onInit() async {
    await init();
    super.onInit();
  }

  List<Product> favourites = <Product>[].obs;
  List<XFile> productImages = <XFile>[].obs;
  final NetworkHelper _networkHelper = NetworkHelper(Endpoints.baseUrl);
  List<Product> products = <Product>[].obs;
  var isLoadingProduct = true.obs;
  var isLoadingProductAvailability = false.obs;
  final errorList = <String>[].obs;
  final loading = false.obs;
  final ImagePicker picker = ImagePicker();

  final productColor = 'default'.obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static final CollectionReference collectionRef = _db.collection("products");
  static final CollectionReference userCollectionRef = _db.collection("users");

  final isCommunityMessage = false.obs;
  // final productRef = collectionRef.withConverter<Product>(
  //   fromFirestore: (snapshot, _) => Product.fromSnapshot(snapshot),
  //   toFirestore: (product, _) => product.toJson(),
  // );

  final AuthController authController = Get.find();
  // final resident = Resident().obs;

  void toggleAddProduct(Product product) {
    if (favourites.contains(product)) {
      favourites.remove(product);
    } else {
      favourites.add(product);
    }
  }

  bool isFavourite(Product product) {
    return favourites.contains(product);
  }

  Future<void> pickProductImagesFromGallery() async {
    productImages = await picker.pickMultiImage(imageQuality: 50);
  }

  Future<void> takeProductImageFromCamera() async {
    XFile? image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      productImages = [image];
    }
  }

  getProducts() async {
    isLoadingProduct.value = true;
    try {
      var response = await _networkHelper.get(Endpoints.getProduct,
          queryParameters: {"PageNumber": 1, "PageSize": 600});

      var hasError = isBadStatusCode(response.statusCode!);
      if (hasError) {
        redSnackBar('An error occurred fetching products');
      }
      logger.i(response.data);
      //  List<Map<String, dynamic>> jsonList = json.decode(jsonResponse);
      products =
          response.data.map<Product>((json) => Product.fromJson(json)).toList();
      isLoadingProduct.value = false;
    } on SocketException {
      return [];
    } on DioException catch (e) {
      redSnackBar(NetworkHelper.onError(e));
    }
  }

  addProduct() async {
    if (productImages.isEmpty) {
      errorList.add("image");
    }
    if (nameController.text.isEmpty) {
      errorList.add("name");
    }
    if (descriptionController.text.isEmpty) {
      errorList.add("description");
    }
    if (amountController.text.isEmpty) {
      errorList.add("amount");
    }
    if (errorList.isNotEmpty) {
      log(errorList.toString());
      return null;
    }

    loading.value = true;
    List<MultipartFile> imageFiles = [];

    for (XFile xFile in productImages) {
      logger.i(xFile);
      String fileName = xFile.name;
      imageFiles.add(
        await MultipartFile.fromFile(xFile.path, filename: fileName),
      );
    }
    logger.i(imageFiles);
    FormData formData = FormData.fromMap({
      'ProductName': nameController.text,
      'ProductDescription': descriptionController.text,
      'Price': amountController.text,
      'Images': imageFiles,
      'Color': productColor.value,
      'UserId': authController.resident.value.id
    });

    log(formData.toString());

    var response = await _networkHelper.uploadFile(
      Endpoints.createProduct,
      data: formData,
    );
    if (response.statusCode == 204) return true;
    return false;

    // if (uploadedMediaUrls.isNotEmpty) {
    //   Product product = Product(
    //     // seller: FirebaseResident.fromResident(.value),
    //     sellerId:" resident.value.id",
    //     images: uploadedMediaUrls,
    //     name: nameController.text,
    //     price: double.parse(amountController.text),
    //     description: descriptionController.text,
    //     color: productColor.value,
    //   );

    //   DocumentReference storedProduct = await productRef.add(product);

    //   loading.value = false;

    //   return storedProduct.get().then((snapshot) {
    //     return Product.fromSnapshot(snapshot);
    //   });
    // } else {
    // return null;
    // }
  }

  Future<void> toggleProduct(Product product, bool toggle) async {
    isLoadingProductAvailability.value = true;
    try {
      var response =
          await _networkHelper.post(Endpoints.productAvailability, data: {
        "productId": product.id,
        "isProductAvailable": toggle,
      });
      logger.i(response.data);
      logger.i(response.statusCode);
    } catch (e) {
      isLoadingProductAvailability.value = false;
      redSnackBar('error updating availability');
    }
    isLoadingProductAvailability.value = false;
  }

  void reset() {
    productImages.clear();
    productColor.value = 'default';
    nameController.text = "";
    descriptionController.text = "";
    amountController.text = "";
  }

  Future init() async {
    await getProducts();
  }
}
