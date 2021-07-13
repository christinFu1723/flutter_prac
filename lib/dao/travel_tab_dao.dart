import 'package:demo7_pro/model/travel_tab_model.dart';
import 'dart:async';
import 'package:demo7_pro/http/http.dart';



class TravelTabDao{
  static Future<dynamic> fetch() async{

    final resp = await HttpUtil.instance.get('/json/travel_page.json');
      return {
        'TravelTabModel':TravelTabModel.fromJson(resp),
        'resultStrJson':resp
      };
  }
}