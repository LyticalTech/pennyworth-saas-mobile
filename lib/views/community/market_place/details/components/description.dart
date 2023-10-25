import 'package:flutter/material.dart';
import 'package:residents/helpers/constants.dart';
import 'package:residents/models/community/product.dart';

class Description extends StatelessWidget {
  const Description({
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: Text(
        product.description ?? "No description",
        style: TextStyle(height: 1.5),
      ),
    );
  }
}
