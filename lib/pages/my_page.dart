import 'package:flutter/material.dart';
import 'package:demo7_pro/widgets/webview.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Widget build(BuildContext context) {
    return Scaffold(
        body:MediaQuery.removePadding(
        removeTop:true,
        context: context,
        child:WebView(
            url:'https://m.ctrip.com/webapp/myctrip/',
            hideAppBar: true,
            backForbid: true,
          )
        )
    );
  }
}
