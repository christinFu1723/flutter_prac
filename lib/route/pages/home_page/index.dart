import 'package:demo7_pro/route/router_item.dart' show RouteItem;
import 'package:demo7_pro/pages/home_page.dart' show MyHomePage;

// 路由定义
class HomePageRoutes {
  static String home = "/home";

  // 路由定义
  static get route {
    List<RouteItem> _routes = [
      // 购物车
      RouteItem(name: home, handler: MyHomePage()),
    ];
    return _routes;
  }
}
