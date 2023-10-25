import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:residents/components/item_card.dart';
import 'package:residents/components/text.dart';
import 'package:residents/controllers/community/market_controller.dart';
import 'package:residents/helpers/constants.dart';
import 'package:residents/models/community/product.dart';
import 'package:residents/utils/helper_functions.dart';
import 'package:residents/views/community/market_place/add_product/add_product.dart';
import 'package:residents/views/community/market_place/details/details_screen.dart';

class MarketPlace extends StatelessWidget {
  final CommerceController controller = Get.put(CommerceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Product>>(
        stream: controller.getProductsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.size > 0) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: GridView.builder(
                itemCount: snapshot.data!.size,
                padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: kDefaultPadding,
                  crossAxisSpacing: kDefaultPadding,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) => ItemCard(
                  product: snapshot.data!.docs[index].data(),
                  press: () => Get.to(
                    () => DetailsScreen(product: snapshot.data!.docs[index].data()),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return Column(
              children: [
                Spacer(flex: 3),
                Image.asset("assets/images/no_product.png"),
                Spacer(flex: 2),
                CustomText(
                  "Be the first to add a product.",
                  size: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                Spacer(flex: 3),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: CustomText("Error loading products"),
            );
          } else {
            return Center(child: customActivityIndicator(size: 32));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddProduct()),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
