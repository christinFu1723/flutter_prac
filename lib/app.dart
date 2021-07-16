import 'package:provider/provider.dart';
import 'package:demo7_pro/store/app.dart';
import 'package:demo7_pro/store/personal.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:demo7_pro/tabbar/tab_nav.dart';

class App extends StatefulWidget{
  @override
  _AppState createState()=>_AppState();
}

class _AppState extends State<App>{
  Widget build(BuildContext context){
    final botToastBuilder = BotToastInit();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppStoreModel>(
          create: (BuildContext context) => AppStoreModel(),
        ),
        ChangeNotifierProvider<PersonalStoreModel>(
          create: (BuildContext context) => PersonalStoreModel(),
        ),
      ],
      builder: ((BuildContext context, Widget _) {
        return MaterialApp(
          title: '阿福首页',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: TabNavigator(),
          builder: (BuildContext context, Widget child) {
            child = botToastBuilder(context, child);
            return child;
          },
          navigatorObservers: [BotToastNavigatorObserver()],
        );
      }),
    );
  }
}