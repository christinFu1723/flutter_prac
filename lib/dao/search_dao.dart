import 'package:demo7_pro/model/search_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl='https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=';
class SearchDao{
  static Future<dynamic> fetch({url=baseUrl,keyword}) async{
    if(url==null||url=='') return;
      final uri =  Uri.parse(url);
      print(uri);
      final resp = await http.get(uri);
      if(resp.statusCode==200){
        Utf8Decoder utf8decoder = Utf8Decoder();
        var result = json.decode(utf8decoder.convert(resp.bodyBytes));
        SearchModel model = SearchModel.fromJson(result);
        model.keyword=keyword;

        return {
          'SearchModel':model,
          'resultStrJson':result
        };
      } else {
        throw Exception('请求失败');
      }


  }
}