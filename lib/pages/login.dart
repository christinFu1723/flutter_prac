import 'package:flutter/material.dart';
import 'package:demo7_pro/widgets/webview.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
