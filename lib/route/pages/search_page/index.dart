import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart' show Handler;
import 'package:demo7_pro/route/router_item.dart' show RouteItem;

import 'package:demo7_pro/pages/search_page.dart' show SearchPage;
import 'package:logger/logger.dart';

// 路由定义
class SearchPageRoutes {
  static String search = "/search";

  // 路由定义
  static get route {
    List<RouteItem> _routes = [
      // 购物车
      RouteItem(
          name: search,
          handler: Handler(handlerFunc:
              (BuildContext context, Map<String, List<String>> params) {

            final Map<String, dynamic> args =
                ModalRoute.of(context).settings.arguments;


            final bool hideLeft= args["hideLeft"];
            final String searchUrl= args["searchUrl"];
            final String keyword= args["keyword"];
            final String hint= args["hint"];
            return SearchPage(hideLeft: hideLeft??params["hideLeft"].first=='true', hint: hint,searchUrl:searchUrl,keyword:keyword);
          })),
    ];
    return _routes;
  }
}
