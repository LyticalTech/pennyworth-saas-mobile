import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class ShareIcon extends StatelessWidget {
  final String iconSrc;
  final VoidCallback press;
  const ShareIcon({
    Key? key,
    required this.iconSrc,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.orange,
          ),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          iconSrc,
          height: 20,
          width: 20,
          color: Colors.orangeAccent,
        ),
      ),
    );
  }
}
