import 'package:demo7_pro/model/home_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
const baseUrl = 'https://www.devio.org/io/flutter_app/json/home_page.json';
class HomeDao{
  static Future<dynamic> fetch() async{
      final uri =  Uri.parse(baseUrl);
      print(uri);
      final resp = await http.get(uri);
      if(resp.statusCode==200){
        Utf8Decoder utf8decoder = Utf8Decoder();
        var result = json.decode(utf8decoder.convert(resp.bodyBytes));
        // print('查看返回值$result');
        return {
          'HomeModel':HomeModel.fromJson(result),
          'resultStrJson':result
        };
      } else {
        throw Exception('请求失败');
      }


  }
}