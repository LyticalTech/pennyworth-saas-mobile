import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:residents/helpers/Utils.dart';
import 'package:residents/models/other/code.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../helpers/constants.dart';
import '../models/other/status.dart';
import '../utils/logger.dart';
import '../utils/network_base.dart';

class CodeServices {
  Uri lytical = Uri.parse('lyticaltechnology.com');
  final NetworkHelper _networkHelper = NetworkHelper(Endpoints.baseUrl);

  Future<void> copyCode(String code) async {
    try {
      Clipboard.setData(ClipboardData(text: code));
      Utils.showToast("Code Copied");
    } catch (e) {
      Utils.showToast("Unable to Copy Code");
    }
  }

  Future<void> shareCodeOnWhatsApp(
      {required Code code,
      required String sender,
      required String address}) async {
    final link = WhatsAppUnilink(
      text: """Hey! 
You have been invited to $address by $sender.

Your entry code is

        ${code.code}
        
This code expires ${DateFormat("EEEE dd MMMM, yyyy, @ hh:mm aaa").format(code.expires)}.
        
Thank you.

Powered by $lytical
""",
    );
    try {
      await launch('$link');
    } catch (e, s) {
      Utils.showToast("Unable to Launch WhatsApp");
    }
  }

  Future<void> shareCodeBySms(
      {required Code code,
      required String sender,
      required String address}) async {
    final String sms = """Hey! 
You have been invited to $address by $sender.

Your entry code is

        ${code.code}
        
This code expires ${DateFormat("EEEE dd MMMM, yyyy, @ hh:mm aaa").format(code.expires)}.
        
Thank you.

Powered by $lytical
""";
    try {
      await launch('sms:?body=$sms');
    } catch (e, s) {
      Utils.showToast("Unable to Launch SMS");
    }
  }

  Future<Either<Failure, dynamic>> generate(
    String email,
    String password,
  ) async {
    try {
      var response = await _networkHelper.post(
        Endpoints.generateCode,
        data: {"visitorName": "string", "durationInHours": 3},
      );

      var hasError = isBadStatusCode(response.statusCode!);
      if (hasError) {
        return Left(Failure(errorResponse: response));
      }
      logger.i(response.data);
      return Right(response.data);
    } on SocketException {
      return Left(Failure(errorResponse: "Unable to connect to the internet."));
    } on DioException catch (e) {
      return Left(Failure(errorResponse: NetworkHelper.onError(e)));
    }
  }
}
