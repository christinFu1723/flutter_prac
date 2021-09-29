import 'package:demo7_pro/route/router_item.dart' show RouteItem;
import 'package:fluro/fluro.dart' show Handler;
import 'package:flutter/material.dart';
import 'package:demo7_pro/widgets/webview.dart' show WebView;


// 路由定义
class WebviewPageRoutes {
  static String webview = "/webview";

  // 路由定义
  static get route {
    List<RouteItem> _routes = [
      // 购物车
      RouteItem(name: webview, handler:  Handler(handlerFunc:
          (BuildContext context, Map<String, List<String>> params) {

        final Map<String, dynamic> args =
            ModalRoute.of(context).settings.arguments;
        final String url= args["url"];
        final String statusBar= args["statusBar"];
        final String title= args["title"];
        final bool hideAppBar= args["hideAppBar"];
        final bool backForbid= args["backForbid"];

        return WebView(url: url, statusBar: statusBar,title:title,hideAppBar:hideAppBar,backForbid:backForbid);
      })),
    ];
    return _routes;
  }
}
