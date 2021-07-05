import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpConfig {
  HttpConfig._();
  static HttpConfig _instance = HttpConfig._();
  static HttpConfig get instance => _instance;

  /// 服务器端接口配置
  static Map<String, String> apis = {
    "development": "http://192.168.200.246:8282",
    "uat": "https://uat.api.dingdangchewu.com",
    "production": "https://api.dingdangchewu.com",
  };

  /// 服务端地址
  String baseUrl = apis[dotenv.env["ENV"]];

  /// 请求超时时间（毫秒）
  int timeout = 1000 * 10;

  void setBaseUrlWithEnv(String value) {
    this.baseUrl = apis[value];
  }

  /// 客户端参数配置，具体 secret 参数咨询后端
  final Map<String, dynamic> clients = {
    "android": Client(
      id: "android",
      secret: "G2kWj3JtUtOFpTjn",
    ),
    "ios": Client(
      id: "ios",
      secret: "BWu23JQw8dnOhg6D",
    ),
  };
}

/// 客户端配置
class Client {
  /// 客户端标识名称
  final String id;

  /// 客户端授权令牌
  final String secret;

  Client({
    @required this.id,
    @required this.secret,
  });
}
