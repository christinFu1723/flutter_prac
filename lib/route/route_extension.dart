import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart' hide Router;

extension RouteExtension on FluroRouter {
  // 默认用iOS样式跳转
  Future navTo(BuildContext context, String path,
      {bool replace = false,
      bool clearStack = false,
      TransitionType transition = TransitionType.cupertino,
      Duration transitionDuration = const Duration(milliseconds: 250),
      RouteTransitionsBuilder transitionBuilder,
      RouteSettings routeSettings}) {
    return navigateTo(
      context,
      path,
      replace: replace,
      clearStack: clearStack,
      transition: transition,
      transitionDuration: transitionDuration,
      transitionBuilder: transitionBuilder,
      routeSettings: routeSettings,
    );
  }
}
