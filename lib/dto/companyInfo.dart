/// 创建企业表单
class CompanyInfo {
  String organizeName = '';
  String organizeSocialCode = '';
  String legalName = '';
  String legalIdCardNo = '';
  String legalMobile = '';
  String organizeRegisteredCapital = '';
  String organizeRegisteredTime = '';
  String organizeAddress = '';
  String contact = '';
  String contactMobile = '';
  String contactAddress = '';

  List attaches = [];

  CompanyInfo({
    this.organizeName,
    this.organizeSocialCode,
    this.legalName,
    this.legalIdCardNo,
    this.legalMobile,
    this.organizeRegisteredCapital,
    this.organizeRegisteredTime,
    this.organizeAddress,
    this.contact,
    this.contactMobile,
    this.contactAddress,
    this.attaches,
  });
}
