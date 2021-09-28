import 'package:demo7_pro/route/router_item.dart' show RouteItem;
import 'package:demo7_pro/pages/cashier/cashier.dart' show CashierPage;

// 路由定义
class CashierRoutes {
  static String cashier = "/cashier";

  // 路由定义
  static get route {
     List<RouteItem> _routes = [
      // 购物车
      RouteItem(name: cashier, handler: CashierPage()),
    ];
    return _routes;
  }
}
