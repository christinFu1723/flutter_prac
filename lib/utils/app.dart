import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:demo7_pro/utils/oss_image.dart';
import 'package:demo7_pro/utils/string.dart';
import 'package:demo7_pro/config/theme.dart';

// 应用基础操作辅助
class AppUtil {
  /// 路由切换动画
  static Route createRoute(Widget page) {
    return PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          Animatable<double> tween = Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeOutExpo));
          return ScaleTransition(
            scale: animation.drive(tween),
            child: child,
          );
        });
  }

  /// 获取 uuid
  static Future<String> getUUID() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      String uuid;

      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        uuid = androidInfo?.androidId;
      }

      if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        uuid = iosInfo?.identifierForVendor;
      }

      if (uuid == null) throw '无法获取设备唯一标识';

      return uuid;
    } catch (e) {
      throw e;
    }
  }

  /// 隐藏 Loading 元素
  ///
  /// .e.g `AppUtil.hideLoading();`
  static void hideLoading() {
    BotToast.closeAllLoading();
  }

  /// 图片文件转 Dio FromData
  ///
  /// 使用了 [flutter_image_compress]<https://pub.flutter-io.cn/packages/flutter_image_compress> 做图片压缩；
  ///
  /// .e.g 不执行压缩 `imageFileToFormData('file', File)`
  /// .e.g 执行压缩 `imageFileToFormData('file', File, compress: true)`
  /// .e.g 更自由的压缩控制 `imageFileToFormData('file', File, compress: true, quality: 80)`
  static Future<FormData> imageFileToFormData(
    String feild,
    File file, {
    bool compress,
    int minWidth = 1920,
    int minHeight = 1080,
    int inSampleSize = 1,
    int quality = 95,
    int rotate = 0,
    bool autoCorrectionAngle = true,
    CompressFormat format = CompressFormat.png,
    bool keepExif = false,
  }) async {
    if (feild == null) throw '缺少图片接收参数';
    if (file == null) throw '无效的图片，请重新选择';

    MultipartFile source;

    if (compress == true) {
      var image = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minWidth: minWidth,
        minHeight: minHeight,
        inSampleSize: inSampleSize,
        quality: quality,
        rotate: rotate,
        autoCorrectionAngle: autoCorrectionAngle,
        format: format,
        keepExif: keepExif,
      );

      source = MultipartFile.fromBytes(image, filename: file.path);
    } else {
      source = await MultipartFile.fromFile(file.path, filename: file.path);
    }

    return FormData.fromMap({'$feild': source});
  }

  /// 阿里云 OSS 图片
  static String ossImage(
    String image, {
    OSSImageProcessPartResize resize,
    OSSImageProcessPartCrop crop,
    OSSImageProcessPartWatermark watermark,
  }) {
    if (image == null ||
        new RegExp(r'^(http|https)').hasMatch(image) == false ||
        new RegExp(r'(jpg|jpeg|png|webp)$').hasMatch(image) == false)
      return image;

    /// 未传入任何配置
    if (resize == null && crop == null && watermark == null) return image;

    List<String> url = ['$image?x-oss-process='];

    List<String> parts = [];

    if (resize != null) {
      parts.add(resize.part);
    }

    if (watermark != null) {
      parts.add(watermark.part);
    }

    if (parts.isNotEmpty) {
      url.add(parts.join(','));
    }

    String re = url.join('');

    return re;
  }

  /// 页面返回
  ///
  /// #### 基础用法
  /// `AppUtil.pop(context);`
  /// #### 接收参数
  /// `AppUtil.pop(context, result: 'Something');`
  /// #### 接收参数
  /// `AppUtil.pop(context, result: ['one', 'two']);`
  static void pop(BuildContext context, {dynamic result}) {
    Navigator.of(context).pop(result);
  }

  static Future<dynamic> popUntil(
    BuildContext context,
    RoutePredicate predicate,
  ) async {
    try {
      Navigator.popUntil(context, predicate);
    } catch (e) {
      throw Exception(e);
    }
  }

  /// 页面路由切换
  ///
  /// #### 基础用法
  /// `AppUtil.push(context, DemoPage());`
  /// #### 传递参数
  /// `AppUtil.push(context, DetailPage(id: 'Hello'));`
  static Future<dynamic> push(BuildContext context, Widget page,
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

  /// 页面路由切换，并清除之前的路由栈
  ///
  /// #### 基础用法
  /// `AppUtil.pushAndRemoveUntil(context, DemoPage());`
  /// #### 传递参数
  /// `AppUtil.pushAndRemoveUntil(context, DemoPage(id: 'Hello'));`
  static Future<dynamic> pushAndRemoveUntil(
    BuildContext context,
    Widget page,
  ) async {
    try {
      final result = await Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (_) => page,
        ),
        (route) => route == null,
      );
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  /// 页面路由切换并替换当前路由
  /// 假设页面流程是：主页 - 我的 - 登录
  /// 登录页 pushReplacement 到 成功页
  /// 此时的路由是：主页 - 我的 - 成功
  ///
  /// #### 基础用法
  /// `AppUtil.pushReplacement(context, DemoPage());`
  static Future<dynamic> pushReplacement(
      BuildContext context, Widget page) async {
    final result = await Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (_) => page),
    );
    return result;
  }

  /// 显示统一的 Loading 加载元素
  ///
  /// .e.g `AppUtil.showLoading();`
  static void showLoading() {
    BotToast.showCustomLoading(
      toastBuilder: (CancelFunc cancelFunc) {
        return SpinKitRipple(
          color: AppTheme.secondColor,
          size: 40.0,
        );
      },
      backgroundColor: Colors.transparent,
    );
  }

  /// 弹出固定格式的 BotToast 提示框
  ///
  /// .e.g `AppUtil.showToast('Hello');`
  static void showToast(dynamic message, {VoidCallback onClose}) {
    if (message == null) return;

    /// 异常错误主动上报
    /// 很显然，这只针对部分错误信息进行上报
    // if (message is Error) {
    //   TraceService.report(message);
    // }

    String text;

    if (message is String) {
      text = message;
    } else {
      text = message?.toString();
    }

    if (StringUtil.isEmpty(text)) {
      text = "请重试";
    }

    BotToast.showText(
      align: Alignment.center,
      text: text,
      borderRadius: BorderRadius.circular(6),
      contentColor: Colors.black,
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      onClose: onClose,
    );
  }

  /// 暂停指定时间（毫秒）
  ///
  /// #### 基础用法
  /// `AppUtil.sleep(3000);`
  static Future<void> sleep(int duration) async =>
      await Future.delayed(Duration(milliseconds: duration));
}
