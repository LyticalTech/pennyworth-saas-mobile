import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:residents/helpers/constants.dart';
import 'package:residents/models/community/product.dart';

import 'product_actions.dart';
import 'product_info_header.dart';
import 'description.dart';

class Body extends StatefulWidget {
  Body({required this.product});

  final Product product;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late var _currentImage;

  @override
  void initState() {
    super.initState();
    _currentImage = widget.product.imagesPaths.first;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height,
            child: Stack(
              children: [
                Container(
                  color: Colors.white12,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    width: double.infinity,
                    height: size.height * 0.37,
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            itemCount: widget.product.imagesPaths.length,
                            itemBuilder: (context, index) => CachedNetworkImage(
                              imageUrl: widget.product.imagesPaths[index],
                              fit: BoxFit.cover,
                            ),
                            onPageChanged: (value) {
                              setState(
                                () {
                                  _currentImage = value;
                                },
                              );
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 8,
                            bottom: kDefaultPadding * 1.5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              widget.product.imagesPaths.length,
                              (index) => _buildDot(index: index),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.35),
                  padding: EdgeInsets.only(
                    top: size.height * 0.03,
                    left: kDefaultPadding,
                    right: kDefaultPadding,
                  ),
                  // height: 500,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      ProductInfoHeader(product: widget.product),
                      Description(product: widget.product),
                      SizedBox(height: kDefaultPadding),
                      ProductActions(product: widget.product)
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  AnimatedContainer _buildDot({required int index}) {
    return AnimatedContainer(
      duration: animationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: _currentImage == index ? 20 : 6,
      decoration: BoxDecoration(
          color: _currentImage == index ? kSecondaryColor : Color(0xFFD8D8D8),
          borderRadius: BorderRadius.circular(3)),
    );
  }
}
