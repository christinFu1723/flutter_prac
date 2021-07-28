import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:demo7_pro/config/theme.dart' show AppTheme;

class ImgPreview extends StatefulWidget{
  final List<String> images;
  final int initIndex;

  ImgPreview({Key key,this.images,this.initIndex}):super(key:key);

  @override
  _ImgPreviewState createState()=>_ImgPreviewState();
}

class _ImgPreviewState extends State<ImgPreview>{
  /// 翻页控制器
  PageController _pageController;

  @override
  void initState(){
    _pageController = PageController(
      initialPage:widget.initIndex
    );
    super.initState();
  }

  @override
  void dispose(){
    _pageController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context){
    return Container(child:
    PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(widget.images[index]),
          initialScale: PhotoViewComputedScale.contained * 0.8,
          heroAttributes: PhotoViewHeroAttributes(tag: '$index-${ widget.images[index]}'),
        );
      },
      itemCount: widget.images.length,
      loadingBuilder: (context, event) => Center(
        child: Container(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / event.expectedTotalBytes,
          ),
        ),
      ),
      backgroundDecoration: BoxDecoration(
        color: Colors.black
      ),
      pageController: _pageController,
      onPageChanged: _onPageChanged,
    )
    );
  }
  _onPageChanged(int index){
    // current = index;
    // setState(() {});
  }
}