import 'package:demo7_pro/json/template_variable_type_entity.dart';
import 'package:demo7_pro/generated/json/base/json_convert_content.dart';

class TemplateInfoEntity with JsonConvert<TemplateInfoEntity> {
	String templateNo;
	String templateName;
	String templateHtml;
	List<TemplateVariableTypeEntity> variables;
}