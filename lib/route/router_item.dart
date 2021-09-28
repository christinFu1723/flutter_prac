import 'package:fluro/fluro.dart';

// 路由对象
class RouteItem {
  // 名称
  String name;

  // 页面实例
  dynamic handler;

  // 构造方法
  RouteItem({this.name, this.handler});

  Handler get hand {
    if (this.handler is Handler) {
      return this.handler;
    }
    return Handler(handlerFunc: (context, parameters) => this.handler);
  }
}