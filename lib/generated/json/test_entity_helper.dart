import 'package:demo7_pro/json/test_entity.dart';

testEntityFromJson(TestEntity data, Map<String, dynamic> json) {
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['age'] != null) {
		data.age = json['age'] is String
				? int.tryParse(json['age'])
				: json['age'].toInt();
	}
	if (json['title'] != null) {
		data.title = json['title'].toString();
	}
	return data;
}

Map<String, dynamic> testEntityToJson(TestEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['name'] = entity.name;
	data['age'] = entity.age;
	data['title'] = entity.title;
	return data;
}