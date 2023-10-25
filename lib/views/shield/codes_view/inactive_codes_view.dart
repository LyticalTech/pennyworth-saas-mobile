import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residents/controllers/shield/code_controller.dart';
import 'package:residents/models/other/code.dart';
import 'package:shimmer/shimmer.dart';

class InactiveCodes extends GetResponsiveView<CodeController> {
  InactiveCodes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Code>>(
        stream: controller.inactiveCodes,
        builder: (context, AsyncSnapshot<List<Code>> snapshot) {
          if (snapshot.hasData) {
            if(snapshot.data!.isEmpty){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.hourglass_empty,
                      size: Get.height * 0.3,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
                      child: Text(
                        'Sorry! there are no codes',
                        style: GoogleFonts.aclonica(
                          fontSize: Get.height * 0.05,
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
            return CustomScrollView(
              shrinkWrap: true,
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final code = snapshot.data![index];
                      return ListTile(
                        leading: Container(
                          color: Colors.orange,
                          height: 60.0,
                          width: 60.0,
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.oswald(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          code.code,
                          style: GoogleFonts.lato(
                            letterSpacing: 3,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${code.status.capitalizeFirst}',
                          style: GoogleFonts.dancingScript(
                            fontSize: 16,
                          ),
                        ),
                      );
                    },
                    childCount: snapshot.data!.length,
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error),
                  Text(
                    'An "Error" has occurred please try again later',
                    style: GoogleFonts.aclonica(),
                  )
                ],
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return CustomScrollView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return ListTile(
                        leading: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 60.0,
                            width: 60.0,
                            color: Colors.grey[300],
                          ),
                        ),
                        title: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                              height: 16.0, color: Colors.grey[300]),
                        ),
                        subtitle: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                              height: 16.0, color: Colors.grey[300]),
                        ),
                        trailing: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 30.0,
                            width: 57.0,
                            color: Colors.grey[300],
                          ),
                        ),
                      );
                    },
                    childCount: 10,
                  ),
                ),
              ],
            );
          } else if (snapshot.data!.isEmpty){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.hourglass_empty),
                  Text(
                    'Sorry! there are no codes',
                    style: GoogleFonts.aclonica(
                        color: Colors.red
                    ),
                  )
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.hourglass_empty),
                  Text(
                    'Sorry! there are no codes',
                    style: GoogleFonts.aclonica(
                        color: Colors.red
                    ),
                  )
                ],
              ),
            );
          }
        });
  }
}
