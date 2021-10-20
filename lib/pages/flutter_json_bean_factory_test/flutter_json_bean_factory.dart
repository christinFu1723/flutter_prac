import 'package:flutter/material.dart';
import 'package:demo7_pro/generated/json/base/json_convert_content.dart'
    show JsonConvert;

import 'package:demo7_pro/json/test_entity.dart' show TestEntity;

class FlutterJsonBeanFactoryPage extends StatefulWidget {
  @override
  _FlutterJsonBeanFactoryState createState() => _FlutterJsonBeanFactoryState();
}

class _FlutterJsonBeanFactoryState extends State<FlutterJsonBeanFactoryPage> {
  final testPersion = {'name': '我是测试名称', 'age': 13, 'title': '圣诞节华盛顿金黄色的'};

  TestEntity testPersionObject;

  TestEntity testPersionObject2;

  Map<String,dynamic> jsonTestVal;

  @override
  void initState() {
    // TODO: implement initState
    testPersionObject = TestEntity().fromJson(testPersion); // 调用对象实例方法

    testPersionObject2 = JsonConvert.fromJsonAsT(testPersion); // 调用static 类方法

    jsonTestVal = testPersionObject.toJson();
    setState(() {

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Text('测试FlutterJsonBeanFactory'),
        Text('先把测试数据转化为flutter class object,查看object.name:'),
        Text('${testPersionObject?.name}'),
        Text('先把测试数据转化为flutter class object2,查看object2.age:'),
        Text('${testPersionObject2?.age}'),
        Text('再把class object反逆转成json:'),
        Text('$jsonTestVal'),
      ]),
    );
  }
}
