import 'package:demo7_pro/generated/json/base/json_convert_content.dart';

class GetListEntity with JsonConvert<GetListEntity> {
	int total;
	List<GetListData> data;
}

class GetListData with JsonConvert<GetListData> {
	String organizeNo;
	String organizeName;
	String organizeStatus;
	dynamic auditor;
	dynamic auditTime;
	String platformAccountName;
	String gmtCreate;
}
