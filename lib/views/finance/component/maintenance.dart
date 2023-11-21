import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:residents/components/text.dart';
import 'package:residents/controllers/finance/invoice_controller.dart';
import 'package:residents/models/finance/service_charge.dart';
import 'package:residents/utils/extensions.dart';
import 'package:residents/utils/helper_functions.dart';

class MaintenanceAndService extends StatefulWidget {
  @override
  State<MaintenanceAndService> createState() => _MaintenanceAndServiceState();
}

class _MaintenanceAndServiceState extends State<MaintenanceAndService> {
  final FinanceController _controller = Get.find();
  late Future<bool> servicesFuture;

  @override
  void initState() {
    super.initState();
    if (_controller.serviceCharges.isEmpty) {
      servicesFuture = _controller.getServiceCharges();
    } else {
      servicesFuture = Future.delayed(Duration(milliseconds: 500), () => true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.0),
      child: FutureBuilder(
          future: null,
          builder: (context, snapshot) {
            if (snapshot.hasData || _controller.serviceCharges.isNotEmpty) {
              return ListView.separated(
                itemCount: _controller.serviceCharges.length,
                itemBuilder: (context, index) => ListTile(
                  title: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: CustomText(
                      _controller.serviceCharges[index].item,
                      size: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    _showBottomSheet(
                        context, _controller.serviceCharges[index]);
                  },
                  minVerticalPadding: 2,
                  subtitle: Padding(
                    padding: EdgeInsets.only(left: 12.0, top: 8),
                    child: Row(
                      children: [
                        _buildBottomItem(
                            "Amount",
                            formattedDouble(
                                _controller.serviceCharges[index].amount)),
                        Spacer(flex: 1),
                        _buildBottomItem(
                            "Date",
                            DateTime.parse(
                                    _controller.serviceCharges[index].date)
                                .formattedDate()),
                        Spacer(flex: 3),
                      ],
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                ),
                separatorBuilder: (context, index) => Divider(
                  thickness: 1,
                  height: 3,
                  color: Colors.black12,
                ),
              );
            } else {
              return Center(
                child: Image.asset("assets/images/no_data.png"),
              );
            }
          }),
    );
  }

  void _showBottomSheet(BuildContext context, ServiceCharge serviceCharge) {
    Get.bottomSheet(
      Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.4,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Center(
                  child: Container(
                    width: 32,
                    height: 5,
                    margin: EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.5),
                        color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              buildItem(title: "Service", value: serviceCharge.item),
              buildItem(
                  title: "Amount",
                  value: formattedDouble(serviceCharge.amount)),
              buildItem(
                  title: "Date",
                  value: DateTime.parse(serviceCharge.date).formattedDate()),
              buildItem(title: "Remarks", value: serviceCharge.remarks ?? "-"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomItem(String title, String value) {
    return RichText(
      text: TextSpan(
        text: "$title: ",
        style: TextStyle(
            fontWeight: FontWeight.w700, fontSize: 12, color: Colors.black54),
        children: [
          TextSpan(
              text: value,
              style: TextStyle(
                  fontWeight: FontWeight.normal, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}
