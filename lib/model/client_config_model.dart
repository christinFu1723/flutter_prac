class ClientConfigModel {
  String bankAccountAuthorizationDownloadAddress;
  String customerServiceTelephoneNumbers;
  String h5UniversalAddress;
  String officialAccountName;
  String officialAccountTwoDimensionalCode;
  String officialWebsiteAddress;
  String privacyProtocolAddress;
  String registrationAgreementAddress;
  String userManualAddress;
  String appStoreUrl;

  ClientConfigModel({
    this.bankAccountAuthorizationDownloadAddress,
    this.customerServiceTelephoneNumbers,
    this.h5UniversalAddress,
    this.officialAccountName,
    this.officialAccountTwoDimensionalCode,
    this.officialWebsiteAddress,
    this.privacyProtocolAddress,
    this.registrationAgreementAddress,
    this.userManualAddress,
    this.appStoreUrl,
  });

  factory ClientConfigModel.fromJson(Map<String, dynamic> json) {
    return ClientConfigModel(
      bankAccountAuthorizationDownloadAddress:
          json['bankAccountAuthorizationDownloadAddress'],
      customerServiceTelephoneNumbers: json['customerServiceTelephoneNumbers'],
      h5UniversalAddress: json['h5UniversalAddress'],
      officialAccountName: json['officialAccountName'],
      officialAccountTwoDimensionalCode:
          json['officialAccountTwoDimensionalCode'],
      officialWebsiteAddress: json['officialWebsiteAddress'],
      privacyProtocolAddress: json['privacyProtocolAddress'],
      registrationAgreementAddress: json['registrationAgreementAddress'],
      userManualAddress: json['userManualAddress'],
      appStoreUrl: json['appStoreUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bankAccountAuthorizationDownloadAddress'] =
        this.bankAccountAuthorizationDownloadAddress;
    data['customerServiceTelephoneNumbers'] =
        this.customerServiceTelephoneNumbers;
    data['h5UniversalAddress'] = this.h5UniversalAddress;
    data['officialAccountName'] = this.officialAccountName;
    data['officialAccountTwoDimensionalCode'] =
        this.officialAccountTwoDimensionalCode;
    data['officialWebsiteAddress'] = this.officialWebsiteAddress;
    data['privacyProtocolAddress'] = this.privacyProtocolAddress;
    data['registrationAgreementAddress'] = this.registrationAgreementAddress;
    data['userManualAddress'] = this.userManualAddress;
    data['appStoreUrl'] = this.appStoreUrl;
    return data;
  }
}
