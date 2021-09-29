import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart' hide Router;
import 'package:demo7_pro/route/router_item.dart' show RouteItem;
import 'package:demo7_pro/route/pages/cashier/index.dart' show CashierRoutes;
import 'package:demo7_pro/route/pages/home_page/index.dart' show HomePageRoutes;
import 'package:demo7_pro/route/pages/search_page/index.dart'
    show SearchPageRoutes;
import 'package:demo7_pro/route/pages/speak_page//index.dart'
    show SpeakPageRoutes;
import 'package:demo7_pro/route/pages/submit_page/index.dart'
    show SubmitPageRoutes;
import 'package:demo7_pro/route/pages/webview/index.dart'
    show WebviewPageRoutes;
import 'package:demo7_pro/route/pages/filter_page/index.dart' show FilterPageRoutes;
import 'package:demo7_pro/route/pages/login_page/index.dart' show LoginPageRoutes;
import 'package:demo7_pro/widgets/tabbar/tab_nav.dart' show TabNavigator;


// 路由定义
class Routes {
  static String root = "/";

  // 路由定义
  static List<RouteItem> _routes = [
    RouteItem(name: root, handler: TabNavigator()),
    ...CashierRoutes.route,
    ...HomePageRoutes.route,
    ...SpeakPageRoutes.route,
    ...SubmitPageRoutes.route,
    ...SearchPageRoutes.route,
    ...WebviewPageRoutes.route,
    ...FilterPageRoutes.route,
    ...LoginPageRoutes.route
  ];

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("没有匹配的路由！");
      return TabNavigator();
    });

    // 批量注册
    _routes.forEach((RouteItem route) {
      router.define(
        route.name,
        handler: route.hand,
      );
    });
  }
}
