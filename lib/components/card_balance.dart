import 'package:flutter/material.dart';
import 'package:residents/utils/helper_functions.dart';

class CardBalance extends StatelessWidget {
  const CardBalance({
    Key? key, required this.title, required this.amount,
  }) : super(key: key);

  final String title;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(color: Colors.white, fontSize: 15),),
            SizedBox(height: 4),
            Text(
              formattedDouble(amount),
              style: TextStyle(
                  color: Colors.white, fontSize: 24,
                  fontWeight: FontWeight.w600
              ),
            ),
          ],
        )
    );
  }
}