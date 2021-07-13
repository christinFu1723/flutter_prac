import 'package:flutter/material.dart';
import 'package:flutter/services.dart' ;
import 'dart:io' show Platform;
import 'package:demo7_pro/pages/home_page.dart';
import 'package:demo7_pro/tabbar/tab_nav.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:demo7_pro/services/jpush.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();// main()方法想要使用async ,一定要调用它。

  await dotenv.load(fileName: ".env.development"); // 静态文件需要在pubspec.yaml里注册

  /// 初始化极光
  JPushService.init();// android sdk30可能会报getNetWorkType 安全错误，可以尝试修改build.gradle targetSdkVersion

  runApp(MaterialApp(
      title: '阿福首页',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TabNavigator(),
    ));

  /// 锁定竖屏
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  /// Android 端使用沉浸式状态栏（默认有黑色背景）
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
  }

}
