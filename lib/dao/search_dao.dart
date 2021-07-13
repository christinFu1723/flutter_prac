import 'package:demo7_pro/model/search_model.dart';
import 'dart:async';
import 'package:demo7_pro/http/http_sec.dart';
import 'package:demo7_pro/config/http.dart';


// const baseUrl='https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=';
const baseUrl = 'https://m.ctrip.com';

class SearchDao{
  static Future<dynamic> fetch({keyword}) async{
      // 单独new 一个http实例
      final resp = await HttpUtilSec(baseUrlInput:baseUrl).get('/restapi/h5api/searchapp/search',queryParameters:{
        'source':'mobileweb',
        'action':'autocomplete',
        'contentType':'JSON',
        'keyword':keyword
      });
      SearchModel model = SearchModel.fromJson(resp);
      model.keyword=keyword;
      return {
        'SearchModel':model,
        'resultStrJson':resp
      };


  }
}