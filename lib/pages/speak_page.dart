import 'package:flutter/material.dart';

import 'package:demo7_pro/plugin/asr_manager/asr_manager.dart';
import 'package:demo7_pro/route/pages/search_page/index.dart'
    show SearchPageRoutes;
import 'package:demo7_pro/route/route_util.dart' show navTo;

class SpeakPage extends StatefulWidget {
  @override
  _SpeakPageState createState() => _SpeakPageState();
}

class _SpeakPageState extends State<SpeakPage>
    with SingleTickerProviderStateMixin {
  String speakTips = '长按说话';
  String speakResult = '';
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          //动画完成后重新播放
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          //动画被关闭了，开始动画
          controller.forward();
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(30),
      child: layout,
      //   Column(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: <Widget>[
      //     ClipRect(child:_topItem() ,),
      //     ClipRect(child: _bottomItem(),)
      //   ],
      // ) ,
    ));
  }

  Widget get layout {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _topItem(),
          _bottomItem(),
        ]);
  }

  _topItem() {
    return Column(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
            child: Text('你可以这样说',
                style: TextStyle(fontSize: 16, color: Colors.black54))),
        Text(
          '故宫门票\n北京一日游\n迪士尼乐园',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
        if (speakResult.isNotEmpty)
          Container(
            padding: EdgeInsets.all(20),
            color: Colors.pink,
            child: Text(
              speakResult,
              style: TextStyle(color: Colors.blue, height: 2),
            ),
          )
      ],
    );
  }

  _bottomItem() {
    return ClipRect(
      child: FractionallySizedBox(
          widthFactor: 1,
          child: Container(
            child: Stack(
              children: <Widget>[
                GestureDetector(
                  onTapDown: (e) {
                    _speakStart();
                  },
                  onTapUp: (e) {
                    _speakStop();
                  },
                  onTapCancel: () {
                    _speakCancel();
                  },
                  child: Center(
                      child: ClipRect(
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              speakTips,
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 12),
                            )),
                        Stack(
                          children: <Widget>[
                            Container(
                              //占坑，避免动画执行过程中父布局变化
                              height: MIC_SIZE,
                              width: MIC_SIZE,
                            ),
                            Center(
                              child: AnimatedMic(
                                animation: animation,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )),
                ),
                Positioned(
                    right: 0,
                    bottom: 20,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.black,
                      ),
                    ))
              ],
            ),
          )),
    );
  }

  _speakStart() {
    controller.forward();
    setState(() {
      speakTips = '-- 识别中 --';
    });

    AsrManager.start().then((text) {
      print("返回" + text);
      if (text != null && text.length > 0) {
        setState(() {
          speakResult = text;
        });
        //选关闭再跳转
        Navigator.pop(context);

        navTo(context, "${SearchPageRoutes.search}",
            arguments: {"keyword": speakResult});
      }
    }).catchError((e) {
      print('识别出错---' + e.toString());
    });
  }

  _speakStop() {
    setState(() {
      speakTips = '长按说话';
    });
    controller.reset();
    controller.stop();
    AsrManager.stop();
  }

  _speakCancel() {
    setState(() {
      speakTips = '长按说话';
    });
    controller.reset();
    controller.stop();

    AsrManager.cancel();
  }
}

/**
 * 编写动画
 */
const double MIC_SIZE = 80;

class AnimatedMic extends AnimatedWidget {
  /**
   * 透明度变化
   */
  static final _opacityTween = Tween<double>(begin: 1, end: 0.5);

  /**
   * 大小变化
   */
  static final _sizeTween = Tween<double>(begin: MIC_SIZE, end: MIC_SIZE - 20);

  AnimatedMic({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Opacity(
      opacity: _opacityTween.evaluate(animation),
      child: Container(
        height: _sizeTween.evaluate(animation),
        width: _sizeTween.evaluate(animation),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(MIC_SIZE / 2),
        ),
        child: Icon(
          Icons.mic,
          color: Colors.white,
        ),
      ),
    );
  }
}
