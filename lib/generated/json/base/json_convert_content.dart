// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

// This file is automatically generated. DO NOT EDIT, all your changes would be lost.
import 'package:demo7_pro/json/template_info_entity.dart';
import 'package:demo7_pro/generated/json/template_info_entity_helper.dart';
import 'package:demo7_pro/json/enum_info_entity.dart';
import 'package:demo7_pro/generated/json/enum_info_entity_helper.dart';
import 'package:demo7_pro/json/test_entity.dart';
import 'package:demo7_pro/generated/json/test_entity_helper.dart';
import 'package:demo7_pro/json/person_entity.dart';
import 'package:demo7_pro/generated/json/person_entity_helper.dart';
import 'package:demo7_pro/json/template_variable_type_entity.dart';
import 'package:demo7_pro/generated/json/template_variable_type_entity_helper.dart';

class JsonConvert<T> {
	T fromJson(Map<String, dynamic> json) {
		return _getFromJson<T>(runtimeType, this, json);
	}

  Map<String, dynamic> toJson() {
		return _getToJson<T>(runtimeType, this);
  }

  static _getFromJson<T>(Type type, data, json) {
		switch (type) {
			case TemplateInfoEntity:
				return templateInfoEntityFromJson(data as TemplateInfoEntity, json) as T;
			case EnumInfoEntity:
				return enumInfoEntityFromJson(data as EnumInfoEntity, json) as T;
			case TestEntity:
				return testEntityFromJson(data as TestEntity, json) as T;
			case PersonEntity:
				return personEntityFromJson(data as PersonEntity, json) as T;
			case TemplateVariableTypeEntity:
				return templateVariableTypeEntityFromJson(data as TemplateVariableTypeEntity, json) as T;    }
		return data as T;
	}

  static _getToJson<T>(Type type, data) {
		switch (type) {
			case TemplateInfoEntity:
				return templateInfoEntityToJson(data as TemplateInfoEntity);
			case EnumInfoEntity:
				return enumInfoEntityToJson(data as EnumInfoEntity);
			case TestEntity:
				return testEntityToJson(data as TestEntity);
			case PersonEntity:
				return personEntityToJson(data as PersonEntity);
			case TemplateVariableTypeEntity:
				return templateVariableTypeEntityToJson(data as TemplateVariableTypeEntity);
			}
			return data as T;
		}
  //Go back to a single instance by type
	static _fromJsonSingle<M>( json) {
		String type = M.toString();
		if(type == (TemplateInfoEntity).toString()){
			return TemplateInfoEntity().fromJson(json);
		}
		if(type == (EnumInfoEntity).toString()){
			return EnumInfoEntity().fromJson(json);
		}
		if(type == (TestEntity).toString()){
			return TestEntity().fromJson(json);
		}
		if(type == (PersonEntity).toString()){
			return PersonEntity().fromJson(json);
		}
		if(type == (TemplateVariableTypeEntity).toString()){
			return TemplateVariableTypeEntity().fromJson(json);
		}

		return null;
	}

  //list is returned by type
	static M _getListChildType<M>(List data) {
		if(<TemplateInfoEntity>[] is M){
			return data.map<TemplateInfoEntity>((e) => TemplateInfoEntity().fromJson(e)).toList() as M;
		}
		if(<EnumInfoEntity>[] is M){
			return data.map<EnumInfoEntity>((e) => EnumInfoEntity().fromJson(e)).toList() as M;
		}
		if(<TestEntity>[] is M){
			return data.map<TestEntity>((e) => TestEntity().fromJson(e)).toList() as M;
		}
		if(<PersonEntity>[] is M){
			return data.map<PersonEntity>((e) => PersonEntity().fromJson(e)).toList() as M;
		}
		if(<TemplateVariableTypeEntity>[] is M){
			return data.map<TemplateVariableTypeEntity>((e) => TemplateVariableTypeEntity().fromJson(e)).toList() as M;
		}

		throw Exception("not found");
	}

  static M fromJsonAsT<M>(json) {
		if (json is List) {
			return _getListChildType<M>(json);
		} else {
			return _fromJsonSingle<M>(json) as M;
		}
	}
}