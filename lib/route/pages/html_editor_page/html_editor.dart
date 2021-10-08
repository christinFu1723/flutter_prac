import 'package:demo7_pro/route/router_item.dart' show RouteItem;
import 'package:demo7_pro/pages/html_editor_page/html_editor.dart' show HtmlEditorPage;

// 路由定义
class HtmlEditorPageRoutes {
  static String htmlEditorPage = "/html-editor-page";

  // 路由定义
  static get route {
    List<RouteItem> _routes = [
      RouteItem(name: htmlEditorPage, handler: HtmlEditorPage()),
    ];
    return _routes;
  }
}