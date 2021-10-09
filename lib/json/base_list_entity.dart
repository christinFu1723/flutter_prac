import 'package:demo7_pro/generated/json/base/json_convert_content.dart';


class BaseListEntity with JsonConvert<BaseListEntity> {

	bool get success => code == 200;

	// 时间戳
	String timestamp;

	// 自定义响应代码，为 200 时认为是 操作成功
	int code;

	// 附加的消息文本
	String message;

	List<dynamic> data;
}
