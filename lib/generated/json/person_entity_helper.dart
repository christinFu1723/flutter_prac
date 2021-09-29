import 'package:demo7_pro/json/person_entity.dart';

personEntityFromJson(PersonEntity data, Map<String, dynamic> json) {
	if (json['type'] != null) {
		data.type = json['type'].toString();
	}
	return data;
}

Map<String, dynamic> personEntityToJson(PersonEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['type'] = entity.type;
	return data;
}