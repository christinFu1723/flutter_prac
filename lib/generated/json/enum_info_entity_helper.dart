import 'package:demo7_pro/json/enum_info_entity.dart';

enumInfoEntityFromJson(EnumInfoEntity data, Map<String, dynamic> json) {
	if (json['value'] != null) {
		data.value = json['value'].toString();
	}
	if (json['displayName'] != null) {
		data.displayName = json['displayName'].toString();
	}
	return data;
}

Map<String, dynamic> enumInfoEntityToJson(EnumInfoEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['value'] = entity.value;
	data['displayName'] = entity.displayName;
	return data;
}