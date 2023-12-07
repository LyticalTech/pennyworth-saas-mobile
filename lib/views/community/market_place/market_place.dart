import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:residents/components/item_card.dart';
import 'package:residents/components/text.dart';
import 'package:residents/controllers/community/market_controller.dart';
import 'package:residents/helpers/constants.dart';
import 'package:residents/views/community/market_place/add_product/add_product.dart';
import 'package:residents/views/community/market_place/details/details_screen.dart';

class MarketPlace extends StatelessWidget {
  final CommerceController controller = Get.put(CommerceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddProduct()),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: controller.isLoadingProduct.value
          ? Center(child: CircularProgressIndicator())
          : (controller.products.isEmpty
              ? Column(
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
                )
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: GridView.builder(
                    itemCount: controller.products.length,
                    padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: kDefaultPadding,
                      crossAxisSpacing: kDefaultPadding,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (context, index) => ItemCard(
                      product: controller.products[index],
                      press: () => Get.to(
                        () =>
                            DetailsScreen(product: controller.products[index]),
                      ),
                    ),
                  ),
                )),
    );
  }
}
