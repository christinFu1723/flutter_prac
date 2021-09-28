import 'package:fluro/fluro.dart' show FluroRouter,TransitionType;
import 'package:flutter/widgets.dart' show BuildContext,RouteTransitionsBuilder,RouteSettings;
import 'package:demo7_pro/route/routes.dart' show Routes;
import 'package:demo7_pro/route/route_extension.dart';

// 简化导包地操作
Future navTo(BuildContext context, String path,
    {bool replace = false,
    bool clearStack = false,
    TransitionType transition = TransitionType.cupertino,
    Duration transitionDuration = const Duration(milliseconds: 250),
    RouteTransitionsBuilder transitionBuilder,
    Object arguments}) {
  // 如果是跳转到根目录，清空回退栈
  var isRoot = path == Routes.root;
  return FluroRouter.appRouter.navTo(context, path,
      replace: replace,
      clearStack: isRoot ? true : clearStack,
      transition: transition,
      transitionDuration: transitionDuration,
      transitionBuilder: transitionBuilder,
      routeSettings: RouteSettings(arguments: arguments));
}
