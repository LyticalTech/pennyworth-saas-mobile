import 'package:flutter/material.dart';
import 'package:residents/views/community/market_place/add_product/component/body.dart';

class AddProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
      ),
      body: Body(),
    );
  }
}