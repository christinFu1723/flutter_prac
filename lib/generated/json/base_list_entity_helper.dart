import 'package:demo7_pro/json/base_list_entity.dart';

baseListEntityFromJson(BaseListEntity data, Map<String, dynamic> json) {
	if (json['timestamp'] != null) {
		data.timestamp = json['timestamp'].toString();
	}
	if (json['code'] != null) {
		data.code = json['code'] is String
				? int.tryParse(json['code'])
				: json['code'].toInt();
	}
	if (json['message'] != null) {
		data.message = json['message'].toString();
	}
	if (json['data'] != null) {
		data.data = (json['data'] as List).map((v) => v).toList().cast<dynamic>();
	}
	return data;
}

Map<String, dynamic> baseListEntityToJson(BaseListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['timestamp'] = entity.timestamp;
	data['code'] = entity.code;
	data['message'] = entity.message;
	data['data'] = entity.data;
	return data;
}