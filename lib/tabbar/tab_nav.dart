import 'package:flutter/material.dart';
// import 'package:demo7_pro/pages/home_page.dart';
// import 'package:demo7_pro/pages/my_page.dart';
// import 'package:demo7_pro/pages/search_page.dart';
// import 'package:demo7_pro/pages/travel_page.dart';
import 'package:demo7_pro/eventBus/app.dart';
import 'dart:async';
import 'package:demo7_pro/utils/event_bus.dart';
import 'package:demo7_pro/pages/login_page.dart';
import 'package:demo7_pro/services/app.dart';
import 'package:demo7_pro/utils/app.dart';
import 'package:logger/logger.dart';
import 'package:demo7_pro/route/tabbar/tabbar.dart' show TabConfig;

import 'package:demo7_pro/route/route_util.dart' show navTo;
import 'package:demo7_pro/route/pages/login_page/index.dart' show LoginPageRoutes;

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  int _currentIndex = TabConfig.index;

  final PageController _controller = PageController(
    initialPage:TabConfig.index,
  );

  final MaterialColor _defaultColor = TabConfig.defaultColor;
  final MaterialColor _activeColor =  TabConfig.activeColor;
  /// 重新登录事件
  StreamSubscription<NeedReLoginEvent> _needLogin;

  @override
  void initState(){
    _needLogin =
        EventBusUtil.instance.eventBus.on<NeedReLoginEvent>().listen((event) {
          needLogin();
        });
    /// 初始化应用状态
    init();
    super.initState();
  }

  void init() async{
    /// 初始化应用状态
    await AppService.start(context);
  }

  Future<void> needLogin() async{
    await AppService.clearPrefers(context);
    Logger().i('检查到需要跳转登录页');
    /// 转到登录页
    navTo(context, "${LoginPageRoutes.login}",clearStack:true);
  }



  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index:_currentIndex ,
        children: TabConfig.tab,

      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          // _controller.jumpToPage(index);
          _controller.animateToPage(index, duration: new Duration(milliseconds: 500),curve:new ElasticOutCurve(4));

          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _defaultColor,
              ),
              activeIcon: Icon(
                Icons.home,
                color: _activeColor,
              ),
              title: Text(
                '首页',
                style: TextStyle(
                  color: _currentIndex != 0 ? _defaultColor : _activeColor,
                ),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: _defaultColor,
              ),
              activeIcon: Icon(
                Icons.search,
                color: _activeColor,
              ),
              title: Text(
                '搜索',
                style: TextStyle(
                  color: _currentIndex != 1 ? _defaultColor : _activeColor,
                ),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.camera,
                color: _defaultColor,
              ),
              activeIcon: Icon(
                Icons.camera,
                color: _activeColor,
              ),
              title: Text(
                '旅拍',
                style: TextStyle(
                  color: _currentIndex != 2 ? _defaultColor : _activeColor,
                ),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
                color: _defaultColor,
              ),
              activeIcon: Icon(
                Icons.account_circle,
                color: _activeColor,
              ),
              title: Text(
                '我的',
                style: TextStyle(
                  color: _currentIndex != 3 ? _defaultColor : _activeColor,
                ),
              ))
        ],
      ),
    );
  }
}
