import 'package:demo7_pro/model/home_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:demo7_pro/http/http.dart';
import 'package:dio/dio.dart' show FormData,Options;

const baseUrl = 'https://api.uat.chanjesign.com/api/v1/common/file/oss';

class FileUpload {
  static Future<dynamic> upload(FormData data) async {
    final resp = await HttpUtil.instance.post(baseUrl, data: data,options:Options(
        headers:{
          'content-type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
          'platform': 'MINI',
        }
    ));

    return resp['data']??'';
  }
}
