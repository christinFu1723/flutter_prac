import 'dart:convert';
import 'dart:io';
// import 'package:demo7_pro/event_bus/app.dart';
// import 'package:demo7_pro/event_bus/supplier.dart';
import 'package:demo7_pro/utils/string.dart';
import 'package:logger/logger.dart';
import 'package:flutter/services.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:demo7_pro/utils/app.dart';
import 'package:demo7_pro/utils/event_bus.dart';
// import 'package:demo7_pro/event_bus/order.dart';
import 'package:demo7_pro/model/jpush_extras_model.dart';

/// 极光推送服务
class JPushService {
  static final JPush jPush = JPush();

  static String alias;

  /// 获取实例
  static Future<void> init() async {
    try {
      jPush.addEventHandler(
        /// 接收通知回调方法
        onReceiveNotification: handleOnReceiveNotification,

        /// 点击通知回调方法
        onOpenNotification: handleOnOpenNotification,

        /// 接收自定义消息回调方法，暂不处理
        // onReceiveMessage: handleOnReceiveNotification,
      );
    } on PlatformException {
      Logger().e('无法获取平台版本');
    } catch (error) {
      Logger().e(error);
    }

    try {
      jPush.setup(
        appKey: 'e92789a6b7eee44a0a9f3aea',
        channel: 'developer-default',
        production: true,
        debug: false,
      );

      if (Platform.isIOS) {
        jPush.applyPushAuthority(NotificationSettingsIOS(
          sound: true,
          alert: true,
          badge: true,
        ));
      }

      Logger().i('极光推送初始化完成');
    } catch (e) {
      AppUtil.showToast(e);
    }
  }

  /// 注册设备
  /// 否则出现 6012 错误
  static Future<String> getRegistrationID() async {
    String registrationID = await jPush.getRegistrationID();
    Logger().i('registrationID: $registrationID');
    return registrationID;
  }

  /// 启用极光推送
  /// 用户登录成功后，应该调用该方法启用极光推送
  static Future<void> start(String alias, List<String> tags) async {
    if (StringUtil.isEmpty(alias) || tags == null || tags.isEmpty) return;
    resumePush();
    await getRegistrationID();
    await Future.wait([
      setAlias(alias),
      setTags(tags),
    ]);
  }

  /// 清除极光推送
  /// 用户退出登录时，应该调用该方法清除极光推送状态
  static Future<void> clean() async {
    try {
      if (Platform.isIOS) {
        setBadge(0);
      }
      await AppUtil.sleep(100);
      jPush.stopPush();
      await AppUtil.sleep(100);
      jPush.clearAllNotifications();
      await AppUtil.sleep(100);
      jPush.deleteAlias();
      await AppUtil.sleep(100);
      jPush.cleanTags();
      await AppUtil.sleep(100);
    } catch (e) {
      AppUtil.showToast(e);
    }
  }

  /// 接收通知回调方法
  static Future<dynamic> handleOnReceiveNotification(
    Map<String, dynamic> message,
  ) async {
    try {
      /// 解析消息
      JPushExtrasModel extras = extrasDouble(message);

      // /// 服务商抢单通知
      // if (extras.type == 'grabbing') {
      //   EventBusUtil.instance.eventBus
      //       .fire(SupplierGrabbingOrderRefreshEvent());
      //   EventBusUtil.instance.eventBus.fire(GrabbingMessageEvent(extras));
      // }
      //
      // EventBusUtil.instance.eventBus.fire(MessageCountRefreshEvent());
    } catch (e) {
      throw e;
    }
  }

  /// 设置别名 Alias
  static Future<Map<dynamic, dynamic>> setAlias(String value) async {
    var set = await jPush.setAlias(value);
    alias = value;
    return set;
  }

  /// 移除别名
  static Future<void> deleteAlias() async {
    await jPush.deleteAlias();
  }

  /// 设置 Tag
  static Future<void> setTags(List<String> value) async {
    await jPush.setTags(value);
  }

  /// 清除 Tag
  static Future<void> cleanTags() async {
    await jPush.cleanTags();
  }

  /// 点击通知回调方法
  static Future<dynamic> handleOnOpenNotification(
    Map<String, dynamic> message,
  ) async {
    try {
      /// 清除状态栏对应的消息
      clearNotification(message['id']);

      /// 解析消息
      JPushExtrasModel extras = extrasDouble(message);

      /// 执行逻辑操作
      if (extras.type == 'grabbing') {
        // EventBusUtil.instance.eventBus.fire(
        //   OrderDetailEvent(extras.businessNo),
        // );
      }

      /// 提醒消息
      if (extras.type == 'service' && extras.messageType == 'remind') {
        // EventBusUtil.instance.eventBus.fire(
        //   MessageDetailEvent('remind', extras.messageId),
        // );
      }

      /// 服务通知
      if (extras.type == 'system' && extras.messageType == 'announce') {
        // EventBusUtil.instance.eventBus.fire(
        //   MessageDetailEvent('announce', extras.messageId),
        // );
      }
    } catch (e) {
      throw e;
    }
  }

  /// 解析消息内容
  static JPushExtrasModel extrasDouble(Map<String, dynamic> message) {
    if (message == null) return null;

    JPushExtrasModel extras;

    if (Platform.isAndroid) {
      extras = JPushExtrasModel.fromJson(
        json.decode(message['extras']['cn.jpush.android.EXTRA']),
      );
    }

    if (Platform.isIOS) {
      print(message['extras']);
      extras = JPushExtrasModel.fromJson(
          Map<String, dynamic>.from(message['extras']));
    }

    return extras;
  }

  /// 移除通知栏指定 ID 的消息
  /// 应用内操作数据时，需要同步清除状态栏对应的条目
  static void clearNotification(int id) {
    jPush.clearNotification(notificationId: id);
  }

  /// 清空通知栏消息
  static Future<void> clearAllNotifications() async {
    await jPush.clearAllNotifications();
  }

  /// 设置角标(不支持安卓)
  static Future<void> setBadge(int count) async {
    await jPush.setBadge(count);
  }

  /// 暂停接收通知
  static Future<void> stopPush() async {
    await jPush.stopPush();
  }

  /// 恢复接收通知
  static Future<void> resumePush() async {
    await jPush.resumePush();
  }

  /// 发送本地通知
  /// 一些需要强提醒的操作（如充值成功等）无需走极光推送，可以使用本地通知
  static Future<void> sendLocal(LocalNotification notification) async {
    await jPush.sendLocalNotification(notification);
  }
}
