import 'package:flutter/material.dart';
import 'package:future_button/future_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;
import 'package:demo7_pro/utils/app.dart' show AppUtil;
import 'package:demo7_pro/dao/upload/upload.dart' show FileUpload;
import 'package:dio/dio.dart' show FormData;
import 'dart:io' show File;
import 'package:demo7_pro/utils/bottom_sheet.dart';
import "package:images_picker/images_picker.dart";

class ImgUpload extends StatefulWidget {
  final Widget child;
  final bool compress;

  final int minWidth;

  final int minHeight;

  final Function(List<String> url) onSuccessFn;



  final Function(List<dynamic> filesList) onChangeFn;

  final bool isMulti;

  final int maxLength;

  ImgUpload({
    Key key,
    this.child,
    this.isMulti = false,
    this.compress = false,
    this.minWidth = 1920,
    this.minHeight = 1080,
    this.maxLength=1,
    this.onSuccessFn,
    this.onChangeFn,
  }) : super(key: key);

  @override
  _ImgUploadState createState() => _ImgUploadState();
}

class _ImgUploadState extends State<ImgUpload> {
  ImagePicker _picker;

  @override
  void initState() {
    _picker = new ImagePicker();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // 水波纹按钮
      child: widget.child,
      onTap: handlePicker,
    );
  }

  void handlePicker() async {
    String value = await AppBottomSheet(
      context,
      actions: [
        AppActionSheetRow('拍照', value: 'camera'),
        AppActionSheetRow('从相册选择', value: 'photos'),
      ],
    ).withAndroid();

    if (value == null) return;

    if (value == 'photos') {
      _getImage(ImageSource.gallery, isMulit: widget.isMulti ?? false);
    } else {
      _getImage(ImageSource.camera, isMulit: false);
    }
  }

  Future<void> _getImage(
    ImageSource source, {
    isMulit = false,
  }) async {
    try {
      if (source == ImageSource.camera) {
        PermissionStatus cameraStatus = await Permission.camera.status;
        if (cameraStatus != PermissionStatus.granted) {
          cameraStatus = await Permission.camera.request();
          if (cameraStatus != PermissionStatus.granted)
            throw '需要使用相机权限，请前往设置授权!';
        }
      } else if (source == ImageSource.gallery) {
        if (Platform.isAndroid) {
          await [Permission.storage].request();
        }

        /// IOS 特有权限
        if (Platform.isIOS) {
          await [Permission.photos].request();
        }
      }
      List<dynamic> uploadFileList = [];
      if (isMulit) {
        // var pickedFileList = await _picker.pickMultiImage();
        List<Media> pickedFileList = await ImagesPicker.pick(
          language:Language.Chinese,
          count: widget.maxLength??1,
          pickType: PickType.image,
        );


        if (pickedFileList != null) {
          List a=[];
          pickedFileList.forEach((e){
            a.add(e.path);
          });

          Logger().i('已选择的多图,$a');
          uploadFileList.insertAll(0, pickedFileList);
        }
      } else {
        var pickedFile = await _picker.pickImage(
          source: source,
        );

        if (pickedFile != null) {
          uploadFileList.add(pickedFile);
        }
      }
      Logger().i('选好的文件，$uploadFileList');
      _imgUpload(uploadFileList);
    } catch (e) {
      Logger().e('$e');
      AppUtil.showToast(e);
    }
  }

  Future<List<String>> _imgUpload(List<dynamic> imgFileList) async {
    if (imgFileList.length <= 0) {
      return null;
    }
    if (widget.onChangeFn != null) {
      widget.onChangeFn(imgFileList);
    }

    try {
      AppUtil.showLoading();
      List<String> imgUrlList = [];
      for (var file in imgFileList) {
        FormData _file = await AppUtil.imageFileToFormData(
          'file',
          File(file.path),
          compress: widget.compress ?? false,
          minWidth: widget.minWidth ?? 1920,
          minHeight: widget.minHeight ?? 1080,
        );

        var url = await FileUpload.upload(_file);
        if (url != null || url != '') {
          imgUrlList.add(url);
        }
      }
      Logger().i('上传成功，返回：$imgUrlList');
      if (widget.onSuccessFn != null) {
        widget.onSuccessFn.call(imgUrlList);
      }
      return imgUrlList;
    } catch (e) {
      Logger().i('上传失败：$e');
      return null;
    } finally {
      AppUtil.hideLoading();
    }
  }
}
