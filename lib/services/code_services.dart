import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:residents/helpers/Utils.dart';
import 'package:residents/models/other/code.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class CodeServices {

  Uri lytical = Uri.parse('lyticaltechnology.com');

  Future<void> copyCode(String code) async {
    try {
      Clipboard.setData(ClipboardData(text: code));
      Utils.showToast("Code Copied");
    } catch (e) {
      Utils.showToast("Unable to Copy Code");
    }
  }

  Future<void> shareCodeOnWhatsApp({required Code code, required String sender, required String address}) async {
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

  Future<void> shareCodeBySms({required Code code, required String sender, required String address}) async {
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
}