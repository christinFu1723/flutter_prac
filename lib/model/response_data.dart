class ResponseData {
  int code;
  dynamic data;
  String msg;
  String ts;

  ResponseData({this.code, this.data, this.msg, this.ts});

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      code: int.parse(json['code']) ?? 200,
      data: json['data'],
      msg: json['msg'] as String,
      ts: json['ts'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'data': data,
      'msg': msg,
      'ts': ts,
    };
  }
}
