import 'package:demo7_pro/generated/json/base/json_convert_content.dart';

class TemplateVariableTypeEntity with JsonConvert<TemplateVariableTypeEntity> {
	String variableNo;
	String variableName;
	String variableType;
	String variableCategoryType;
	String required;

	String variableValue;
}
