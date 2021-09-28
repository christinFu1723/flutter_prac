import 'package:demo7_pro/route/router_item.dart' show RouteItem;

import 'package:demo7_pro/pages/speak_page.dart' show SpeakPage;

// 路由定义
class SpeakPageRoutes {
  static String speak = "/speak";

  // 路由定义
  static get route {
    List<RouteItem> _routes = [
      // 购物车
      RouteItem(name: speak, handler: SpeakPage()),
    ];
    return _routes;
  }
}
