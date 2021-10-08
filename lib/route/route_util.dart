import 'package:fluro/fluro.dart' show FluroRouter, TransitionType;
import 'package:flutter/widgets.dart'
    show BuildContext, RouteTransitionsBuilder, RouteSettings;
import 'package:demo7_pro/route/routes.dart' show Routes;
import 'package:demo7_pro/route/route_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

/// 页面切换
/// 需要编写RouteItem并且在route/routes.dart里注册页面路由
Future navTo(BuildContext context, String path,
    {bool replace = false,
    bool clearStack = false,
    TransitionType transition = TransitionType.cupertino,
    Duration transitionDuration = const Duration(milliseconds: 250),
    RouteTransitionsBuilder transitionBuilder,
    Object arguments}) {
  // 如果是跳转到根目录，清空回退栈
  var isRoot = path == Routes.root;
  Logger().i(path);
  return FluroRouter.appRouter.navTo(context, path,
      replace: replace,
      clearStack: isRoot ? true : clearStack,
      transition: transition,
      transitionDuration: transitionDuration,
      transitionBuilder: transitionBuilder,
      routeSettings: RouteSettings(arguments: arguments));
}

/// 页面/组件返回
///
/// #### 基础用法
/// `pop(context);`
/// #### 接收参数
/// `pop(context, result: 'Something');`
/// #### 接收参数
/// `pop(context, result: ['one', 'two']);`
void pop(BuildContext context, {dynamic result}) {
  Navigator.of(context).pop(result);
}


/// 页面/组件返回N级
///
/// #### 基础用法
/// `popUntil(context,predicate);`
Future<dynamic> popUntil(
  BuildContext context,
  RoutePredicate predicate,
) async {
  try {
    Navigator.popUntil(context, predicate);
  } catch (e) {
    throw Exception(e);
  }
}

/// 组件widget弹出
///
/// #### 基础用法
/// `pushWidget(context, DemoPage());`
/// #### 传递参数
/// `pushWidget(context, DetailPage(id: 'Hello'));`
Future<dynamic> pushWidget(BuildContext context, Widget page,
    {bool fullscreenDialog: false, RouteSettings settings}) async {
  try {
    final result = await Navigator.push(
      context,
      new CupertinoPageRoute(
        builder: (_) => page,
        settings: settings,
        fullscreenDialog: fullscreenDialog,
      ),
    );
    return result;
  } catch (e) {
    throw e;
  }
}

