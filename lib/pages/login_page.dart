import 'package:demo7_pro/app.dart';
import 'package:flutter/material.dart';
import 'package:demo7_pro/config/theme.dart';
import 'package:flutter/services.dart';
import 'package:demo7_pro/dto/loginForm.dart';
import 'package:demo7_pro/widgets/version.dart';
import 'package:future_button/future_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginForm form;
  TextEditingController phoneNumbController;

  @override
  void initState() {
    form = new LoginForm();
    phoneNumbController = TextEditingController();
    // phoneNumbController.text='ssss'; // 初始化输入框值
    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        title: '阿福首页',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(body: Builder(builder: (BuildContext context) {
          return loginPageBody(context);
        })));
  }

  Widget loginPageBody(BuildContext context) {
    return MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: AppTheme.backgroundDefaultColor,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _appInfoBlock(),
                _loginInForm(),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 125.5, 0, 30),
                  child: VersionTip(
                      logoTitle: '文立APP',
                      versionTips: '和我一起去炸鱼吧！可莉，想回家了！嘟嘟可大魔王，我来接受你的挑战',
                      version: '1.0.0'),
                )
              ],
            ),
          ),
        ));
  }

  _loginInForm() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(17, 58, 17, 22),
          child: _loginSpecialInput(Icons.person),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(17, 0, 17, 22),
          child: _loginSpecialInput(Icons.verified_user, showClear: false),
        )
      ],
    );
  }

  _loginSpecialInput(IconData iconData, {showClear = true}) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        child: Container(
          color: Color(0xffffffff),
          padding: EdgeInsets.fromLTRB(17, 0, 17, 0),
          child: Row(
            children: [
              Icon(
                iconData,
                color: AppTheme.placeholderColor,
                size: 20,
              ),
              Expanded(
                  child: TextField(
                controller: phoneNumbController,
                autofocus: true,
                textAlign: TextAlign.left,
                cursorColor: Theme.of(context).primaryColor,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(11),
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                decoration: InputDecoration(
                    fillColor: Colors.transparent,
                    filled: true,
                    border: InputBorder.none,
                    hintText: '请填写您的手机号',
                    hintStyle: TextStyle(
                        color: AppTheme.placeholderColor,
                        fontSize: AppTheme.fontSizeSecond)),
                onChanged: (String val) {
                  form.mobile = val;
                },
              )),
              showClear
                  ? (GestureDetector(
                      onTap: () {
                        form.mobile = '';
                        phoneNumbController.clear();
                      },
                      child: Icon(
                        Icons.close,
                        color: AppTheme.placeholderColor,
                        size: 16,
                      ),
                    ))
                  : (FutureCupertinoButton.filled(
                      // style: ElevatedButton.styleFrom(
                      //     primary: AppTheme.primaryColor,
                      //     onPrimary: Colors.white,
                      //     minimumSize: Size(60, 30),
                      //     textStyle: TextStyle(fontSize: 16),
                      //     padding: EdgeInsets.fromLTRB(13, 6, 13, 7),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(3),
                      //     )),
                      // progressIndicatorBuilder: (BuildContext context) {
                      //   return Icon(Icons.update);
                      // },
                      padding: EdgeInsets.fromLTRB(13, 0, 13, 0),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(3),
                      // ),
                      // color: AppTheme.primaryColor,
                      // textColor: Colors.white,
                      onPressed: () async {
                        await Future.delayed(Duration(seconds: 60));
                      },
                      child: Text(
                        '获取短信验证码',
                        style: TextStyle(
                            fontSize: AppTheme.fontSizeSmall,
                            color: Colors.white),
                      ),
                    ))
            ],
          ),
        ));
  }

  _appInfoBlock() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 58, 0, 33),
          child: Icon(
            Icons.flight,
            color: AppTheme.primaryColor,
            size: 60,
          ),
        ),
        Text(
          '文立测试APP',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Padding(padding: EdgeInsets.only(top: 6)),
        Text(
          'DingDang Customer Relationship Management',
          style: TextStyle(
            fontSize: AppTheme.fontSizeSmall,
            fontWeight: FontWeight.bold,
            color: AppTheme.lightTextColor,
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
        Text(
          '高效 · 安全 · 合规',
          style: TextStyle(
              fontSize: AppTheme.fontSizeSecond, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
