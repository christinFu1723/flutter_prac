import 'package:demo7_pro/json/template_info_entity.dart';
import 'package:demo7_pro/json/template_variable_type_entity.dart';

templateInfoEntityFromJson(TemplateInfoEntity data, Map<String, dynamic> json) {
	if (json['templateNo'] != null) {
		data.templateNo = json['templateNo'].toString();
	}
	if (json['templateName'] != null) {
		data.templateName = json['templateName'].toString();
	}
	if (json['templateHtml'] != null) {
		data.templateHtml = json['templateHtml'].toString();
	}
	if (json['variables'] != null) {
		data.variables = (json['variables'] as List).map((v) => TemplateVariableTypeEntity().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> templateInfoEntityToJson(TemplateInfoEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['templateNo'] = entity.templateNo;
	data['templateName'] = entity.templateName;
	data['templateHtml'] = entity.templateHtml;
	data['variables'] =  entity.variables?.map((v) => v.toJson())?.toList();
	return data;
}