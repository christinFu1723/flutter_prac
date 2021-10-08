import 'package:demo7_pro/json/template_variable_type_entity.dart';

templateVariableTypeEntityFromJson(TemplateVariableTypeEntity data, Map<String, dynamic> json) {
	if (json['variableNo'] != null) {
		data.variableNo = json['variableNo'].toString();
	}
	if (json['variableName'] != null) {
		data.variableName = json['variableName'].toString();
	}
	if (json['variableType'] != null) {
		data.variableType = json['variableType'].toString();
	}
	if (json['variableCategoryType'] != null) {
		data.variableCategoryType = json['variableCategoryType'].toString();
	}
	if (json['required'] != null) {
		data.required = json['required'].toString();
	}
	if (json['variableValue'] != null) {
		data.variableValue = json['variableValue'].toString();
	}
	return data;
}

Map<String, dynamic> templateVariableTypeEntityToJson(TemplateVariableTypeEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['variableNo'] = entity.variableNo;
	data['variableName'] = entity.variableName;
	data['variableType'] = entity.variableType;
	data['variableCategoryType'] = entity.variableCategoryType;
	data['required'] = entity.required;
	data['variableValue'] = entity.variableValue;
	return data;
}