import 'package:demo7_pro/model/travel_tab_model.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';

import 'package:dio/adapter.dart';

const baseUrl = 'http://www.devio.org/io/flutter_app/json/travel_page.json';



class TravelTabDao{
  static Future<dynamic> fetch() async{
      final uri =  Uri.parse(baseUrl);
      print(uri);

      var dio = new Dio();

      // 设置代理用来调试应用
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
        client.findProxy = (Uri) {
        // 用1个开关设置是否开启代理
        return 'PROXY 192.168.201.94:8888';
      };

    };

      // final resp = await http.get(uri);
      final resp = await dio.get(baseUrl);

      // if(resp.statusCode==200){
      //   Utf8Decoder utf8decoder = Utf8Decoder();
      //   var result = json.decode(utf8decoder.convert(resp.data));
      //   print('返回值2222$result');
      //   return {
      //     'TravelTabModel':TravelTabModel.fromJson(result),
      //     'resultStrJson':result
      //   };
      // } else {
      //   throw Exception('请求失败');
      // }

      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(resp.toString());
      return {
        'TravelTabModel':TravelTabModel.fromJson(result),
        'resultStrJson':result
      };


  }
}