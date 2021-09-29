import 'package:demo7_pro/route/router_item.dart' show RouteItem;
import 'package:demo7_pro/pages/login_page.dart' show LoginPage;

// 路由定义
class LoginPageRoutes {
  static String login = "/login";

  // 路由定义
  static get route {
    List<RouteItem> _routes = [
      RouteItem(name: login, handler: LoginPage()),
    ];
    return _routes;
  }
}
