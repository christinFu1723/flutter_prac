/// 微信支付参数
class PaySignatureWechatModel {
  String package;
  String appId;
  String sign;
  String prepayId;
  String partnerId;
  String nonceStr;
  String timestamp;

  PaySignatureWechatModel({
    this.package,
    this.appId,
    this.sign,
    this.prepayId,
    this.partnerId,
    this.nonceStr,
    this.timestamp,
  });

  factory PaySignatureWechatModel.fromJson(Map<String, dynamic> json) {
    return PaySignatureWechatModel(
      package: json['package'],
      appId: json['appid'],
      sign: json['paySign'],
      prepayId: json['prepayid'],
      partnerId: json['partnerid'],
      nonceStr: json['nonceStr'],
      timestamp: json['timeStamp'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['package'] = this.package;
    data['appid'] = this.appId;
    data['paySign'] = this.sign;
    data['prepayid'] = this.prepayId;
    data['partnerid'] = this.partnerId;
    data['nonceStr'] = this.nonceStr;
    data['timeStamp'] = this.timestamp;
    return data;
  }
}