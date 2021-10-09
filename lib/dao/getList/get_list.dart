import 'package:demo7_pro/json/get_list_entity.dart';
import 'dart:async';
import 'dart:convert';
import 'package:demo7_pro/http/http.dart';
import 'package:logger/logger.dart';



class GetListRequest {
  static final baseUrl = 'https://api.uat.chanjesign.com';
  static Future<dynamic> fetch({String organizeNameLike=''}) async {
    GetListEntity resp = await HttpUtil.instance
        .postT<GetListEntity>('$baseUrl/api/mini/v1/organizes/approval/page?pageNo=1&pageSize=10', data: {"organizeNameLike":organizeNameLike,"organizeStatus":"PENDING_AUDIT"});
    Logger().i('最后输出：${resp.toJson()}');
    Logger().i('最后输出：${resp.total}');
    return resp;

  }
}
