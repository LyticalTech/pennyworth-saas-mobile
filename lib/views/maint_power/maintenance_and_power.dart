import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:residents/components/text.dart';
import 'package:residents/controllers/power/power_controller.dart';
import 'package:residents/models/power/power.dart';
import 'package:residents/utils/app_theme.dart';
import 'package:residents/utils/helper_functions.dart';

class MaintenanceAndPower extends StatelessWidget {
  final PowerController controller = Get.put(PowerController());

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Maint. And Power"),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white54,
              ),
              child: TextField(
                onChanged: controller.filterSources,
                decoration: InputDecoration(
                  fillColor: Colors.red,
                  prefixIcon: Icon(Icons.search_sharp),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 6),
                ),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: controller.fetchSources(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4.0),
              child: Obx(
                () => RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: () async {
                    controller.fetchSupplies();
                  },
                  color: Colors.white,
                  backgroundColor: AppTheme.primaryColor,
                  child: ListView.separated(
                    itemCount: controller.powerSources.value.length,
                    itemBuilder: (context, index) => ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      title: Padding(
                        padding: EdgeInsets.only(left: 12.0),
                        child: CustomText(
                          controller.powerSources.value[index].name ?? "",
                          size: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(left: 12.0, top: 4.0),
                        child: _buildTileBottom(
                          controller.powerSources.value[index],
                        ),
                      ),
                    ),
                    separatorBuilder: (context, index) => Divider(
                      thickness: 1,
                      height: 3,
                      color: Colors.black12,
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "There's an error! ${snapshot.error}",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            );
          } else {
            return Center(
              child: customActivityIndicator(size: 32),
            );
          }
        },
      ),
    );
  }

  Widget _buildTileBottom(PowerSource powerSource) {
    return Row(
      children: [
        bottomLabels(
          title: "Capacity",
          value: "${powerSource.capacity}",
          flex: 2,
        ),
        bottomLabels(
          title: "Volume",
          value: "${powerSource.volume}",
          flex: 3,
        )
      ],
    );
  }
}
