import 'package:provider/provider.dart';
import 'package:demo7_pro/store/app.dart';
import 'package:demo7_pro/store/personal.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:demo7_pro/route/routes.dart' show Routes;
import 'package:fluro/fluro.dart' show FluroRouter;
import 'package:demo7_pro/tabbar/tab_nav_get.dart';
import 'package:get/get.dart';

import 'package:demo7_pro/pages/home_page_get.dart';
import 'package:demo7_pro/pages/my_page_get.dart';

import 'package:demo7_pro/pages/home_page.dart';
import 'package:demo7_pro/pages/my_page.dart';
import 'package:demo7_pro/pages/search_page.dart';
import 'package:demo7_pro/pages/travel_page.dart';
import 'package:demo7_pro/pages/search_page.dart';
import 'package:demo7_pro/pages/travel_page.dart';
import 'package:demo7_pro/pages/root/views/root_view.dart';

class AppGET extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<AppGET> {
  @override
  void initState() {
    print('渲染了吗');
    super.initState();
  }

  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();

    return GetMaterialApp.router(
      defaultTransition: Transition.native,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CH'),
        const Locale('en', 'US'), // English
      ],
      getPages: [
        GetPage(
            name: '/', // 实际实验反复尝试，要挂出根节点
            page: () =>RootView(), // 根节点要指向initRoute到/tabbar
            participatesInRootNavigator: true, // 加入到根导航中，否则tabbar无法保持navigatItem渲染？？？我也不知道，找半天没找到文档为什么
            preventDuplicates: true,// 没文档，不知道有什么用？？？
            children: [
              GetPage(
                  name: '/tabbar',
                  page: () => TabNavigatorGet(),
                  participatesInRootNavigator: false,
                  preventDuplicates: false,
                  bindings: [
                    TabbarBinding()
                  ],
                  children: [
                    GetPage(name: '/home', page: () => MyHomePage()),
                    GetPage(name: '/myTest', page: () => MyHomePageGET(),bindings: [HomeBinding()]),
                    GetPage(name: '/search', page: () => SearchPage()),
                    GetPage(name: '/travel', page: () => TravelPage()),
                    GetPage(name: '/my', page: () => MyPage())
                  ]),
              GetPage(name: '/myHome', page: () => MyHomePage())
        ])
      ], // builder: (context, child) {
      //   return MyHomePage();
      // },
    );
  }
}
