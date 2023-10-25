import 'package:flutter/material.dart';
import 'package:residents/helpers/constants.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerItem extends StatelessWidget {
  const ShimmerItem({
    Key? key,
    required this.height,
    required this.width,
    this.shape,
  }) : super(key: key);

  final double height;
  final double width;
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: kLightGreyColor.withOpacity(0.3),
      highlightColor: kInfoBGColor.withOpacity(0.3),
      child: Container(
        height: height,
        width: width,
        decoration: ShapeDecoration(
          color: kLightGreyColor,
          shape: shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }
}