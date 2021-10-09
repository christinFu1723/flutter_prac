import 'package:demo7_pro/json/base_entity.dart';

baseEntityFromJson(BaseEntity data, Map<String, dynamic> json) {
	if (json['timestamp'] != null) {
		data.timestamp = json['timestamp'].toString();
	}
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['error'] != null) {
		data.error = json['error'].toString();
	}
	if (json['message'] != null) {
		data.message = json['message'].toString();
	}
	if (json['data'] != null) {
		data.data = json['data'];
	}
	return data;
}

Map<String, dynamic> baseEntityToJson(BaseEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['timestamp'] = entity.timestamp;
	data['code'] = entity.code;
	data['error'] = entity.error;
	data['message'] = entity.message;
	data['data'] = entity.data;
	return data;
}