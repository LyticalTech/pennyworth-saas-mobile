import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:residents/components/text.dart';
import 'package:residents/utils/app_theme.dart';

Widget customActivityIndicator({Color? color, double? size}) {
  if (Platform.isIOS) {
    return CupertinoActivityIndicator(
      color: color ?? AppTheme.primaryColor,
      radius: size ?? 24,
    );
  } else {
    return SizedBox(
      width: size ?? 16,
      height: size ?? 16,
      child: CircularProgressIndicator(
        color: color ?? AppTheme.primaryColor,
        strokeWidth: 2,
      ),
    );
  }
}

Widget buildInfoItems(
  String title,
  String value, {
  CrossAxisAlignment? crossAxisAlignment,
  double? titleSize,
  double? valueSize,
  Color? color,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: Column(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
      children: [
        CustomText(title, color: Colors.black45, size: titleSize ?? 14),
        SizedBox(height: 4),
        CustomText(
          value,
          color: color ?? Colors.black87,
          size: valueSize ?? 18,
          fontWeight: FontWeight.w600,
        ),
      ],
    ),
  );
}

Widget bottomLabels({
  required String title,
  required String value,
  int? flex,
  double? fontSize,
}) {
  return Expanded(
    flex: flex ?? 1,
    child: Text.rich(
      TextSpan(
        text: "$title:  ",
        style: TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.black54,
          fontSize: fontSize ?? 14,
        ),
        children: [
          TextSpan(text: value, style: TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    ),
  );
}

Widget twoLabels({
  required String title,
  required String value,
  int? flex,
  double? fontSize,
  required String secondTitle,
  required String secondValue,
}) {
  return Expanded(
    flex: flex ?? 1,
    child: Text.rich(
      TextSpan(
        text: "$title:  ",
        style: TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.black54,
          fontSize: fontSize ?? 14,
        ),
        children: [
          TextSpan(text: value, style: TextStyle(fontWeight: FontWeight.w700)),
          TextSpan(
            text: "$secondTitle:  ",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black54,
              fontSize: fontSize ?? 14,
            ),
          ),
          TextSpan(text: secondValue, style: TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    ),
  );
}

Widget buildItem({required String title, required String value}) {
  return Container(
      margin: EdgeInsets.only(bottom: 16),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$title:",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.black54,
                fontSize: 17,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 18)),
          )
        ],
      ));
}

void gotoScreen({required BuildContext context, required Widget screen}) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
}

void gotoScreenAsRoute({required BuildContext context, required Widget screen, RouteSettings? settings}) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => screen, settings: settings),
  );
}

String paddedDigit(double digit) {
  if ((digit / 10).floor() == 0) {
    return digit.toString().padLeft(2, '0');
  }
  return digit.toString();
}

String formattedDouble(double value) {
  var formatter = NumberFormat("###,###,###,##0.00");
  return formatter.format(value);
}

void waitAndExec(int durationInMilli, VoidCallback callback) async {
  Future.delayed(Duration(milliseconds: durationInMilli), callback);
}

String valueOrEmpty(String? value) {
  return value ?? "";
}
