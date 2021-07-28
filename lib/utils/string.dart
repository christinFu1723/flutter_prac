// 文本辅助处理
import 'dart:math';

class StringUtil {
  /// 剪裁掉字符串最后一个指定字符
  static String spliceChar(String str,String char){
    var respStr = str??'';
    var index =respStr.lastIndexOf(char);
    if(index>0&&index<respStr.length-1){
      respStr=respStr.substring(0, index)+respStr.substring(index+1, respStr.length);
    }
    return respStr;
  }

  /// 是否为空
  ///
  /// .e.g `StringUtil.isEmpty('anything')`
  static bool isEmpty(String string) {
    return string == null || string == '' || string.isEmpty;
  }

  /// 任意类型转换为 double
  static double asDouble(dynamic value) {
    if (value == null) return null;
    return double.parse(value.toString());
  }

  /// 任意类型转换为 double
  static int asInt(dynamic value) {
    if (value == null) return null;
    return int.parse(value.toString());
  }

  /// 文本脱敏
  static String safeString(
    String value, {
    String replacement: '*',
    int before: 1,
    int after: 1,
  }) {
    if (isEmpty(value)) return null;

    int length = value.length;

    if (length == 1) return replacement;

    // 转换为 charCodes，避免因存在 emoji 导致截取失败
    List<int> codes = List.from(value.runes);

    /// 省略长度
    int replaceLen = min(4, length - before - after);

    /// 省略号构造
    String _replace = replacement * replaceLen;

    String _firstWorld = String.fromCharCodes([...codes].sublist(0, before));

    String _lastWorld =
        String.fromCharCodes([...codes].sublist(codes.length - after));

    if (length <= 2) {
      return '$_firstWorld$replacement';
    }

    return '$_firstWorld$_replace$_lastWorld';
  }

  /// 手机号脱敏
  ///
  /// 默认把手机号 [mobile] 修正为脱敏状态的文本，可以使用 [replacement] 指定需要替换的字符；
  /// [before] 标识字符串前部保留位数，[after]为后面保留位数；
  ///
  /// .e.g `StringUtil.safeMobile('13628445041')`，返回 `136****5041`;
  ///
  /// .e.g `StringUtil.safeMobile('13628445041', before: 2, after: 3)`，返回 `138*****041`;
  static String safeMobile(
    String mobile, {
    String replacement: '*',
    int before: 3,
    int after: 4,
  }) {
    if (isEmpty(mobile)) return null;

    /// 手机号格式验证
    RegExp regExpMobile = RegExp(
        '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$');
    if (!regExpMobile.hasMatch(mobile)) return mobile;

    int length = mobile.length;

    String _before = mobile.substring(0, before);

    String _after = mobile.substring(length - after);

    String _replace = List<String>.filled(
      max(0, length - (before + after)),
      replacement,
      growable: true,
    ).join('');

    return '$_before$_replace$_after';
  }

  /// 数字溢出限定
  static String numMax(int value, {max: 999}) {
    if (value == null) return null;
    if (value < max) return value.toString();
    return '$max+';
  }
}
