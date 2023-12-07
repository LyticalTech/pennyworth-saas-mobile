import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:residents/controllers/auth/auth_controller.dart';
import 'package:residents/services/auth_services.dart';
import 'package:residents/services/preference_service.dart';
import 'package:residents/views/auth/sign_in_screen.dart';

class ApiService {
  static final AuthController authController = Get.find();

  static Future<Map<String, dynamic>> postRequest(
      String endpoint, Map<String, dynamic> body) async {
    Map<String, String> headerData = await _getHeaderData();
    var result;
    try {
      http.Response response = await http.post(
        Uri.parse(endpoint),
        body: jsonEncode(body),
        headers: headerData,
      );

      if (response.statusCode >= 200 || response.statusCode <= 299) {
        result = {'status': true, 'response': response.body, 'error': false};
      }
    } on SocketException catch (e) {
      result = {'status': false, 'error': true, 'message': e.message};
    } catch (e) {
      result = {'status': false, 'error': true, 'message': e.toString()};
    }

    return result;
  }

  static Future<Map<String, dynamic>> getRequest(
    String endpoint, {
    Map<String, String> param = const {},
  }) async {
    Map<String, String> headerData = await _getHeaderData();
    String url = endpoint;

    List<String> stringParam = [];
    if (param.isNotEmpty) {
      param.forEach((key, value) => stringParam.add("$key=$value"));
      url += "?${stringParam.join("&")}";
    }

    log(url);

    try {
      http.Response response =
          await http.get(Uri.parse(url), headers: headerData);

      if (response.statusCode == 200) {
        return {'status': true, 'response': response.body, 'error': false};
      } else if (response.statusCode == 401) {
        await authController.signOut();
        Get.offAll(() => SignIn());
        return {
          'status': false,
          'error': true,
          'message': "Token expired! Please sign in."
        };
      } else {
        return {
          'status': false,
          'error': true,
          'message': response.statusCode.toString()
        };
      }
    } on SocketException catch (e) {
      return {'status': false, 'error': true, 'message': e.message};
    } catch (e) {
      return {'status': false, 'error': true, 'message': e.toString()};
    }
  }

  static Future<Map<String, String>> _getHeaderData() async {
    final preference = AppPreferences();
    await preference.initialize();
    final accessToken = AuthServices().token;
    Map<String, String> headerData = {'Content-Type': 'application/json'};
    if (accessToken.isNotEmpty) {
      headerData["Authorization"] = "Bearer $accessToken";
    }
    return headerData;
  }
}
