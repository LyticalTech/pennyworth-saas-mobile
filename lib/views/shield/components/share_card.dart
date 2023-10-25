import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residents/components/share_icon.dart';
import 'package:residents/controllers/auth/app_user_controller.dart';
import 'package:residents/controllers/shield/house_controller.dart';
import 'package:residents/models/other/code.dart';
import 'package:residents/services/code_services.dart';

class ShareCard extends StatelessWidget {
  ShareCard({required this.code, Key? key}) : super(key: key);

  final Code code;

  final CodeServices _codeServices = CodeServices();

  final String _address = HouseController.house.address!;

  final String _username = "${AppUserController.appUser?.firstName} ${AppUserController.appUser?.firstName}";

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              child: Text(
                'Share code with guest',
                style: GoogleFonts.lato(
                  textStyle: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 16), // Omotayo Added this for spacing
            FittedBox(
              child: Text(
                code.code,
                style: GoogleFonts.lato(
                  textStyle: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 10),
                ),
              ),
            ),
            SizedBox(height: 16), // Omotayo Added this for spacing
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ShareIcon(
                  iconSrc: "assets/icons/whatsapp.svg",
                  press: () => _codeServices.shareCodeOnWhatsApp(code: code, sender: _username, address: _address),
                ),
                // COMMENTED THIS OUT AS REQUESTED BY MR JOHN UNTIL SHARE
                // BY SMS IS IMPLEMENTED.
                // ShareIcon(
                //   iconSrc: "assets/icons/textsms.svg",
                //   press: () => _codeServices.shareCodeBySms(
                //       code: code, sender: _username, address: _address),
                // ),
                ShareIcon(
                  iconSrc: "assets/icons/content_copy.svg",
                  press: () => _codeServices.copyCode(code.code),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
