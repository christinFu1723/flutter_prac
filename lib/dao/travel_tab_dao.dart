import 'package:demo7_pro/model/travel_tab_model.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
const baseUrl = 'http://www.devio.org/io/flutter_app/json/travel_page.json';
class TravelTabDao{
  static Future<dynamic> fetch() async{
      final uri =  Uri.parse(baseUrl);
      print(uri);
      final resp = await http.get(uri);
      if(resp.statusCode==200){
        Utf8Decoder utf8decoder = Utf8Decoder();
        var result = json.decode(utf8decoder.convert(resp.bodyBytes));

        return {
          'TravelTabModel':TravelTabModel.fromJson(result),
          'resultStrJson':result
        };
      } else {
        throw Exception('请求失败');
      }


  }
}