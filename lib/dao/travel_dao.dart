import 'package:demo7_pro/model/travel_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

import 'package:dio/adapter.dart';

var Params = {
  "districtId": -1,
  "groupChannelCode": "RX-OMF",
  "type": null,
  "lat": -180,
  "lon": -180,
  "locatedDistrictId": 0,
  "pagePara": {
    "pageIndex": 1,
    "pageSize": 10,
    "sortType": 9,
    "sortDirection": 0
  },
  "imageCutType": 1,
  "head": {'cid': "09031014111431397988"},
  "contentType": "json"
};

class TravelDao{
  static Future<dynamic> fetch(String url,String groupChannelCode,int pageIndex, int pageSize) async{
    final uri =  Uri.parse(url);
    print(url);

    Map paramsMap = Params['pagePara'];
    paramsMap['pageIndex'] = pageIndex;
    paramsMap['pageSize'] = pageSize;
    Params['groupChannelCode'] = groupChannelCode;



    // print(jsonEncode(Params) is String);


    var dio = new Dio();

    // 设置代理用来调试应用
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.findProxy = (Uri) {
        // 用1个开关设置是否开启代理
        return 'PROXY 192.168.201.94:1080';
      };

    };

    final resp = await dio.post(url,data:json.encode(Params));
    print('返回值1111${resp.statusCode}');
    print('返回值1111${resp.statusMessage}');


    // final resp = await http.post(uri,body: json.encode(Params),headers: {
    //   'content-type':'application/json'
    // });
    if(resp.statusCode==200){
      // Utf8Decoder utf8decoder = Utf8Decoder();
      // var result = json.decode(utf8decoder.convert(resp.bodyBytes));
      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(resp.toString());
      return {
        'TravelItemModel':TravelItemModel.fromJson(result),
        'resultStrJson':result
      };
    } else {

      throw Exception('请求失败${resp.statusMessage}');
    }


  }
}