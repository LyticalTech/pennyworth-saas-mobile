import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:residents/components/text.dart';
import 'package:residents/controllers/auth/auth_controller.dart';
import 'package:residents/models/other/house.dart';
import 'package:residents/utils/helper_functions.dart';

class EstateHousesModal extends StatelessWidget {
  EstateHousesModal({Key? key, required this.estateId}) : super(key: key);

  final String estateId;

  final AuthController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Available Houses'), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<House>>(
              stream: controller.fetchHouseAddresses(estateId),
              builder: (builderContext, snapshot) {
                if (snapshot.hasData) {
                  return (snapshot.data!.docs.isNotEmpty)
                      ? ListView.separated(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (itemContext, index) => HouseAddressItem(
                            houseItem: snapshot.data!.docs[index].data(),
                          ),
                          separatorBuilder: (context, index) => Separator(),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              Spacer(flex: 2),
                              Center(child: Lottie.asset("assets/lottie/house.json")),
                              Spacer(flex: 2),
                              CustomText(
                                "Please add your assigned house address",
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w300,
                                size: 20,
                              ),
                              Spacer(flex: 3),
                            ],
                          ),
                        );
                } else if (snapshot.hasError) {
                  return Center(child: CustomText("Error"));
                } else {
                  return Center(child: customActivityIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Separator extends StatelessWidget {
  const Separator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(thickness: 1, height: 1, color: Colors.black26);
  }
}

class HouseAddressItem extends StatelessWidget {
  HouseAddressItem({required this.houseItem, Key? key}) : super(key: key);

  final House houseItem;

  final AuthController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        controller.house.update((value) {
          value?.id = houseItem.id;
          value?.estateId = houseItem.estateId;
          value?.address = houseItem.address;
          value?.houseType = houseItem.houseType;
          value?.estate = houseItem.estate;
        });
        Navigator.pop(context);
      },
      title: RichText(
        text: TextSpan(
          text: "House ID:  ",
          style: TextStyle(color: Colors.black54, fontSize: 14),
          children: [
            TextSpan(text: houseItem.id, style: TextStyle(color: Colors.black, fontSize: 17)),
          ],
        ),
      ),
      subtitle: RichText(
        text: TextSpan(
          text: "Address: ",
          style: TextStyle(color: Colors.black54, fontSize: 14),
          children: [
            TextSpan(text: houseItem.address, style: TextStyle(color: Colors.black)),
            TextSpan(text: "\nHouse Type: "),
            TextSpan(text: "${houseItem.houseType?.title}", style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
