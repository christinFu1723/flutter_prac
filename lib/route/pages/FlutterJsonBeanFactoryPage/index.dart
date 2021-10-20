import 'package:demo7_pro/route/router_item.dart' show RouteItem;
import 'package:demo7_pro/pages/flutter_json_bean_factory_test/flutter_json_bean_factory.dart'
    show FlutterJsonBeanFactoryPage;

// 路由定义
class FlutterJsonBeanFactoryPageRoutes {
  static String futterJsonBeanFactoryPage = "/futterJsonBeanFactoryPage";

  // 路由定义
  static get route {
    List<RouteItem> _routes = [
      RouteItem(
          name: futterJsonBeanFactoryPage,
          handler: FlutterJsonBeanFactoryPage()),
    ];
    return _routes;
  }
}
