import 'package:demo7_pro/store/app.dart';
import 'package:flutter/material.dart';
import 'package:demo7_pro/model/client_config_model.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:demo7_pro/config/http.dart';
import 'package:package_info/package_info.dart';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:demo7_pro/model/client_version_detail_model.dart';

import 'package:demo7_pro/services/personal.dart';
import 'package:demo7_pro/enums/user_type.dart';
import 'package:demo7_pro/utils/prefers.dart';
import 'package:device_info/device_info.dart';
import 'package:logger/logger.dart';
import 'package:demo7_pro/store/personal.dart';
import 'package:demo7_pro/utils/app.dart';

import 'package:demo7_pro/widgets/confirm.dart';
import 'package:demo7_pro/services/jpush.dart';
import 'package:demo7_pro/config/theme.dart';
import 'package:demo7_pro/widgets/apk_install.dart';
import 'package:install_plugin/install_plugin.dart';

import 'package:url_launcher/url_launcher.dart';


import 'package:demo7_pro/route/route_util.dart' show navTo;
import 'package:demo7_pro/route/pages/login_page/index.dart' show LoginPageRoutes;
import 'package:demo7_pro/utils/event_bus.dart';
import 'package:demo7_pro/eventBus/app.dart' show NeedReLoginEvent;
import 'package:demo7_pro/route/route_util.dart' show pop;


class AppService {
  /// 获取后端处，获取应用配置信息，并加入provider监听(特殊项目独有，不具备普遍性)
  static Future<ClientConfigModel> getClientConfig(BuildContext context) async {
    final AppStoreModel appStoreModel = Provider.of<AppStoreModel>(
      context,
      listen: false,
    );
    // ClientConfigModel config = await ApiBasic.getClientConfig();
    ClientConfigModel config;
    appStoreModel.setClientConfig(config);
    return config;
  }

  /// 应用启动时执行的逻辑
  ///
  /// 应用全局维护以下字段：
  /// UserAccountModel user： 已登录的用户信息
  /// String expire：已登录用户的登录身份失效时间
  /// String identity：已登录用户对应的身份信息
  /// List<String> keywords：已登录用户的历史搜索记录

  static Future<EnumUserType> start(BuildContext context) async {
    try {
      /// 权限初始化
      requestPermission();

      var token = await getToken();
      if(token==null){
        await clearPrefers(context);
        EventBusUtil.instance.eventBus.fire(NeedReLoginEvent());
        return null;
      }
      // /// 验证用户是否过期
      // DateTime expire = await getExpire();
      // if (expire == null ||
      //     DateTime.now().millisecondsSinceEpoch >=
      //         expire.millisecondsSinceEpoch) {
      //   // PersonalService.clearUserStore(context);
      //   await clearPrefers(context);
      //   // await PersonalService.setUserIdentity(context, identity);
      //   // 转到对应的主页
      //   EventBusUtil.instance.eventBus.fire(NeedReLoginEvent());
      //   // return identityTarget[identity];
      //   return null;
      // }



    } catch (e) {
      throw e;
    }
  }

  /// 清除用户登录信息
  static Future<void> clearPrefers(BuildContext context) async {
    await Future.wait(<Future<dynamic>>[
      PrefersUtil.remove("keywords"),
      PersonalService.resetUnreadCount(context),
      PersonalService.clearUser(),
      clearExpire(),
      clearToken(),
    ]);
  }

  /// 权限初始化
  /// 初次运行 App 时，请求获取必要的权限
  static Future<void> requestPermission() async {
    /// 通用权限(通知权限)
    await [
      Permission.notification,
    ].request();

    /// Android 特有权限
    if (Platform.isAndroid) {
      await [Permission.storage].request();
    }
  }

