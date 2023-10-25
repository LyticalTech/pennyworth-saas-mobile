import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF00BF6D);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarningColor = Color(0xFFF3BB1C);
const kLightGreyColor = Color(0xFFC4C4C4);
const kInfoBGColor = Color(0xFFF4F7F8);
const kErrorColor = Color(0xFFF03738);

const kTextColor = Color(0xFF535353);
const kTextLightColor = Color(0xFFACACAC);

const animationDuration = Duration(microseconds: 200);

const kDefaultPadding = 20.0;

const Map<String, Color> colors = {
  "red": Colors.red,
  "pink": Colors.pink,
  "purple": Colors.purple,
  "deepPurple": Colors.deepPurple,
  "indigo": Colors.indigo,
  "blue": Colors.blue,
  "lightBlue": Colors.lightBlue,
  "cyan": Colors.cyan,
  "teal": Colors.teal,
  "green": Colors.green,
  "lightGreen": Colors.lightGreen,
  "lime": Colors.lime,
  "yellow": Colors.yellow,
  "amber": Colors.amber,
  "orange": Colors.orange,
  "deepOrange": Colors.deepOrange,
  "brown": Colors.brown,
  "grey": Colors.grey,
  "blueGrey": Colors.blueGrey,
  "black": Colors.black,
  "default": Colors.grey
};

class Endpoints {
  static const baseUrl = "https://lyticalfamanapp.azurewebsites.net/";
  static const getOtp = "api/SignIn/getOtp";
  static const getResident = "api/SignIn/getResident";
  static const invoice = "api/Finance/invoice/";
  static const invoicePayment = "api/Finance/payment";
  static const powerSource = "api/Power/estate-source";
  static const powerSupply = "api/Power/estate-supply";
  static const attendance = "api/Admin/attendance";
  static const serviceCharge = "api/Finance/service-charge";
  static const getResidentInfo = "api/Admin/resident/";
  static const complaint = "api/Communication/complaint";
  static const facilities = "api/Facility/estate-assets";
  static const bookFacility = "api/Facility/book";
  static const checkBookingAvailability = "api/Facility/book-validity";
  static const bookedFacility = "api/Facility/booked/items/";
  static const facilityPayment = "api/Facility/payment";
  static const requestLinkResend = "api/Admin/refreshActivationLink/";
  static const sendPanicMessage =
      "https://us-central1-middle-chase.cloudfunctions"
      ".net/sendPanicToEstateResident";
}
