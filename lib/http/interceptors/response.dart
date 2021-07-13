import 'dart:async';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

// 响应拦截器
class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response,ResponseInterceptorHandler handler) {
    if (response?.statusCode != 200) {
      throw (response?.statusMessage ?? '接口响应错误');
    }
    // Logger().w(response.data);
    // return super.onResponse(response);
    handler.next(response);
  }

}
