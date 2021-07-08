class ClientVersionDetailModel {
  String appMark;
  String appUrl;
  String releaseTime;
  String version;
  String versionDescription;

  ClientVersionDetailModel(
      {this.appMark,
      this.appUrl,
      this.releaseTime,
      this.version,
      this.versionDescription});

  factory ClientVersionDetailModel.fromJson(Map<String, dynamic> json) {
    return ClientVersionDetailModel(
      appMark: json['appMark'].toString(),
      appUrl: json['appUrl'],
      releaseTime: json['releaseTime'],
      version: json['version'],
      versionDescription: json['versionDescription'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appMark'] = this.appMark;
    data['appUrl'] = this.appUrl;
    data['releaseTime'] = this.releaseTime;
    data['version'] = this.version;
    data['versionDescription'] = this.versionDescription;
    return data;
  }
}
