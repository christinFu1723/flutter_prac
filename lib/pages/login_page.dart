import 'package:demo7_pro/services/app.dart';
import 'package:flutter/material.dart';
import 'package:demo7_pro/config/theme.dart';
import 'package:flutter/services.dart';
import 'package:demo7_pro/dto/login_form.dart';
import 'package:demo7_pro/widgets/version.dart';

import 'package:logger/logger.dart';
import 'dart:async';
import 'package:demo7_pro/widgets/swiper_button.dart';
import 'package:demo7_pro/utils/app.dart';
import 'package:demo7_pro/utils/validate.dart';
import 'package:demo7_pro/dao/login/login.dart';
import 'package:demo7_pro/dao/login/sms.dart';
import 'package:demo7_pro/utils/string.dart';
import 'package:demo7_pro/utils/prefers.dart';
import 'package:demo7_pro/tabbar/tab_nav.dart';
import 'dart:convert';
import 'package:demo7_pro/route/routes.dart' show Routes;
import 'package:demo7_pro/route/route_util.dart' show navTo;
import 'package:demo7_pro/utils/data_line/mult_data_line.dart';
import 'dart:math';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with MultDataLine {
  LoginForm form;
  TextEditingController phoneNumbController;
  TextEditingController smsController;
  Timer smsCountDown; //  验证码倒计时
  int smsCountDownNumb; // 验证码倒计时展示number

  FocusNode focusNodeMobile = FocusNode();
  FocusNode focusNodeVerifyCode = FocusNode();

  bool pending = false; // loading
  String loginSmsCount = 'login_sms_count';

  @override
  void initState() {
    form = new LoginForm();
    phoneNumbController = TextEditingController();
    smsController = TextEditingController();

    focusNodeMobile.requestFocus();
    var random = new DateTime.now().millisecondsSinceEpoch.toInt() ~/ (new Random().nextInt(100)+1);
    getLine(loginSmsCount)
        .setData(random); // 初始化



    super.initState();
  }

  @override
  void dispose() {
    focusNodeMobile?.dispose();
    focusNodeVerifyCode?.dispose();
    smsController.dispose();
    phoneNumbController.dispose();
    if (smsCountDown != null) {
      smsCountDown.cancel();
    }

    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (BuildContext context) {
      return loginPageBody(context);
    }));
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
                _swiperButtonCtn(),
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

  Widget _swiperButtonCtn() {
    return Padding(
      padding: EdgeInsets.fromLTRB(60, 58, 60, 22),
      child: SwiperButton(
        size: 40,
        placeholder: '滑动进入下一步',
        onSwiperStart: () {
          // 手机号输入失去焦点
          focusNodeMobile.unfocus();
        },
        onSwiperValidate: handleLogin,
      ),
    );
  }

  Widget _loginInForm() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(17, 58, 17, 22),
          child: _loginSpecialInput(Icons.person,
              hint: '请填写您的手机号',
              maxLength: 11,
              controller: phoneNumbController, onChange: (val) {
            form.mobile = val;
          }, onClear: () {
            form.mobile = '';
            phoneNumbController.clear();
          }),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(17, 0, 17, 22),
          child: _loginSpecialInput(Icons.verified_user,
              showClear: true,
              showSmsBtn: true,
              maxLength: 6,
              hint: '请填写手机验证码',
              controller: smsController, onChange: (val) {
            form.sms = val;
          }, onClear: () {
            form.sms = '';
            smsController.clear();
          }),
        )
      ],
    );
  }

  Widget _loginSpecialInput(IconData iconData,
      {@required TextEditingController controller,
      @required Function onChange,
      @required Function onClear,
      showClear = true,
      showSmsBtn = false,
      maxLength = 10,
      hint = '请填写'}) {
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
                controller: controller,
                textAlign: TextAlign.left,
                cursorColor: Theme.of(context).primaryColor,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(maxLength),
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                decoration: InputDecoration(
                    fillColor: Colors.transparent,
                    filled: true,
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: TextStyle(
                        color: AppTheme.placeholderColor,
                        fontSize: AppTheme.fontSizeSecond)),
                onChanged: (String val) {
                  onChange(val);
                },
              )),
              showClear
                  ? (GestureDetector(
                      onTap: () {
                        onClear();
                      },
                      child: Icon(
                        Icons.close,
                        color: AppTheme.placeholderColor,
                        size: 16,
                      ),
                    ))
                  : Container(),
              showSmsBtn ? _smsButton() : Container()
            ],
          ),
        ));
  }

  Widget _smsButton() {
    return Padding(
        padding: EdgeInsets.only(left: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: !(smsCountDownNumb == null ||
                      smsCountDownNumb >= 0 && smsCountDownNumb <= 10)
                  ? AppTheme.lightTextColor
                  : AppTheme.primaryColor,
              onPrimary: Colors.white,
              minimumSize: Size(60, 30),
              textStyle: TextStyle(fontSize: 16),
              padding: EdgeInsets.fromLTRB(13, 6, 13, 7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              )),
          onPressed: () {
            _requestAuthCode();
          },
          child: _buttonLoadingChild(),
        ));
  }

  Widget _buttonLoadingChild() {

    return getLine(loginSmsCount)
        .addObserver((context, data) => data >= 0 && data <= 10
            ? (Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: SizedBox(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                      width: AppTheme.fontSizeSmall,
                      height: AppTheme.fontSizeSmall,
                    ),
                  ),
                  Text(
                    '$data s',
                    style: TextStyle(
                        fontSize: AppTheme.fontSizeSmall, color: Colors.white),
                  )
                ],
              ))
            : (Text(
                '获取短信验证码',
                style: TextStyle(
                    fontSize: AppTheme.fontSizeSmall, color: Colors.white),
              )));
  }

  Widget _appInfoBlock() {
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

  /// 手机号输入完成回调
  Future<bool> handleLogin() async {
    try {
      focusNodeMobile.unfocus();

      /// 手机号验证
      if (StringUtil.isEmpty(form.mobile)) throw '请填写手机号';
      if (!ValidateUtil.isMobile(form.mobile)) throw '请填写正确的手机号';

      /// 验证码验证
      if (StringUtil.isEmpty(form.sms)) throw '请填写验证码';
      // if (!ValidateUtil.isSMSCodeWithLength(form.sms, 6)) throw '请填写正确的验证码';

      AppUtil.showLoading();

      var loginInMap = await LoginIn.fetch(form);
      var loginInJson = loginInMap['loginInJson'];
      var loginInResp = loginInMap['loginInResp'];

      if (loginInResp['code'] == 500 || loginInResp['code'] == 404) {
        throw loginInResp['message'];
      }
      if (loginInJson != null &&
          loginInJson['tokenInfo'] != null &&
          loginInJson['tokenInfo']['access_token'] != null) {
        await AppService.setToken(
            'Bearer ${loginInJson['tokenInfo']['access_token']}');
        await PrefersUtil.set("userInfo", json.encode(loginInJson));
        navTo(context, '${Routes.root}', replace: true);
      }
      return true;
    } catch (e) {
      // swiperButtonKey?.currentState?.reset();
      focusNodeMobile.requestFocus();
      AppUtil.showToast(e);
      Logger().e(e);
      return false;
    } finally {
      AppUtil.hideLoading();
    }
  }

  void _requestAuthCode() async {
    Logger().i('smsCountDownNumb$smsCountDownNumb');
    if (smsCountDownNumb != null &&
        smsCountDownNumb > 0 &&
        smsCountDownNumb <= 10) {
      return;
    }
    AppUtil.showLoading();
    try {
      /// 手机号验证
      if (StringUtil.isEmpty(form.mobile)) throw '请填写手机号';
      if (!ValidateUtil.isMobile(form.mobile)) throw '请填写正确的手机号';
      await SMSRequest.fetch(form.mobile);
      AppUtil.showToast('短信验证码发送成功');
      _initTimer();
    } catch (e) {
      AppUtil.showToast(e);
    } finally {
      AppUtil.hideLoading();
    }
  }

  void _initTimer() {
    if (smsCountDownNumb != null &&
        smsCountDownNumb > 0 &&
        smsCountDownNumb <= 10) {
      return;
    }
    DateTime endAt = DateTime.now().add(Duration(seconds: 10));

    smsCountDownNumb = 10;
    getLine(loginSmsCount).setData(smsCountDownNumb);

    smsCountDown = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        smsCountDown.cancel();
        return;
      }
      if (smsCountDownNumb <= 0) {
        timer.cancel();
        smsCountDown.cancel();
        if (!mounted) return;

        getLine(loginSmsCount)
            .setData(new DateTime.now().millisecondsSinceEpoch);
        return;
      }

      smsCountDownNumb = ((endAt.millisecondsSinceEpoch -
                  DateTime.now().millisecondsSinceEpoch) /
              1000)
          .ceil(); // 除法取整
      getLine(loginSmsCount).setData(smsCountDownNumb);
    });
  }
}
