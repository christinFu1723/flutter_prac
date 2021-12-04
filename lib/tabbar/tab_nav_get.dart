import 'package:flutter/material.dart';

// import 'package:demo7_pro/pages/home_page.dart';
// import 'package:demo7_pro/pages/my_page.dart';
// import 'package:demo7_pro/pages/search_page.dart';
// import 'package:demo7_pro/pages/travel_page.dart';
// import 'package:demo7_pro/pages/login_page.dart';
// import 'package:demo7_pro/utils/app.dart';
import 'package:demo7_pro/eventBus/app.dart';
import 'dart:async';
import 'package:demo7_pro/utils/event_bus.dart';
import 'package:demo7_pro/services/app.dart';
import 'package:logger/logger.dart';
import 'package:demo7_pro/route/tabbar/tabbar.dart' show TabConfig;
import 'package:demo7_pro/route/route_util.dart' show navTo;
import 'package:demo7_pro/route/pages/login_page/index.dart'
    show LoginPageRoutes;
import 'package:dio_log/dio_log.dart';
import 'package:get/get.dart';

// class TabNavigator extends StatefulWidget {
//   @override
//   _TabNavigatorState createState() => _TabNavigatorState();
// }
class TabbarController extends GetxController {}

class TabbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabbarController>(
      () => TabbarController(),
    );
  }
}

class TabNavigatorGet extends GetView<TabbarController> {
  final MaterialColor _defaultColor = Colors.grey;
  final MaterialColor _activeColor = TabConfig.activeColor;

  @override
  Widget build(BuildContext context) {
    return GetRouterOutlet.builder(
      builder: (context, delegate, currentRoute) {
        //This router outlet handles the appbar and the bottom navigation bar
        final currentLocation = currentRoute?.location;
        print('路由导航:$currentLocation');
        var currentIndex = 0;
        if (currentLocation?.startsWith('/tabbar/home') == true) {
          currentIndex = 0;
        }
        if (currentLocation?.startsWith('/tabbar/search') == true) {
          print('dsdssd1111');
          currentIndex = 1;
        }
        if (currentLocation?.startsWith('/tabbar/travel') == true) {
          currentIndex = 2;
        }
        if (currentLocation?.startsWith('/tabbar/my') == true) {
          currentIndex = 3;
        }

        if (currentLocation?.startsWith('/tabbar/myTest') == true) {
          print('sdhdshds112121');
          currentIndex = 4;
        }
        return Scaffold(
          body: GetRouterOutlet(
            initialRoute: '/tabbar/home',
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (value) {
              switch (value) {
                case 0:
                  delegate.toNamed('/tabbar/home');
                  break;
                case 1:
                  print('dsjhsdhjdsh');
                  delegate.toNamed('/tabbar/search');
                  break;
                case 2:
                  delegate.toNamed('/tabbar/travel');
                  break;
                case 3:
                  delegate.toNamed('/tabbar/my');
                  break;
                case 4:
                  delegate.toNamed('/tabbar/myTest');
                  break;
                default:
              }
            },
            items: [
              _bottomItem('首页', Icons.home, 0, currentIndex),
              _bottomItem('搜索', Icons.search, 1, currentIndex),
              _bottomItem('旅拍', Icons.camera, 2, currentIndex),
              _bottomItem('我的', Icons.account_circle, 3, currentIndex),
              _bottomItem('首页测试getX', Icons.home, 4, currentIndex),
            ],
          ),
        );
      },
    );
  }

  _bottomItem(String title, IconData icon, int index, int currentIndex) {
    return BottomNavigationBarItem(
        icon: Icon(
          icon,
          color: _defaultColor,
        ),
        activeIcon: Icon(
          icon,
          color: _activeColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: currentIndex != index ? _defaultColor : _activeColor,
          ),
        ));
  }
}
