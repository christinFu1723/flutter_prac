import 'package:vibrate/vibrate.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data' show Uint8List, ByteData;
import 'dart:io' show Platform, File;
import 'package:demo7_pro/utils/app.dart' show AppUtil;
import 'package:permission_handler/permission_handler.dart';

/// 保存图片到相册
///
/// 默认为下载网络图片，如需下载资源图片，需要指定 [isAsset] 为 `true`。
Future<void> saveImage(String imageUrl, {bool isAsset: false}) async {
  try {
    if (imageUrl == null) throw '保存失败，图片不存在！';

    /// 权限检测
    if (Platform.isIOS) {
      bool granted = await Permission.photos.request().isGranted;
      if (!granted) throw '请前往系统设置开启车管家相册访问权限！';
    } else {
      bool granted = await Permission.storage.request().isGranted;
      if (!granted) throw '请前往系统设置开启车管家相册访问权限！';
    }

    AppUtil.showLoading();

    /// 保存的图片数据
    Uint8List imageBytes;

    if (isAsset == true) {
      /// 保存资源图片
      ByteData bytes = await rootBundle.load(imageUrl);
      imageBytes = bytes.buffer.asUint8List();
    } else {
      /// 保存网络图片
      CachedNetworkImage image = CachedNetworkImage(imageUrl: imageUrl);
      DefaultCacheManager manager = image.cacheManager ?? DefaultCacheManager();
      Map<String, String> headers = image.httpHeaders;
      File file = await manager.getSingleFile(
        image.imageUrl,
        headers: headers,
      );
      imageBytes = await file.readAsBytes();
    }

    /// 保存图片
    final result = await ImageGallerySaver.saveImage(imageBytes);
    if (result == null || result == '') throw '图片保存失败';

    /// 震动反馈
    Vibrate.feedback(FeedbackType.selection);

    AppUtil.showToast("保存成功");
  } catch (e) {
    AppUtil.showToast(e);
  } finally {
    AppUtil.hideLoading();
  }
}
