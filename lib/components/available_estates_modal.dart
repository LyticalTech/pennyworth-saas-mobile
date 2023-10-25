import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:residents/controllers/auth/auth_controller.dart';
import 'package:residents/models/other/house.dart';

// class EstatesModal extends StatelessWidget {
//   EstatesModal({Key? key}) : super(key: key);
//
//   final AuthController controller = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Available Estates'), centerTitle: true),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot<Estate>>(
//               stream: controller.fetchEstates(),
//               builder: (builderContext, snapshot) {
//                 if (snapshot.hasData) {
//                   return (snapshot.data!.docs.isNotEmpty)
//                       ? ListView.separated(
//                           itemCount: snapshot.data!.docs.length,
//                           itemBuilder: (itemContext, index) => ListTile(
//                             title: Text(snapshot.data!.docs[index].data().name ?? ""),
//                             onTap: () {
//                               final estate = snapshot.data!.docs[index].data();
//                               controller.selectedEstate.update((value) {
//                                 value?.id = estate.id;
//                                 value?.name = estate.name;
//                                 value?.address = estate.address;
//                               });
//
//                               Get.back();
//
//                             },
//                           ),
//                           separatorBuilder: (context, index) => Separator(),
//                         )
//                       : Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                           child: Column(
//                             children: [
//                               Spacer(flex: 2),
//                               Center(child: Lottie.asset("assets/lottie/house.json")),
//                               Spacer(flex: 2),
//                               CustomText(
//                                 "No estate found",
//                                 textAlign: TextAlign.center,
//                                 fontWeight: FontWeight.w300,
//                                 size: 20,
//                               ),
//                               Spacer(flex: 3),
//                             ],
//                           ),
//                         );
//                 } else if (snapshot.hasError) {
//                   return Center(child: CustomText("Error"));
//                 } else {
//                   return Center(
//                     child: customActivityIndicator(),
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class Separator extends StatelessWidget {
  const Separator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 1,
      height: 1,
      color: Colors.black26,
    );
  }
}

class HouseAddressItem extends StatelessWidget {
  HouseAddressItem({
    required this.house,
    Key? key,
  }) : super(key: key);

  final House house;

  final AuthController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        // controller.houseAddress.value = house.address ?? "";
        // controller.houseId.value = house.id ?? "";
        // controller.house.value = house;
        controller.house(house);

        log(controller.house.value.toJson().toString());

        Navigator.pop(context);
      },
      title: RichText(
        text: TextSpan(
          text: "House ID:  ",
          style: TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
          children: [
            TextSpan(
              text: house.id,
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
      subtitle: RichText(
        text: TextSpan(
          text: "Address: ",
          style: TextStyle(color: Colors.black54, fontSize: 14),
          children: [
            TextSpan(
              text: house.address,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
