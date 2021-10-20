
import 'dart:async';
import 'dart:convert';
import 'package:demo7_pro/http/http.dart';
import 'package:demo7_pro/dto/login_form.dart';

import 'package:dio/dio.dart';
import 'package:demo7_pro/config/http.dart';

const baseUrl = 'https://api.uat.chanjesign.com';

class LoginIn {
  static Future<dynamic> fetch(LoginForm data) async {
    String id= HttpConfig.instance.clients['mini'].id;
    String secret= HttpConfig.instance.clients['mini'].secret;
    String loginBase64Str = base64Encode(utf8.encode('$id:$secret'));
    final resp = await HttpUtil.instance.post('$baseUrl/oauth/login', data: {
      'username': data.mobile, // 用户名
      'smsCode': data.sms, // 短信验证码
      'grant_type': 'sms_code', // 授权方式
      'scope': 'userProfile', // 授权域
    },options:Options(
      headers:{
        'content-type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'platform': 'MINI',
        'Authorization': 'Basic $loginBase64Str',
      }
    ));
    Map respJson = {};
    if (resp['code'] == 200) {
      respJson = resp['data'] ?? {};
    }
    return {
      'loginInJson': respJson,
      'loginInResp':resp,
    };
  }
}
