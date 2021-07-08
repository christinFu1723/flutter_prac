import 'package:demo7_pro/model/personal_information.dart';
import 'dart:io';
import 'dart:convert';
import 'package:demo7_pro/utils/prefers.dart';
import 'package:provider/provider.dart';
import 'package:demo7_pro/store/personal.dart';
import 'package:flutter/material.dart';
import 'package:demo7_pro/services/app.dart';


class PersonalService {
  /// 获取缓存用户信息
  static Future<PersonalInfomationModel> getUser() async {
    String user = await PrefersUtil.get("user");
    if (user == null) return null;
    Map<String, dynamic> userJson = json.decode(user);
    return PersonalInfomationModel.fromJson(userJson);
  }

  /// 获取账户信息，仅获取用户基本信息
  static Future<PersonalInfomationModel> fetchUser(BuildContext context) async {
    /// 调用接口获取用户信息
    // PersonalInfomationModel user = await ApiPersonal.information();
    PersonalInfomationModel user;

    if (user == null) throw '用户信息获取失败，请重新登录';


    /// 缓存用户信息到本地，以便下次启动 APP 时用户状态仍然可用
    await PersonalService.setUser(user);

    /// 缓存用户信息到状态管理，以便后续的上下文可以去到用户信息
    final personalStoreModel = Provider.of<PersonalStoreModel>(
      context,
      listen: false,
    );
    personalStoreModel.setUser(user);

    /// 设置极光推送别名和 TAG
    String identity = personalStoreModel.identity.toUpperCase();
    // JPushService.start('$identity@${user.userId}', [identity]);

    return user;
  }

  /// 缓存用户信息
  static Future<bool> setUser(PersonalInfomationModel user) async {
    if (user == null) {
      await PrefersUtil.remove("user");
    } else {
      await PrefersUtil.set("user", json.encode(user.toJson()));
    }
    return true;
  }

  /// 重置未读消息数
  static Future<void> resetUnreadCount(BuildContext context) async {
    try {
      Provider.of<PersonalStoreModel>(
        context,
        listen: false,
      ).resetUnreadCount();
    } catch (e) {
      throw e;
    }
  }

  /// 设置用户登录身份
  ///
  /// 这将同时设置缓存标识和状态标识
  static Future<bool> setUserIdentity(
      BuildContext context,
      String identity,
      ) async {
    try {
      final personalStoreModel = Provider.of<PersonalStoreModel>(
        context,
        listen: false,
      );

      personalStoreModel.setIdentity(identity);

      await AppService.setIdentity(identity);

      return true;
    } catch (e) {
      throw e;
    }
  }


  /// 清除用户状态信息
  ///
  /// 用户退出登录、客户端端登录信息失效时，需要调用该方法清除缓存的用户数据
  static void clearUserStore(BuildContext context) {
    final personalStoreModel = Provider.of<PersonalStoreModel>(
      context,
      listen: false,
    );

    personalStoreModel.removeIdentity();
    personalStoreModel.removeUser();
    personalStoreModel.resetUnreadCount();
    // personalStoreModel.removeAddress();

    /// 清除服务商数据
    personalStoreModel.removeGrabbingNotify();
  }


  /// 清除缓存用户信息
  static Future<void> clearUser() async {
    try {
      await PrefersUtil.remove("user");
    } catch (e) {
      throw e;
    }
  }
}