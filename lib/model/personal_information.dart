class PersonalInfomationModel {
  String authority;
  String backSide;
  String certificationStatus;
  String certificationStatusStr;
  String citizenIdNumber;
  String dateOfBirth;
  String durationOfValidity;
  String ethnicity;
  String frontSide;
  String gender;
  String genderStr;
  String id;
  String mobile;
  String name;
  String portrait;
  String registerTime;
  String residentialAddress;
  String source;
  String sourceStr;
  String userId;
  String username;

  PersonalInfomationModel({
    this.authority,
    this.backSide,
    this.certificationStatus,
    this.certificationStatusStr,
    this.citizenIdNumber,
    this.dateOfBirth,
    this.durationOfValidity,
    this.ethnicity,
    this.frontSide,
    this.gender,
    this.genderStr,
    this.id,
    this.mobile,
    this.name,
    this.portrait,
    this.registerTime,
    this.residentialAddress,
    this.source,
    this.sourceStr,
    this.userId,
    this.username,
  });

  PersonalInfomationModel.fromJson(Map<String, dynamic> json) {
    authority = json['authority'];
    backSide = json['backSide'];
    certificationStatus = json['certificationStatus'];
    certificationStatusStr = json['certificationStatusStr'];
    citizenIdNumber = json['citizenIdNumber'];
    dateOfBirth = json['dateOfBirth'];
    durationOfValidity = json['durationOfValidity'];
    ethnicity = json['ethnicity'];
    frontSide = json['frontSide'];
    gender = json['gender'];
    genderStr = json['genderStr'];
    id = json['id'].toString();
    mobile = json['mobile'];
    name = json['name'];
    portrait = json['portrait'];
    registerTime = json['registerTime'];
    residentialAddress = json['residentialAddress'];
    source = json['source'];
    sourceStr = json['sourceStr'];
    userId = json['userId'].toString();
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['authority'] = this.authority;
    data['backSide'] = this.backSide;
    data['certificationStatus'] = this.certificationStatus;
    data['certificationStatusStr'] = this.certificationStatusStr;
    data['citizenIdNumber'] = this.citizenIdNumber;
    data['dateOfBirth'] = this.dateOfBirth;
    data['durationOfValidity'] = this.durationOfValidity;
    data['ethnicity'] = this.ethnicity;
    data['frontSide'] = this.frontSide;
    data['gender'] = this.gender;
    data['genderStr'] = this.genderStr;
    data['id'] = this.id;
    data['mobile'] = this.mobile;
    data['name'] = this.name;
    data['portrait'] = this.portrait;
    data['registerTime'] = this.registerTime;
    data['residentialAddress'] = this.residentialAddress;
    data['source'] = this.source;
    data['sourceStr'] = this.sourceStr;
    data['userId'] = this.userId;
    data['username'] = this.username;
    return data;
  }
}
