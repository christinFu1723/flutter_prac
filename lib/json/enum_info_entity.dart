import 'package:demo7_pro/generated/json/base/json_convert_content.dart';

class EnumInfoEntity with JsonConvert<EnumInfoEntity> {
  String value;
  String displayName;
}

// 模板变量分类枚举
List<EnumInfoEntity> TemplateVariableCategoryList = [
  EnumInfoEntity()
    ..value = "SYSTEM"
    ..displayName = "系统变量",
  EnumInfoEntity()
    ..value = "CUSTOMIZE"
    ..displayName = "自定义变量",
];


