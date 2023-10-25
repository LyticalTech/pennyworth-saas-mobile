import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {

  final String text;
  final double? size;
  final FontWeight? fontWeight;
  final Color? color;
  final double? height;
  final TextAlign? textAlign;
  final int? maxLine;

  CustomText(this.text, {this.size, this.maxLine, this.fontWeight, this.color, this.height, this
      .textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      softWrap: true,
      textAlign: textAlign,
      maxLines: maxLine,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
        height: height,
      ),
    );
  }
}