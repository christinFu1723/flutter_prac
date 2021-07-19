import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:dio/adapter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:demo7_pro/config/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:demo7_pro/http/interceptors/header.dart';
import 'package:demo7_pro/http/interceptors/response.dart';
import 'package:demo7_pro/model/response_data.dart';
import 'package:demo7_pro/utils/event_bus.dart';
import 'package:demo7_pro/eventBus/app.dart' show NeedReLoginEvent;

class HttpUtil{
  bool openProxy=false; // 是否开启代理
  // 请求类型
  static const CONTENT_TYPE_JSON = 'application/json';
  static const CONTENT_TYPE_FROM = 'application/x-www-form-urlencoded';
  // Dio 实例
  static Dio _dio = Dio();

  // HttpUtil 实例
  static HttpUtil _instance = HttpUtil();

  static HttpUtil get instance => _instance;

  static HttpUtil getInstance() {
    if (_instance != null) return _instance;
    _instance = new HttpUtil();
    return _instance;
  }

  setProxy(bool proxyFlg){
    this.openProxy = proxyFlg;
  }

  HttpUtil() {
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      if(this.openProxy){
        // 用1个开关设置是否开启代理
        client.findProxy = (Uri) {
          return 'PROXY ${ HttpConfig.instance.proxyBaseUrl}';
        };
      }

      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    // 配置设置
    _dio.options.method = 'get';
    _dio.options.baseUrl = HttpConfig.instance.baseUrl;
    _dio.options.sendTimeout = HttpConfig.instance.timeout;
    _dio.options.receiveTimeout = HttpConfig.instance.timeout;


    // 拦截器装载
    _dio.interceptors.add(HeaderInterceptor());
    _dio.interceptors.add(ResponseInterceptor());
  }





  // 请求方法
  Future<dynamic> request(
      String url, {
        dynamic data,
        Map<String, dynamic> queryParameters,
        Map<String, dynamic> headers,
        Options options,
      }) async {


    // 构造请求参数
    options = options ?? Options();

    if (headers != null) {
      options.headers.addAll(headers);
    }

    try {
      Response response = await _dio.request(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return response.data;
    } catch (error) {
      Logger().d(error);

      if (error is DioError && error.response == null) {
        throw '连接服务器失败';
      }

      if (error is DioError && error.response.data != null) {
        /// 连接服务器失败
        if (error.response?.statusCode == 502) {
          throw '连接服务器失败';
        }

        /// 验证过期，需要重新登录
        if (error.response?.statusCode == 403) {
          EventBusUtil.instance.eventBus.fire(NeedReLoginEvent());
          // AppUtil().pushAndRemoveUntil(context,);
          throw '登录无效，请重新登录';
        }

        /// 验证过期，需要重新登录
        if (error.response?.statusCode == 404) throw '调用接口不存在';

        /// 判断消息是否为 `{"msg": "error"}` 之类的格式
        if (RegExp(r'^{.*}$').hasMatch(error.response.toString())) {
          Map<String, dynamic> _error = json.decode(error.response.toString());
          throw _error['msg'] ?? _error['error_description'];
        }

        try {
          ResponseData responseData = ResponseData.fromJson(
            error.response.data ?? {},
          );
          if (responseData?.code != 200) throw responseData.msg ?? '请求错误，请稍后再试';
        } catch (e) {
          throw error.response.data.toString();
        }
      }

      throw error.response?.statusMessage ??
          error.response.toString() ??
          error.toString();
    }
  }

  Future<dynamic> get(
      String url, {
        dynamic data,
        Map<String, dynamic> queryParameters,
        CancelToken cancelToken,
        Options options,
      }) async =>
      await request(
        url,
        data: data,
        queryParameters: queryParameters,
        options: (options ?? Options()).copyWith(method: 'get'),
      );

  Future<dynamic> post(
      String url, {
        dynamic data,
        Map<String, dynamic> queryParameters,
        CancelToken cancelToken,
        Options options,
      }) async =>
      await request(
        url,
        data: data,
        queryParameters: queryParameters,
        options: (options ?? Options()).copyWith(method: 'post'),
      );

  Future<dynamic> put(
      String url, {
        dynamic data,
        CancelToken cancelToken,
        Options options,
      }) async =>
      await request(
        url,
        data: data,
        options: (options ?? Options()).copyWith(method: 'put'),
      );

  Future<dynamic> patch(
      String url, {
        dynamic data,
        CancelToken cancelToken,
        Options options,
      }) async =>
      await request(
        url,
        data: data,
        options: (options ?? Options()).copyWith(method: 'patch'),
      );

  Future<dynamic> delete(
      String url, {
        dynamic data,
        CancelToken cancelToken,
        Options options,
      }) async =>
      await request(
        url,
        data: data,
        options: (options ?? Options()).copyWith(method: 'delete'),
      );

  Future<dynamic> download(
      String url,
      String fileName, {
        Options options,
      }) async {
    try {
      /// 权限校验
      if (Platform.isAndroid) {
        PermissionStatus status = await Permission.storage.status;
        if (status != PermissionStatus.granted) {
          status = await Permission.storage.request();
          if (status != PermissionStatus.granted) throw '权限不足!';
        }
      }

      /// 获取缓存目录
      Directory appDocDir = await getExternalStorageDirectory();
      String appDocPath = appDocDir.path;
      String savePath = "$appDocPath/$fileName";

      await _dio.download(url, savePath);

      return savePath;
    } catch (e) {
      throw e;
    }
  }


}