import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show SystemChrome, DeviceOrientation, SystemUiOverlayStyle;
import 'dart:io' show Platform;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:demo7_pro/services/jpush.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:demo7_pro/app.dart';
import 'package:demo7_pro/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // main()方法想要使用async ,一定要调用它。
  final botToastBuilder = BotToastInit();
  await dotenv.load(fileName: ".env"); // 静态文件需要在pubspec.yaml里注册

  /// 初始化极光
  JPushService.init();

  runApp(LoginPage());

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
