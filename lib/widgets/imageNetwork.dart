import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ImageNetwork extends StatefulWidget{
  final String imageUrl;

  ImageNetwork({Key key,@required this.imageUrl});
  @override
  _ImageNetworkState createState()=>_ImageNetworkState();



}

class _ImageNetworkState extends State<ImageNetwork>{
  bool showErrorImage=false;

  Widget build (BuildContext context){
    return !showErrorImage?_buildImageWidget():new Image.asset('image/1.jpg');
  }

  Widget _buildImageWidget() {
    Image image = Image.network(widget.imageUrl);
    final ImageStream stream = image.image.resolve(ImageConfiguration.empty);
    stream.addListener(ImageStreamListener(
        listener,
        onError: (dynamic exception, StackTrace stackTrace) {
          setState(() {
            showErrorImage=true;
          });
          Logger().i('图片网络加载报错，替换为默认图片');
        }
    ));
    return image;
  }
  void listener(ImageInfo info, bool syncCall) {

  }
}
