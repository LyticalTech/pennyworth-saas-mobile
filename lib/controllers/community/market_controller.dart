import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:residents/controllers/auth/auth_controller.dart';
import 'package:residents/models/community/product.dart';
import 'package:residents/models/estate_office/resident.dart';
import 'package:residents/models/other/firebase_resident.dart';

class CommerceController extends GetxController {
  List<Product> favourites = <Product>[].obs;
  List<XFile> productImages = <XFile>[].obs;

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
  final productRef = collectionRef.withConverter<Product>(
    fromFirestore: (snapshot, _) => Product.fromSnapshot(snapshot),
    toFirestore: (product, _) => product.toJson(),
  );

  final AuthController authController = Get.find();
  // final resident = Resident().obs;

  CommerceController() {
    // resident(authController.resident.value);
  }

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
    XFile? image = await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      productImages = [image];
    }
  }

  Stream<QuerySnapshot<Product>> getProductsStream() {
    return productRef.snapshots();
  }

  Future<Product?> addProduct() async {
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
      return null;
    }

    loading.value = true;

    List<String> uploadedMediaUrls = await uploadMediaToStorage(productImages);

    if (uploadedMediaUrls.isNotEmpty) {
      Product product = Product(
        // seller: FirebaseResident.fromResident(.value),
        sellerId:" resident.value.id",
        images: uploadedMediaUrls,
        name: nameController.text,
        price: double.parse(amountController.text),
        description: descriptionController.text,
        color: productColor.value,
      );

      DocumentReference storedProduct = await productRef.add(product);

      loading.value = false;

      return storedProduct.get().then((snapshot) {
        return Product.fromSnapshot(snapshot);
      });
    } else {
      return null;
    }
  }

  Future<List<String>> uploadMediaToStorage(List<XFile> files) async {
    List<String> filesDownloadURLs = [];
    if (files.isNotEmpty) {
      for (var file in files) {
        String filePath = file.path;
        String fileName = file.name;

        try {
          File file = File(filePath);
          TaskSnapshot snapshot =
              await _storage.ref().child('product_images/$fileName').putFile(file);

          if (snapshot.state == TaskState.success) {
            var downloadURL = await snapshot.ref.getDownloadURL();
            filesDownloadURLs.add(downloadURL);
          }
        } on FirebaseException catch (e) {
          log("Error storing file", error: e);
        }
      }
      return filesDownloadURLs;
    }
    return [];
  }

  Future<void> toggleProduct(Product product, bool toggle) async {
    productRef.doc(product.id).get().then((doc) {
      if (doc.exists) {
        doc.reference.update({"out_of_stock": toggle});
      }
    }).catchError((e) {
      log(e.toString());
    });
  }

  void reset() {
    productImages.clear();
    productColor.value = 'default';
    nameController.text = "";
    descriptionController.text = "";
    amountController.text = "";
  }
}
