import 'package:demo7_pro/model/home_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:demo7_pro/http/http.dart';

const baseUrl = 'https://api.uat.chanjesign.com';

class SMSRequest {
  static Future<dynamic> fetch(mobile) async {
    final resp = await HttpUtil.instance
        .get('$baseUrl/api/common/v1/sms', queryParameters: {'mobile': mobile});
    Map respJson = {};
    if (resp['code'] == '200') {
      respJson = resp['data'] ?? {};
    }
    return {'smsRespJson': respJson};
  }
}
