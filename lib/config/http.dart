import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpConfig {
  HttpConfig._();

  static HttpConfig _instance = HttpConfig._();

  static HttpConfig get instance => _instance;

  String proxyBaseUrl = '192.168.201.94:1080';

  /// 服务器端接口配置
  static Map<String, String> apis = {
    "development": "https://www.devio.org/io/flutter_app/",
    "uat": "https://www.devio.org/io/flutter_app/",
    "production": "https://www.devio.org/io/flutter_app/",
  };

  /// 服务端地址
  String baseUrl = apis[dotenv.env["ENV"]];

  /// 请求超时时间（毫秒）
  int timeout = 1000 * 10;

  void setBaseUrlWithEnv(String value) {
    this.baseUrl = apis[value];
  }

  void setBaseUrlWithUrl(String url) {
    this.baseUrl = url;
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
    "mini": Client(
        id: "kXcirGg0gq1qiqeUqwVQzL8D",
        secret: "DKPCAY1CvvY8ROZNIOUE1mELqr7yEVdA")
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
