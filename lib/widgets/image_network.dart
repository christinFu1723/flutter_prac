import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ImageNetwork extends StatefulWidget{
  final String imageUrl;
  final BoxFit fit;
  final double width;
  final double height;
  final AlignmentGeometry alignment;

  ImageNetwork({Key key,@required this.imageUrl,this.fit,this.width,this.height,this.alignment});
  @override
  _ImageNetworkState createState()=>_ImageNetworkState();



}

class _ImageNetworkState extends State<ImageNetwork>{
  bool showErrorImage=false;
  ImageStream stream;
  ImageStreamListener imgListener;

  Widget build (BuildContext context){
    return _buildImageWidget();
  }


  @override
  initState(){
      super.initState();
      Image image = Image.network(
          widget.imageUrl,
          fit:widget.fit,
          width: widget.width,
          height: widget.height,
          alignment: widget.alignment??Alignment.center
      );

      stream = image.image.resolve(ImageConfiguration.empty);
      if(!showErrorImage){

        imgListener = ImageStreamListener(
            listener,
            onError: (dynamic exception, StackTrace stackTrace) {
              setState(() {
                showErrorImage=true;
              });

            }
        );
        stream.addListener(imgListener);
      }

  }

  @override
  dispose(){
    if(stream!=null&&imgListener!=null){
      stream.removeListener(imgListener);
    }

    super.dispose();
  }

  Widget _buildImageWidget() {
    Image image = Image.network(
        widget.imageUrl,
        fit:widget.fit,
        width: widget.width,
        height: widget.height,
        alignment: widget.alignment??Alignment.center
    );
    Image assetImg =  new Image.asset('image/1.jpg',
        fit:widget.fit,
        width: widget.width,
        height: widget.height,
        alignment:  widget.alignment??Alignment.center
    );


    return !showErrorImage?image:assetImg;
  }
  void listener(ImageInfo info, bool syncCall) {

  }
}
