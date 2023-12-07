import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:residents/controllers/community/market_controller.dart';
import 'package:residents/helpers/constants.dart';
import 'package:residents/models/community/product.dart';
import 'package:residents/utils/helper_functions.dart';
import 'package:residents/utils/shimmer_item.dart';

class ItemCard extends StatelessWidget {
  final Product product;
  final VoidCallback press;

  final CommerceController _controller = Get.put(CommerceController());

  ItemCard({
    required this.product,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            onTap: press,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Hero(
                tag: product.id,
                child: CachedNetworkImage(
                  imageUrl: product.imagesPaths.first,
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, _, progress) {
                    return ShimmerItem(height: double.infinity, width: double.infinity);
                  },
                  errorWidget: (context, _, trace) {
                    return Container(
                      color: kLightGreyColor.withOpacity(0.4),
                      child: Icon(Icons.error_sharp, color: kLightGreyColor),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: TextStyle(color: kTextLightColor),
              ),
              SizedBox(
                height: 28,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "N${formattedDouble(product.price.toDouble())}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Obx(
                      () => GestureDetector(
                        onTap: () {
                          _controller.toggleAddProduct(product);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          child: Icon(
                            _controller.isFavourite(product)
                                ? Icons.favorite_rounded
                                : Icons.favorite_border,
                            size: 20,
                            color: _controller.isFavourite(product) ? Colors.red : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
