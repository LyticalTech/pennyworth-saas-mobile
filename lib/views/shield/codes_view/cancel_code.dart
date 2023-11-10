import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residents/controllers/shield/code_controller.dart';
import 'package:residents/models/other/code.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:shimmer/shimmer.dart';

class CancelCodeView extends GetResponsiveView {
  CancelCodeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CodeController controller = Get.put(CodeController());
    return Material(
      child: Obx(
        () {
          controller.loadingActiveCodes.value ||
              controller.loadingActiveCodes.value;
          return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                if (controller.isCancelingCode.value ||
                    controller.loadingActiveCodes.value) {
                  return Obx(() => controller.isCancelingCode.value ||
                          controller.loadingActiveCodes.value
                      ? CustomScrollView(
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
                                          height: 16.0,
                                          color: Colors.grey[300]),
                                    ),
                                    subtitle: Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                          height: 16.0,
                                          color: Colors.grey[300]),
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
                        )
                      : SizedBox.shrink());
                }
                {
                  if (controller.activeCodes.value.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.hourglass_empty),
                          Text(
                            'Sorry! there are no active codes',
                            style: GoogleFonts.aclonica(color: Colors.red),
                          )
                        ],
                      ),
                    );
                  }
                }

                return SizedBox(
                  height: Get.height,
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final code = controller.activeCodes.value[index];
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
                                //fit: BoxFit.cover,
                              ),
                              title: Text(
                                code.code,
                                style: GoogleFonts.lato(
                                  letterSpacing: 3,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Created ${timeago.format(code.createdAt)}',
                                style: GoogleFonts.dancingScript(
                                  fontSize: 16,
                                ),
                              ),
                              trailing: SizedBox(
                                height: 30,
                                width: 57,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () =>
                                      controller.cancelCode(code.codeId),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: controller.activeCodes.value.length,
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
