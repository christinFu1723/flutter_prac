import 'package:demo7_pro/route/router_item.dart' show RouteItem;
import 'package:demo7_pro/pages/filter_page/filter_page.dart' show FilterPage;

// 路由定义
class FilterPageRoutes {
  static String filter = "/filter";

  // 路由定义
  static get route {
    List<RouteItem> _routes = [
      // 购物车
      RouteItem(name: filter, handler: FilterPage()),
    ];
    return _routes;
  }
}
