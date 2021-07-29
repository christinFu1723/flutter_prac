import 'package:demo7_pro/utils/app.dart' show AppUtil;
import 'package:demo7_pro/utils/validate.dart' show ValidateUtil;
import 'package:demo7_pro/utils/string.dart' show StringUtil;

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

  bool validateForm() {
    try {
      var errorMsg = '';
      if (StringUtil.isEmpty(this.organizeName)) {
        errorMsg+='企业名称,';
      }
      if (StringUtil.isEmpty(this.organizeSocialCode)) {
        errorMsg+='信用代码,';
      }
      if (StringUtil.isEmpty(this.legalName)) {
        errorMsg+='法人,';
      }
      if (!ValidateUtil.isMobile(this.legalMobile)) {
        errorMsg+='法人手机号,';
      }

      if (!ValidateUtil.isIdCard(this.legalIdCardNo)) {

        errorMsg+='法人身份证,';
      }
      if (!ValidateUtil.isPrice(this.organizeRegisteredCapital)) {
        errorMsg+='注册资本(最多支持2位小数),';
      }
      if (StringUtil.isEmpty(this.organizeRegisteredTime)) {
        errorMsg+='注册时间,';
      }
      if (StringUtil.isEmpty(this.organizeAddress)) {
        errorMsg+='注册地址,';
      }
      if (StringUtil.isEmpty(this.contact)) {
        errorMsg+='联系人,';
      }
      if (!ValidateUtil.isMobile(this.contactMobile)) {
        errorMsg+='联系人电话,';
      }
      if (StringUtil.isEmpty(this.organizeName)) {
        errorMsg+='企业名称,';
      }
      if (!ValidateUtil.verifyObjArrFilled(arr:this.attaches,key:'attachUrl')) {
        errorMsg+='证照信息,';
      }

      if(errorMsg!=''){
        errorMsg='请正确填写：'+errorMsg;
        errorMsg=StringUtil.spliceChar(errorMsg,',');
        throw errorMsg;
      }
      return true;
    } catch (e) {
      AppUtil.showToast(e);
      return false;
    }
  }
}
