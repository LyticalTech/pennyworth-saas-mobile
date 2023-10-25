import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:residents/components/text.dart';
import 'package:residents/utils/helper_functions.dart';

class FacilityCard extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback? onTap;
  final double? numberAvailable;
  final String? description;
  final double rate;
  final double? total;
  final String? availability;
  final bool availabilityStatus;
  final int? capacity;

  FacilityCard({
    required this.title,
    required this.image,
    required this.rate,
    this.availability,
    this.description,
    this.onTap,
    this.numberAvailable,
    this.total,
    this.availabilityStatus = true,
    this.capacity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 100,
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 8.0),
          // padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(image, width: 100, fit: BoxFit.contain),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Spacer(),
                      CustomText(
                        title,
                        size: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 4),
                      Text(
                        description ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      twoLabels(
                        title: "Rate",
                        value: "₦${paddedDigit(rate)}/hr",
                        secondTitle: '  Capacity',
                        secondValue: "${capacity ?? ''}",
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
