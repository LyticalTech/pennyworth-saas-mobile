import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:residents/controllers/community/market_controller.dart';
import 'package:residents/helpers/constants.dart';
import 'package:residents/models/community/product.dart';
import 'package:residents/views/community/market_place/details/components/body.dart';

class DetailsScreen extends StatelessWidget {
  final Product product;
  final CommerceController _controller = Get.put(CommerceController());

  DetailsScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors[product.color!],
      appBar: buildAppBar(context),
      body: Body(product: product),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: colors[product.color!],
      elevation: 0,
      title: Text(product.name),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      actions: [
        Obx(
          () => IconButton(
            onPressed: () => _controller.toggleAddProduct(product),
            icon: Icon(
              _controller.isFavourite(product) ? Icons.favorite_rounded : Icons.favorite_border,
              color: _controller.isFavourite(product) ? Colors.red : Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
