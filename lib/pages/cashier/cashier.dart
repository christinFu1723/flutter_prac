import 'package:demo7_pro/config/theme.dart' show AppTheme;
import 'package:flutter/material.dart';
import 'package:demo7_pro/widgets/sliver_scaffold.dart' show AppSliverScaffold;
import 'package:demo7_pro/icons/sxb_icons.dart' show SxbIcons;
import 'package:logger/logger.dart' show Logger;
import 'package:demo7_pro/model/pay/wechat_pay.dart'
    show PaySignatureWechatModel;
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:tobias/tobias.dart' as tobias;
import 'dart:async';

class CashierPage extends StatefulWidget {
  @override
  _CashierState createState() => _CashierState();
}

class _CashierState extends State<CashierPage> {
  @override
  Widget build(BuildContext context) {
    return AppSliverScaffold(
      title: '测试支付',
      body: Container(
        child: Column(
          children: [
            payBtn(
                title: '支付宝',
                icon: SxbIcons.IconZhifubao,
                iconColor: AppTheme.primaryColor,
                tapFn: _goAliPay),
            payBtn(title: '微信', tapFn: _goWxPay)
          ],
        ),
      ),
    );
  }

  Widget payBtn(
      {String title = '',
      IconData icon = SxbIcons.IconWeixinzhifu,
      Color iconColor = AppTheme.sitSuccessColor,
      Function tapFn}) {
    return InkWell(
        child: Container(
          margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
          decoration: BoxDecoration(
              color: AppTheme.tabBarBackground,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(10.0, 5.0),
                    blurRadius: 15.0),
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(-10.0, -5.0),
                    blurRadius: 15.0)
              ]),
          child: Row(
            children: [
              Icon(
                icon,
                color: iconColor,
              ),
              Padding(padding: EdgeInsets.only(right: 30)),
              Text(title)
            ],
          ),
          padding: EdgeInsets.all(20),
        ),
        onTap: () {
          if (tapFn != null) {
            tapFn();
          }
        });
  }

  _goAliPay() async {
    Logger().i('支付宝支付');

    String orderInfo = 'alipay_root_cert_sn=687b59193f3f462dd5336e5abf83c5d8_02941eef3187dddf3d3b83462e1dfcf6&alipay_sdk=alipay-sdk-java-dynamicVersionNo&app_cert_sn=79e9adfc74f0764631b00396f8ae4755&app_id=2021002154662577&biz_content=%7B%22body%22%3A%22%E6%B4%A5W23336+%E8%A7%A3%E6%8A%BC+%E9%87%8D%E5%BA%86%22%2C%22out_trade_no%22%3A%22PZ2021092616252168043008%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%2C%22subject%22%3A%22%E6%B4%A5W23336+%E8%A7%A3%E6%8A%BC+%E9%87%8D%E5%BA%86%22%2C%22time_expire%22%3A%222021-09-26+16%3A53%3A53%22%2C%22timeout_express%22%3A%2230m%22%2C%22total_amount%22%3A%22220.00%22%7D&charset=utf-8&format=json&method=alipay.trade.app.pay&notify_url=https%3A%2F%2Fapi.dingdangchewu.com%2Falipay%2Fpay%2Fcallbacks&sign=FC4Y3vi56sFR4TMIzYsLsCsKuM0vinzqJFzWPUcQTeimn1cdnquQHHVSmx%2FoxAiNf%2FIjyVxs%2FY0qZnoCVsEf17wCNUeQXvU0HmunZY9yOrpuquyL1VZsaJAEmGnv%2Bkw3SbwFf4%2FvDYgHrDJk4%2FfDI%2Fap3KCOfvG1uCF77kyUMaotxmWcMKMAROzyemUefiW1%2BKTrpdlFhZBvWtkXx7RtisxVdblN35IBoPAZah7XIyO%2BvkwN';


    /// 唤起支付宝支付
    var results = await tobias.aliPay(
      orderInfo,
      evn: tobias.AliPayEvn.ONLINE,
    );



    if (results["resultStatus"] == "9000") {
      Logger().i('支付成功');
    } else {
      switch (results["resultStatus"]) {
        case '8000':
          throw '正在处理中';
          break;
        case '4000':
          throw '订单支付失败';
          break;
        case '6001':
          throw '用户取消支付';
          break;
        case '6002':
          throw '网络连接出错';
          break;
        default:
          throw '支付无效，请重新支付！';
          break;
      }
    }
  }

  _goWxPay() async {
    Logger().i('微信支付111');
    PaySignatureWechatModel signature = PaySignatureWechatModel(
      package: 'Sign=WXPay',
      appId: 'wxcbf4e33e0e9cedeb',
      sign:'dZ+ns+IHqcAmMolUw37PiPyniluOTmkqPpbW3df7iNA4wcnKACZbAoxhDyrAh60IrwUGu3GA6Qw3gcOvXIKnsF0xu+DJKP5XG9oncrocUtseG4sPWl6BdhG2CL50csArVP6T/7Ps98U7mIbCXHrvV5aEj1f6Q7DRm/3vuXbX+Y/YuN/AhkpxzgVhE5PRv3YndcRtnB7Me7csQHdF2x49fnolJRaTHxqrcGX+X+d0mjyB493JgC9B8mNQKEe+8ce6PIAosl34W1nLTW9QcmTh/LAj1WgNECgK3+UKecbeg0VM3WprALCTye4NKlyhIcCgNWHwXn7zgiKA79A9I+6F3Q==',
      prepayId: 'wx261858126424943dbba1cb2f32d03a0000',
      partnerId: '1609227127',
      nonceStr: 'ade6302c17f2ebe2feba3adc06c7a37b',
      timestamp: '1632653892',
    );
    await fluwx.registerWxApi(
      appId: signature.appId,
      universalLink: 'https://dingdangchewu.com/',
    );

    fluwx.weChatResponseEventHandler.listen((res) {
      if (mounted) {
        setState(() {});
      }
      if (res is fluwx.WeChatPaymentResponse) {
        Logger().i(res.errCode);
        /// 错误处理，文档详见：<https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=8_5>
        switch (res.errCode) {
          case 0:
            Logger().i('支付成功');
            break;
          case -1:


            throw '支付出现错误，请重新支付！';
            break;
          case -2:
            throw '用户取消支付';
            break;
          default:
            throw '支付无效，请重新支付！';
            break;
        }
      }
    });

    await fluwx.payWithWeChat(
      appId: signature.appId,
      partnerId: signature.partnerId,
      prepayId: signature.prepayId,
      packageValue: signature.package,
      nonceStr: signature.nonceStr,
      timeStamp: int.parse(signature.timestamp),
      sign: signature.sign,
    );
  }
}
