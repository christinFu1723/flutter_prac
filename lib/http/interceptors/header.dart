import 'dart:convert';
import 'dart:async';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:demo7_pro/services/app.dart' show AppService;



// 拦截器 请求前添加头部 token
class HeaderInterceptor extends Interceptor{
  @override
  void onRequest(RequestOptions options,RequestInterceptorHandler handler) async {
    Map<String,dynamic> header ={};

    if(options.path.startsWith('/api')||options.path.startsWith('https://api.uat.chanjesign.com/api')){
      String token = await AppService.getToken();
      header['Authorization']=token;

    }

    options.headers.addAll(header);

    String params;

    try{
      params =json.encode(options.data).toString();

    } catch(e){
      params=options.data.toString();
    }

    String logs = '''请求方式：${options.method}
                  请求接口：${options.uri.toString()};
                  请求报头：${options.headers.toString()}
                  请求参数：$params''';

    Logger().i(logs);

    // return super.onRequest(options);
    handler.next(options);
  }
}