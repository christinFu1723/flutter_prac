import 'package:demo7_pro/route/router_item.dart' show RouteItem;

import 'package:demo7_pro/pages/submit_page/submit_page.dart' show SubmitPage;

// 路由定义
class SubmitPageRoutes {
  static String submit = "/submit";

  // 路由定义
  static get route {
    List<RouteItem> _routes = [
      // 购物车
      RouteItem(name: submit, handler: SubmitPage()),
    ];
    return _routes;
  }
}
