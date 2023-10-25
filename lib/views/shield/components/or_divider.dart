import 'package:flutter/material.dart';
import 'package:residents/utils/app_theme.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.8,
      child: Row(
        children: <Widget>[
          buildDivider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "OR",
              style: TextStyle(
                color: Colors.deepOrange,
                fontWeight: FontWeight.w900,
                fontFamily: 'DancingScript',
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          buildDivider(),
        ],
      ),
    );
  }

  Expanded buildDivider() {
    return const Expanded(
      child: Divider(
        color: AppTheme.secondaryLightColor,
        height: 1.5,
      ),
    );
  }
}
