/// 极光推送消息体
class JPushExtrasModel {
  String id;
  String type;
  String messageType;
  String messageId;
  String businessName;
  String businessCode;
  String businessNo;
  String cityCode;
  String cityName;
  String plate;
  String provinceCode;
  String provinceName;
  String orderNo;
  String operatorsId;

  JPushExtrasModel({
    this.id,
    this.type,
    this.messageType,
    this.messageId,
    this.businessName,
    this.businessCode,
    this.businessNo,
    this.cityCode,
    this.cityName,
    this.plate,
    this.provinceCode,
    this.provinceName,
    this.orderNo,
    this.operatorsId,
  });

  factory JPushExtrasModel.fromJson(Map<String, dynamic> json) {
    return JPushExtrasModel(
      id: json['id'].toString(),
      type: json['type'],
      messageType: json['messageType'],
      messageId: json['messageId'].toString(),
      businessName: json['businessName'],
      businessCode: json['businessCode'].toString(),
      businessNo: json['businessNo'].toString(),
      cityCode: json['cityCode'].toString(),
      cityName: json['cityName'],
      plate: json['plate'],
      provinceCode: json['provinceCode'].toString(),
      provinceName: json['provinceName'],
      orderNo: json['orderNo'].toString(),
      operatorsId: json['provinceName'].toString(),
    );
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['messageType'] = this.messageType;
    data['messageId'] = this.messageId;
    data['businessName'] = this.businessName;
    data['businessCode'] = this.businessCode;
    data['businessNo'] = this.businessNo;
    data['cityCode'] = this.cityCode;
    data['cityName'] = this.cityName;
    data['plate'] = this.plate;
    data['provinceCode'] = this.provinceCode;
    data['provinceName'] = this.provinceName;
    data['orderNo'] = this.orderNo;
    data['operatorsId'] = this.operatorsId;
    return data;
  }
}
