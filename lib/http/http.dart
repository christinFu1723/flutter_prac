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
import 'package:demo7_pro/generated/json/base/json_convert_content.dart';
import 'package:demo7_pro/json/base_entity.dart';
import 'package:demo7_pro/json/base_list_entity.dart';
import 'package:dio_log/dio_log.dart';
import 'package:logger/logger.dart';

class HttpUtil {
  bool openProxy = false; // 是否开启代理
  // 请求类型
  static const CONTENT_TYPE_JSON = 'application/json';
  static const CONTENT_TYPE_FROM = 'application/x-www-form-urlencoded';

  // Dio 实例
  static Dio _dio = Dio();

  // HttpUtil 实例
  static HttpUtil instance = HttpUtil();

  static HttpUtil getInstance() {
    if (instance != null) return instance;
    instance = new HttpUtil();
    return instance;
  }

  setProxy(bool proxyFlg) {
    this.openProxy = proxyFlg;
  }

  HttpUtil() {
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      if (this.openProxy) {
        // 用1个开关设置是否开启代理
        client.findProxy = (Uri) {
          return 'PROXY ${HttpConfig.instance.proxyBaseUrl}';
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
    _dio.interceptors.add(DioLogInterceptor());
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
    bool isSpecial = false, // 如果true，则返回Response Object
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
      if (isSpecial) {
        return Future.value(response);
      }
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
        if (error.response?.statusCode == 401) {
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

  // delete请求，返回经过 BaseEntity 包装后的实体
  Future<T> deleteT<T>(
    String url, {
    dynamic data,
    CancelToken cancelToken,
    Options options,
  }) async =>
      await (await request(url,
              data: data,
              options: (options ?? Options()).copyWith(method: 'delete'),
              isSpecial: true))
          .toObject<T>();

// get请求，返回经过 BaseEntity 包装后的实体
  Future<dynamic> getT<T>(
    String url, {
    dynamic data,
    Map<String, dynamic> queryParameters,
    CancelToken cancelToken,
    Options options,
  }) async {
    Response res = await request(url,
        data: data,
        queryParameters: queryParameters,
        options: (options ?? Options()).copyWith(method: 'get'),
        isSpecial: true);
    Logger().i('res:$res');
    var resp = await res.toObject<T>();
    Logger().i('resp:$resp');

    return resp;
  }

// get 请求，返回经过 BaseListEntity 包装后的 List<实体>
  Future<List<T>> getListT<T>(
    String url, {
    dynamic data,
    Map<String, dynamic> queryParameters,
    CancelToken cancelToken,
    Options options,
  }) async {
    Response res = await request(url,
        data: data,
        queryParameters: queryParameters,
        options: (options ?? Options()).copyWith(method: 'get'),
        isSpecial: true);

    var resp = await res.toList<T>();


    return resp;
  }

// post请求，返回经过 BaseEntity 包装后的实体
  Future<T> postT<T>(
    String url, {
    dynamic data,
    Map<String, dynamic> queryParameters,
    CancelToken cancelToken,
    Options options,
  }) async {
    Response res = await request(url,
        data: data,
        queryParameters: queryParameters,
        options: (options ?? Options()).copyWith(method: 'post'),
        isSpecial: true);

    var resp = await res.toObject<T>();


    return resp;
  }

////////////////////////////////////////////////////////////////////////////

// 处理如果返回值是'实体'的时候
  static Future<T> handleObj<T>(Response response) {
    try {
      var baseEntity = JsonConvert.fromJsonAsT<BaseEntity>(response.data);

      if (!baseEntity.success) {
        return Future.error(
            baseEntity.message ?? baseEntity.data); // 这个其实是为了兼容老接口返回的数据结构
      } else {
        if (T == BaseEntity) {
          return Future.value(baseEntity as T);
        }
        if (baseEntity.data == null) {
          return Future.value(null);
        } else {
          if (baseEntity.data is String) {
            return Future.value(baseEntity.data);
          }
          return Future.value(JsonConvert.fromJsonAsT<T>(baseEntity.data));
        }
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  static Future<T> handleMap<T>(Response response) {
    try {
//有些时候返回的这个是个json字符串，还转义了，导致dio不能识别为map对象，所以得自己手动又搞一遍。
//比如极验这个接口，返回的就是一个转义后的json字符串。。。
      var map = response.data;
      if (map is String) {
        map = jsonDecode(map);
      }
      return Future.value(map);
    } catch (error) {
      return Future.error(error);
    }
  }

  static Future<T> handleObjOri<T>(Response response) {
    try {
//有些时候返回的这个是个json字符串，还转义了，导致dio不能识别为map对象，所以得自己手动又搞一遍。
//比如极验这个接口，返回的就是一个转义后的json字符串。。。
      var map = response.data;
      if (map is String) {
        map = jsonDecode(map);
      }
      var entity = JsonConvert.fromJsonAsT<T>(map);
      return Future.value(entity);
    } catch (error) {
      return Future.error(error);
    }
  }

// 处理如果返回值是'列表<实体>'的时候
  static Future<List<T>> handleList<T>(Response response) {
    var baseListEntity = JsonConvert.fromJsonAsT<BaseListEntity>(response.data);
    if (baseListEntity.code != 200) {
      return Future.error(baseListEntity.message ?? baseListEntity.data);
    } else {
      if (baseListEntity.data == null) {
        return Future.value(null);
      } else {
        var result = baseListEntity.data
            .map((i) => JsonConvert.fromJsonAsT<T>(i))
            .toList();
        return Future.value(result);
      }
    }
  }

////////////////////////////////////////////////////////////////////////////

}

extension ResponseExtension on Response {
  Future<T> toObject<T>() async {

    return await HttpUtil.handleObj<T>(this);
  }

  Future<T> toObjectOri<T>() async {
    return HttpUtil.handleObjOri<T>(this);
  }

  Future<T> toMap<T>() async {
    return HttpUtil.handleMap<T>(this);
  }

  Future<List<T>> toList<T>() async {
    return HttpUtil.handleList<T>(this);
  }
}