  /// 检测当前客户端状态，并动态调整接口配置
  /// 1、获取当前客户端版本号
  /// 2、获取生产环境的最新客户端版本
  /// 3、如果当前操作系统未 iOS，且，版本号大于生产环境版本号，则使用 UAT 环境接口；
  /// —— 我们认为这是一个未发布的测试版本；
  /// 4、默认使用对应环境的接口配置；
  static Future<bool> checkApiServe() async {
    /// 获取当前客户端环境标识
    String _env = dotenv.env['ENV'];

    if (!Platform.isIOS || _env != 'production') {
      HttpConfig.instance.setBaseUrlWithEnv(_env);
      return true;
    }

    /// 获取客户端版本号
    PackageInfo info = await PackageInfo.fromPlatform();
    int clientMark = int.parse(info.buildNumber);

    /// 始终取生产环境查询最新版本
    Dio _dio = Dio();
    var res = await _dio.get(
      'https://api.dingdangchewu.com/base/version/latest',
    );

    if (res == null || res.data == null || res.data['data'] == null)
      return true;

    ClientVersionDetailModel detail = ClientVersionDetailModel.fromJson(
      res.data['data'],
    );

    int lastMark = int.parse(detail.appMark);

    /// 如果当前客户端和生产环境的最小版本一致，则无需额外处理接口配置
    if (lastMark >= clientMark) return true;

    /// 如果当前客户端是一个较新的版本，更新接口为 UAT 接口
    HttpConfig.instance.setBaseUrlWithEnv('uat');

    print('/' * 60);
    print('当前客户端构建模式：$_env');
    print('当前客户端最新版本：$clientMark');
    print('当前已发布最新版本：$lastMark');
    print('接口已更新到 UAT 环境：${HttpConfig.instance.baseUrl}');
    print('/' * 60);

    return true;
  }

  /// 检查新版本
  static Future<void> checkClientVersion(BuildContext context,
      {bool tipsy}) async {
    try {
      AppUtil.showLoading();



      /// 获取版本信息
      PackageInfo info = await PackageInfo.fromPlatform();

      Logger().i('''
      pubspec.yaml文件信息。改动，重新编译后生效
      当前app名称：${info.appName}
      当前package包名：${info.packageName}
      当前版本信息：${info.version}
      当前buildNumber:${info.buildNumber}
      
      ''');

      // ClientVersionDetailModel detail = await ApiBasic.checkerClientVersion(
      //   appMark: info.buildNumber,
      // );
      ClientVersionDetailModel detail = ClientVersionDetailModel(
          appMark: 'sddsds',
          appUrl: 'https://songcw-dev.oss-cn-shanghai.aliyuncs.com/apk/app-release-2.0.apk',
          releaseTime: '2021-06-16',
          version: '3.0.0',
          versionDescription:'测试更新测试更新测试更新测试更新测试更新');

      if (detail == null) {
        if (tipsy == true) throw '已经是最新版本';
        return;
      }

      bool confirm = await showDialog(
        context: context,
        builder: (BuildContext context) => AppConfirm(
          title: '发现新版本',
          titleSub: '更新到新版本以获得更稳定的体验',
          confirmText: '立即更新',
          cancelText: '暂不',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/update_cover.png'),
              SizedBox(height: AppTheme.gutter),
              Text(
                [
                  '最新版本：v${detail.version ?? '?.?.?'}+${detail.appMark ?? '?'}',
                  '更新日期：${detail.releaseTime}',
                  '更新内容：\n${detail.versionDescription ?? '没有更新日志'}',
                ].join('\n'),
                style: AppConfirm.contentTextStyle.copyWith(
                  fontSize: AppTheme.fontSizeSmall,
                ),
              ),
            ],
          ),
        ),
      );

      if (confirm != true) return;

      if (Platform.isAndroid && detail.appUrl != null) {
        /// 如果是 apk，则直接下载并安装
        if (detail.appUrl.endsWith('.apk')) {
          showDialog(
            context: context,
            barrierDismissible: false, // 禁止关闭
            builder: (BuildContext context) {
              return ApkInstall(
                detail.appUrl,
                onSuccess: () {
                  pop(context);
                },
              );
            },
          );
        } else {
          /// URL 则直接用浏览器打开
          await launch(detail.appUrl);
        }

        return;
      }

