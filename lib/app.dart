import 'package:provider/provider.dart';
import 'package:demo7_pro/store/app.dart';
import 'package:demo7_pro/store/personal.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:demo7_pro/tabbar/tab_nav.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:demo7_pro/route/routes.dart' show Routes;
import 'package:fluro/fluro.dart' show FluroRouter;

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
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('zh', 'CH'),
            const Locale('en', 'US'), // English
          ],
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),

          builder: (BuildContext context, Widget child) {
            child = botToastBuilder(context, child);
            return child;
          },
          navigatorObservers: [BotToastNavigatorObserver()],
          initialRoute: Routes.root,
          onGenerateRoute: FluroRouter.appRouter.generator,
        );
      }),
    );
  }
}