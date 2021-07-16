import 'package:flutter/material.dart';
import 'package:demo7_pro/widgets/webview.dart';
import 'package:demo7_pro/widgets/version.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _infoCard(),
                  _signOutBtn(),
                  Container(
                    margin: EdgeInsets.fromLTRB(0,130,0,75),
                    child: VersionTip(
                        logoTitle: '文立APP',
                        versionTips: '和我一起去炸鱼吧！可莉，想回家了！嘟嘟可大魔王，我来接受你的挑战',
                        version: '1.0.0'),
                  )
                ],
              ),
            )));
  }

  _signOutBtn() {
    return Container(
        margin: EdgeInsets.only(top: 34),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Color(0xFFED5757),
              //change background color of button
              onPrimary: Colors.white,
              minimumSize: Size(340, 48),
              textStyle: TextStyle(fontSize: 16),
              padding: EdgeInsets.fromLTRB(0, 5, 0, 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              )
          ),
          onPressed: () {},
          child: Text('注销登录'),
        ));
  }

  _infoCard() {
    return Container(
      margin: EdgeInsets.only(top: 84),
      child: Center(
        heightFactor: 1,
        child: Container(
          height: 257,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              _card(),
              Positioned(
                  top: 0,
                  left: MediaQuery.of(context).size.width / 2 - 130 / 2,
                  child: _headerIcon(
                      imgUrl: 'image/1.jpg',
                      width: 111,
                      height: 111,
                      borderWidth: 8,
                      borderColor: Color.fromARGB(30, 0, 179, 191))),
              Positioned(
                  top: 0,
                  left: MediaQuery.of(context).size.width / 2 + 120 / 2 - 32,
                  child: _headerIcon(
                      imgUrl: 'image/3.jpg',
                      width: 36,
                      height: 36,
                      borderWidth: 4,
                      borderColor: Color.fromARGB(255, 255, 255, 255))),
            ],
          ),
        ),
      ),
    );
  }

  _headerIcon(
      {@required String imgUrl,
      @required double width,
      @required double height,
      @required double borderWidth,
      @required Color borderColor}) {
    return Container(
        child: ClipOval(
          child: Image.asset(
            imgUrl,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: borderWidth,
            color: borderColor,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(65),
        ));
  }

  _card() {
    return Card(
        child: Container(
      width: 340,
      height: 203,
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.fromLTRB(0, 97, 0, 15),
              child: Text('名字',
                  style: TextStyle(fontSize: 18, color: Color(0xFF2A2A2A)))),
          Container(
            child: Text(
              '21863781637',
              style: TextStyle(fontSize: 14, color: Color(0xFF2A2A2A)),
            ),
          ),
        ],
      ),
    ));
  }
}
