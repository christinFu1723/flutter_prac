import 'package:demo7_pro/utils/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:demo7_pro/widgets/common/img_upload.dart' show ImgUpload;
import 'package:image_picker/image_picker.dart' show XFile;
import 'package:demo7_pro/config/theme.dart' show AppTheme;
import 'package:logger/logger.dart';
import 'package:demo7_pro/widgets/common/img_preview.dart' show ImgPreview;

class ImgUploadDecorator extends StatefulWidget {
  final int maxLength;
  final List<String> initImgList;

  ImgUploadDecorator({Key key, this.maxLength = 9, this.initImgList})
      : super(key: key);

  @override
  _ImgUploadDecoratorState createState() => _ImgUploadDecoratorState();
}

class _ImgUploadDecoratorState extends State<ImgUploadDecorator> {
  List<String> imgList = [];

  @override
  void initState() {
    setState(() {
      this.imgList = widget.initImgList;
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.47, // 宽高比
          ),
          shrinkWrap: true,
          itemCount: showGridBlock.length,
          itemBuilder: (BuildContext context, int index) {
            return showGridBlock[index] == 'add'
                ? _addNewImg()
                : _ImgGridItem(showGridBlock[index], index);
          }),
    );
  }

  Widget _ImgGridItem(String url, int index) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              width: 1, color: AppTheme.borderColor.withOpacity(0.7)),
          borderRadius: BorderRadius.all(Radius.circular(3))),
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            child: Image.network(
              url,
              fit: BoxFit.fill,
            ),
            onTap: () {
              _openImgPreview(index, imgList);
            },
          ),
          Positioned(
              top: 5,
              right: 5,
              child: GestureDetector(
                child: Icon(
                  Icons.delete_forever,
                  color: AppTheme.sitDangerColor,
                ),
                onTap: () {
                  _deleteImg(index);
                },
              ))
        ],
      ),
    );
  }

  void _openImgPreview(int imgIndex, List<String> imgList) {
    AppUtil.push(
      context,
      ImgPreview(
        images: imgList,
        initIndex: imgIndex,
      ),
    );
  }

  void _deleteImg(index) {
    if (index < imgList.length) {
      setState(() {
        imgList.removeAt(index);
      });
    }
  }

  List<String> get showGridBlock {
    List<String> imgShowArr = [];
    imgShowArr.addAll(this.imgList);
    if (widget.maxLength > 0 && this.imgList.length < widget.maxLength) {
      imgShowArr.add('add'); // 如果最大限制存在，且当前渲染项小于最大限制
    } else if (widget.maxLength < 0 || widget.maxLength == null) {
      imgShowArr.add('add'); // 最大限制不存在，恒定显示
    }

    return imgShowArr;
  }

  int get pickerMaxLength{
    int maxNumb= widget.maxLength-this.imgList.length;
    if(maxNumb<=0){
      maxNumb=1;
    }
    return maxNumb;
  }

  Widget _addNewImg() {
    return ImgUpload(
      maxLength: pickerMaxLength,
      isMulti: true,
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_a_photo,
                color: AppTheme.placeholderColor,
              ),
              Padding(padding: EdgeInsets.only(top: 16)),
              Text(
                '营业执照副本',
                style: TextStyle(color: AppTheme.placeholderColor),
              )
            ],
          ),
        ),
        onSuccessFn: _onSuccessFn,
        onChangeFn: _onChange);
  }

  void _onSuccessFn(List<String> urlList) {
    setState(() {
      this.imgList.addAll(urlList);
    });
  }

  void _onChange(List<dynamic> filesList) {}
}
