import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:residents/controllers/community/market_controller.dart';

class ColorItem extends StatelessWidget {

  final Color color;
  final VoidCallback onTap;
  final bool? isSelected;

  ColorItem({required this.color, required this.onTap, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GetBuilder<CommerceController>(
        builder: (context) {
          return Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle
            ),
            child: isSelected == true
                ? Icon(Icons.check_sharp, size: 24, color: Colors.white,)
                : null,
          );
        }
      ),
    );
  }

}