      if (Platform.isIOS) {
        ClientConfigModel clientConfig = Provider.of<AppStoreModel>(
          context,
          listen: false,
        ).clientConfig??ClientConfigModel();
        clientConfig.appStoreUrl='https://apps.apple.com/cn/app/id1540207444';
        AppUtil.showToast('发现新版本，请前往 AppStore 更新');
        if (clientConfig?.appStoreUrl == null) return;
        InstallPlugin.gotoAppStore(clientConfig?.appStoreUrl);
      }
    } catch (e) {
      Logger().e(e);
      AppUtil.showToast(e);
    } finally {
      AppUtil.hideLoading();
    }
  }

  /// 需要登录后操作
  static void needLogin(BuildContext context, VoidCallback callback) {
    final personalStoreModel = Provider.of<PersonalStoreModel>(
      context,
      listen: false,
    );
    if (personalStoreModel.user == null) {

      navTo(context, "${LoginPageRoutes.login}",clearStack:true);
      return;
    }
    callback.call();
  }

  /// 需要先申请并通过服务商认证
  static void needSupplier(BuildContext context, VoidCallback callback) {
    /// 检查用户是否已加入了企业
    bool _supplier = false;

    if (_supplier == null) {
      AppUtil.showToast('您还不是服务商');
      return;
    }
    callback.call();
  }

  /// 获取客户端信息
  static Future<void> printDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    Logger().w(androidInfo.version.sdkInt);
  }

  /// 退出登录
  static Future<void> handleLoutOut(BuildContext context) async {
    try {
      bool confirm = await showDialog(
        context: context,
        builder: (BuildContext context) => AppConfirm(
          title: '操作提示',
          content: Text(
            '确定退出当前账户？',
            textAlign: TextAlign.center,
            style: AppConfirm.contentTextStyle,
          ),
        ),
      );

      if (confirm != true) return;

      AppUtil.showLoading();



      /// 清除极光推送别名
      await JPushService.clean();

      /// 调用后端接口
      // await ApiAuth.logout();

      /// 清除缓存
      await clearPrefers(context);

      /// 清除状态
      PersonalService.clearUserStore(context);


      AppUtil.showToast('已退出登录');

      /// 转到登录页
      navTo(context, "${LoginPageRoutes.login}",clearStack:true);
    } catch (e) {
      AppUtil.showToast(e);
    } finally {
      AppUtil.hideLoading();
    }
  }



  /// 缓存用户历史搜索记录
  static Future<void> setKeywords(String keyword) async {
    try {
      /// 获取已存在的 Keywords
      List<String> keywords = await getKeywords();

      if (keywords == null) {
        keywords = [];
      }

      keywords.add(keyword);

      Set<String> data = new Set();
      data.addAll(keywords);

      await PrefersUtil.set(
        "keywords",
        data.toList(),
        type: PrefsType.stringList,
      );
    } catch (e) {
      throw e;
    }
  }

  /// 获取缓存历史搜索记录
  static Future<List<String>> getKeywords() async {
    try {
      List<String> keywords = await PrefersUtil.get(
        "keywords",
        type: PrefsType.stringList,
      );

      if (keywords == null) return null;

      return keywords.reversed.toList();
    } catch (e) {
      throw e;
    }
  }

  /// 缓存用户登录身份标识
  static Future<void> setIdentity(String identity) async {
    await PrefersUtil.set("identity", identity);
  }

  /// 获取缓存登录身份标识
  static Future<String> getIdentity() async {
    try {
      var identity = await PrefersUtil.get("identity");
      if (identity == null) return null;
      return identity.toString();
    } catch (e) {
      throw e;
    }
  }

  /// 清除缓存登录身份标识
  static Future<void> clearIdentity() async {
    try {
      await PrefersUtil.remove("identity");
    } catch (e) {
      throw e;
    }
  }

  /// 获取缓存登录过期时间
  static Future<DateTime> getExpire() async {
    try {
      var expire = await PrefersUtil.get("expire", type: PrefsType.int);
      if (expire == null) return null;
      return DateTime.fromMillisecondsSinceEpoch(expire);
    } catch (e) {
      throw e;
    }
  }

  /// 清除缓存登录过期时间(清除sharedPreference的token过期时间)
  static Future<void> clearExpire() async {
    try {
      await PrefersUtil.remove("expire");
    } catch (e) {
      throw e;
    }
  }

  /// 设置接口token令牌，从sharedPreference
  static Future<void> setToken(String value) async {
    try {
      if (value == null) throw '无效的 token 参数';
      await PrefersUtil.set("token", value);
    } catch (e) {
      throw e;
    }
  }

  /// 获取接口token令牌，从sharedPreference
  static Future<String> getToken() async {
    try {
      var token = await PrefersUtil.get("token");
      if (token == null) return null;
      return token;
    } catch (e) {
      throw e;
    }
  }

  /// 删除接口token令牌，从sharedPreference
  static Future<void> clearToken() async {
    try {
      await PrefersUtil.remove("token");
    } catch (e) {
      throw e;
    }
  }
}
