import 'package:demo7_pro/utils/string.dart';

/// 验证辅助
class ValidateUtil {
  /// 是否为手机号
  static bool isMobile(String mobile) {
    if (StringUtil.isEmpty(mobile)) return false;
    return RegExp(r'^1[0-9]{10}').hasMatch(mobile);
  }

  /// 是否为座机
  static bool isPhone(String phone) {
    if (StringUtil.isEmpty(phone)) return false;
    return RegExp(r'^[0][1-9]{2,3}-[0-9]{5,10}$').hasMatch(phone);
  }

  /// 是否为身份证号
  static bool isIdCard(String id) {

    if (StringUtil.isEmpty(id)) return false;
    return RegExp(r'(^[1-9]\d{5}\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}$)|(^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$)').hasMatch(id);
  }

  /// 是否为指定长度的验证码
  static bool isSMSCodeWithLength(String code, [int length = 4]) {
    return RegExp(r'^[0-9]+{$length}').hasMatch(code);
  }

  /// 是否为统一社会信用代码
  static bool isCreditCode(String code) {
    return RegExp(r'^[^_IOZSV\W]{2}\d{6}[^_IOZSV\W]{10}').hasMatch(code);
  }

  /// 是否为银行卡号
  static bool isBankCardCode(String code) {
    return RegExp(r'^([1-9]{1})(\d{14,19})').hasMatch(code);
  }

  /// 是否为车牌，支持新能源
  static bool isPlate(String value) {
    return RegExp(
                r"^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-HJ-NP-Z0-9]{4}[A-HJ-NP-Z0-9挂学警港澳]{1}$")
            .hasMatch(value) ||
        isNewEnergy(value);
  }

  /// 是否为新能源号牌
  static bool isNewEnergy(String value) {
    return RegExp(
            r"^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领]{1}[A-Z]{1}[0-9A-Z]{6}$")
        .hasMatch(value);
  }

  /// 是否为车架号
  static bool isVinCode(String code) {
    return RegExp(r'^[A-HJ-NPR-Z\d]{17}').hasMatch(code);
  }

  /// 是否为发动机号
  static bool isEngineCode(String code) {
    return RegExp("/\d{6}[A-Z]{1}\$/").hasMatch(code) ||
        RegExp(r'^[0-9A-Za-z\-\－\u4e00-\u9fa5]{1,20}').hasMatch(code);
  }
}
