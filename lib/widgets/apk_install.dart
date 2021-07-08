import 'dart:io';

import 'package:demo7_pro/config/theme.dart';
import 'package:demo7_pro/utils/app.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:filesize/filesize.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:logger/logger.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// 安装 apk 下载安装
/// 该组件需要用在 dialog 组件中
class ApkInstall extends StatefulWidget {
  /// apk 下载地址
  final String url;

  /// 下载完成回调
  final VoidCallback onSuccess;

  ApkInstall(this.url, {this.onSuccess});

  @override
  _ApkInstallState createState() => _ApkInstallState();
}

class _ApkInstallState extends State<ApkInstall> {
  /// 资源大小
  int totalSize;

  /// 已下载大小
  int downloadSize;

  double size;

  final GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();
    download();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(AppTheme.gutter),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: AppTheme.gutter * 2,
      ),
      child: IntrinsicHeight(
        child: Container(
          padding: EdgeInsets.all(AppTheme.gutter * 2),
          child: Column(
            children: [
              Container(
                child: Text(
                  '正在下载更新包，请稍后',
                  style: TextStyle(
                    color: AppTheme.textColor,
                    fontSize: AppTheme.fontSizeTitle,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: AppTheme.gutter * 1.5),
              progressBar,
              SizedBox(height: AppTheme.gutter * 1.5),
              Text(
                filesize(downloadSize ?? 0) + ' / ' + filesize(totalSize ?? 0),
                style: TextStyle(
                  color: AppTheme.textColor,
                  fontSize: AppTheme.fontSizeSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 进度条
  Widget get progressBar {
    return Stack(
      children: [
        /// 总长度
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: AppTheme.borderColor,
          ),
        ),

        /// 已下载进度
        Positioned(
          left: 0,
          top: 0,
          height: 8,
          width: (size ?? 0) * progress.toDouble(),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.secondColor,
            ),
          ),
        ),
      ],
    );
  }

  /// 下载资源文件
  Future<void> download() async {
    try {
      await AppUtil.sleep(300);

      /// 获取组件尺寸
      size = context.size.width - AppTheme.gutter * 8;
      if (!mounted) return;
      setState(() {});

      await AppUtil.sleep(300);

      /// 权限校验
      if (Platform.isAndroid) {
        PermissionStatus status = await Permission.storage.request();
        Logger().w(status);
        if (status != PermissionStatus.granted) {
          status = await Permission.storage.request();
          if (status != PermissionStatus.granted) throw '权限不足!';
        }
      }

      /// 获取缓存目录
      Directory appDocDir = await getExternalStorageDirectory();
      String appDocPath = appDocDir.path;
      String savePath = "$appDocPath/install.apk";

      Dio dio = Dio();

      /// 下载 apk
      await dio.downloadUri(
        Uri.parse(widget.url),
        savePath,
        onReceiveProgress: (int received, int total) {
          downloadSize = received;
          totalSize = total;

          if (!mounted) return;
          setState(() {});
        },
      );

      /// 获取包信息
      PackageInfo pkg = await PackageInfo.fromPlatform();

      /// 执行安装
      await InstallPlugin.installApk(savePath, pkg.packageName);

      /// 回调
      if (widget.onSuccess != null) {
        widget.onSuccess.call();
      }
    } catch (e) {
      AppUtil.showToast(e);
    }
  }

  /// 下载进度
  double get progress {
    if (totalSize == null || downloadSize == null) return 0;
    return (downloadSize / totalSize);
  }
}
